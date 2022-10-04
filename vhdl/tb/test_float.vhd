-- args: --std=08 --ieee=synopsys

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

use work.lzc_wire.all;
use work.fp_cons.all;
use work.fp_wire.all;
use work.all;

library std;
use std.textio.all;
use std.env.all;

entity test_float is
end entity test_float;

architecture behavior of test_float is

	component fp_unit
		port(
			reset     : in  std_logic;
			clock     : in  std_logic;
			fp_unit_i : in  fp_unit_in_type;
			fp_unit_o : out fp_unit_out_type
		);
	end component;

	type test_state_type is (TEST0, TEST1);

	type fpu_test_reg_type is record
		dataread    : std_logic_vector(287 downto 0);
		state       : test_state_type;
		opcode      : std_logic_vector(9 downto 0);
		conv        : std_logic_vector(1 downto 0);
		data1       : std_logic_vector(63 downto 0);
		data2       : std_logic_vector(63 downto 0);
		data3       : std_logic_vector(63 downto 0);
		result      : std_logic_vector(63 downto 0);
		flags       : std_logic_vector(4 downto 0);
		fmt         : std_logic_vector(1 downto 0);
		rm          : std_logic_vector(2 downto 0);
		op          : fp_operation_type;
		result_orig : std_logic_vector(63 downto 0);
		result_calc : std_logic_vector(63 downto 0);
		result_diff : std_logic_vector(63 downto 0);
		flags_orig  : std_logic_vector(4 downto 0);
		flags_calc  : std_logic_vector(4 downto 0);
		flags_diff  : std_logic_vector(4 downto 0);
		terminate   : std_logic;
	end record;

	constant init_fpu_test_reg : fpu_test_reg_type := (
		dataread    => (others => '0'),
		state       => TEST0,
		opcode      => (others => '0'),
		conv        => (others => '0'),
		data1       => (others => '0'),
		data2       => (others => '0'),
		data3       => (others => '0'),
		result      => (others => '0'),
		flags       => (others => '0'),
		fmt         => (others => '0'),
		rm          => (others => '0'),
		op          => init_fp_operation,
		result_orig => (others => '0'),
		result_calc => (others => '0'),
		result_diff => (others => '0'),
		flags_orig  => (others => '0'),
		flags_calc  => (others => '0'),
		flags_diff  => (others => '0'),
		terminate   => '0'
	);

	signal reset : std_logic := '0';
	signal clock : std_logic := '0';

	signal r   : fpu_test_reg_type;
	signal rin : fpu_test_reg_type;

	signal fpu_i : fp_unit_in_type;
	signal fpu_o : fp_unit_out_type;

	procedure print(
		msg : in string) is
		variable buf : line;
	begin
		write(buf, msg);
		writeline(output, buf);
	end procedure print;

begin

	reset <= '1' after 1 ns;
	clock <= not clock after 1 ns;

	fp_unit_comp : fp_unit
		port map(
			reset     => reset,
			clock     => clock,
			fp_unit_i => fpu_i,
			fp_unit_o => fpu_o
		);

	process(reset, clock)
		file infile     : text open read_mode is "fpu.dat";
		variable inline : line;

		variable v : fpu_test_reg_type;

	begin
		if rising_edge(clock) then

			if reset = '0' then

				r <= init_fpu_test_reg;

			else

				v := r;

				if endfile(infile) then
					v.terminate := '1';
					v.dataread := (others => '0');
				else
					readline(infile, inline);
					hread(inline, v.dataread);
				end if;

				v.data1 := v.dataread(287 downto 224);
				v.data2 := v.dataread(223 downto 160);
				v.data3 := v.dataread(159 downto 96);
				v.result := v.dataread(95 downto 32);
				v.flags := v.dataread(28 downto 24);
				v.fmt := v.dataread(21 downto 20);
				v.rm := v.dataread(18 downto 16);
				v.conv := v.dataread(13 downto 12);
				v.opcode := v.dataread(9 downto 0);

				v.op.fmadd := v.opcode(0);
				v.op.fadd := v.opcode(1);
				v.op.fsub := v.opcode(2);
				v.op.fmul := v.opcode(3);
				v.op.fdiv := v.opcode(4);
				v.op.fsqrt := v.opcode(5);
				v.op.fcmp := v.opcode(6);
				v.op.fcvt_f2f := v.opcode(7);
				v.op.fcvt_i2f := v.opcode(8);
				v.op.fcvt_f2i := v.opcode(9);
				v.op.fcvt_op := v.conv(1 downto 0);

				fpu_i.fp_exe_i.data1 <= v.data1;
				fpu_i.fp_exe_i.data2 <= v.data2;
				fpu_i.fp_exe_i.data3 <= v.data3;
				fpu_i.fp_exe_i.op <= v.op;
				fpu_i.fp_exe_i.fmt <= v.fmt;
				fpu_i.fp_exe_i.rm <= v.rm;
				fpu_i.fp_exe_i.enable <= '1';

				v.result_orig := r.result;
				v.flags_orig := r.flags;

				v.result_calc := fpu_o.fp_exe_o.result;
				v.flags_calc := fpu_o.fp_exe_o.flags;

				if (v.op.fcvt_f2i = '0' and v.op.fcmp = '0') and (v.result_calc = x"000000007FC00000") then
					v.result_diff := x"00000000" & "0" & (v.result_orig(30 downto 22) xor v.result_calc(30 downto 22)) & "00" & x"00000";
				elsif (v.op.fcvt_f2i = '0' and v.op.fcmp = '0') and (v.result_calc = x"7FF8000000000000") then
					v.result_diff := "0" & (v.result_orig(62 downto 51) xor v.result_calc(62 downto 51)) & "000" & x"000000000000";
				else
					v.result_diff := v.result_orig xor v.result_calc;
				end if;
				v.flags_diff := v.flags_orig xor v.flags_calc;

				if (or v.result_diff = '1') or (or v.flags_diff = '1') then
					print(character'val(27) & "[1;31m" & "TEST FAILED");
					print("A                 = 0x" & to_hstring(r.data1));
					print("B                 = 0x" & to_hstring(r.data2));
					print("C                 = 0x" & to_hstring(r.data3));
					print("RESULT DIFFERENCE = 0x" & to_hstring(v.result_diff));
					print("RESULT REFERENCE  = 0x" & to_hstring(v.result_orig));
					print("RESULT CALCULATED = 0x" & to_hstring(v.result_calc));
					print("FLAGS DIFFERENCE  = 0x" & to_hstring(v.flags_diff));
					print("FLAGS REFERENCE   = 0x" & to_hstring(v.flags_orig));
					print("FLAGS CALCULATED  = 0x" & to_hstring(v.flags_calc) & character'val(27) & "[0m");
					finish;
				elsif (v.terminate = '1') then
					print(character'val(27) & "[1;32m" & "TEST SUCCEEDED" & character'val(27) & "[0m");
					finish;
				end if;

				r <= v;

			end if;

		end if;

	end process;

end architecture;
