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

entity test_float_p is
end entity test_float_p;

architecture behavior of test_float_p is

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
		enable      : std_logic;
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
		enable      => '0'
	);

	signal reset : std_logic := '0';
	signal clock : std_logic := '0';

	signal r_1 : fpu_test_reg_type;
	signal r_2 : fpu_test_reg_type;
	signal r_3 : fpu_test_reg_type;
	signal r_4 : fpu_test_reg_type;
	signal r_5 : fpu_test_reg_type;

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

	process(clock)
		file infile     : text open read_mode is "fpu.dat";
		variable inline : line;

		variable initial : fpu_test_reg_type;
		variable final   : fpu_test_reg_type;

	begin
		if rising_edge(clock) then

			if reset = '0' then

				initial := init_fpu_test_reg;

				r_1 <= init_fpu_test_reg;
				r_2 <= init_fpu_test_reg;
				r_3 <= init_fpu_test_reg;
				r_4 <= init_fpu_test_reg;
				r_5 <= init_fpu_test_reg;

				fpu_i.fp_exe_i.enable <= '0';

			else

				initial := init_fpu_test_reg;

				if endfile(infile) then
					print("TEST SUCCEEDED");
					finish;
				end if;

				readline(infile, inline);
				hread(inline, initial.dataread);

				initial.data1 := initial.dataread(287 downto 224);
				initial.data2 := initial.dataread(223 downto 160);
				initial.data3 := initial.dataread(159 downto 96);
				initial.result := initial.dataread(95 downto 32);
				initial.flags := initial.dataread(28 downto 24);
				initial.fmt := initial.dataread(21 downto 20);
				initial.rm := initial.dataread(18 downto 16);
				initial.conv := initial.dataread(13 downto 12);
				initial.opcode := initial.dataread(9 downto 0);

				initial.op.fmadd := initial.opcode(0);
				initial.op.fadd := initial.opcode(1);
				initial.op.fsub := initial.opcode(2);
				initial.op.fmul := initial.opcode(3);
				initial.op.fdiv := initial.opcode(4);
				initial.op.fsqrt := initial.opcode(5);
				initial.op.fcmp := initial.opcode(6);
				initial.op.fcvt_f2f := initial.opcode(7);
				initial.op.fcvt_i2f := initial.opcode(8);
				initial.op.fcvt_f2i := initial.opcode(9);
				initial.op.fcvt_op := initial.conv(1 downto 0);

				initial.enable := '1';

				r_1 <= initial;
				r_2 <= r_1;
				r_3 <= r_2;
				r_4 <= r_3;
				r_5 <= r_4;

			end if;

			fpu_i.fp_exe_i.data1 <= initial.data1;
			fpu_i.fp_exe_i.data2 <= initial.data2;
			fpu_i.fp_exe_i.data3 <= initial.data3;
			fpu_i.fp_exe_i.op <= initial.op;
			fpu_i.fp_exe_i.fmt <= initial.fmt;
			fpu_i.fp_exe_i.rm <= initial.rm;
			fpu_i.fp_exe_i.enable <= initial.enable;

			if fpu_o.fp_exe_o.ready = '1' then

				final := r_5;

				final.flags_orig := final.flags;
				final.result_orig := final.result;

				final.result_calc := fpu_o.fp_exe_o.result;
				final.flags_calc := fpu_o.fp_exe_o.flags;

				if (final.op.fcvt_f2i = '0') and (final.result_calc = x"000000007FC00000") then
					final.result_diff := x"00000000" & "0" & (final.result_orig(30 downto 22) xor final.result_calc(30 downto 22)) & "00" & x"00000";
				elsif (final.op.fcvt_f2i = '0') and (final.result_calc = x"7FF8000000000000") then
					final.result_diff := "0" & (final.result_orig(62 downto 51) xor final.result_calc(62 downto 51)) & "000" & x"000000000000";
				else
					final.result_diff := final.result_orig xor final.result_calc;
				end if;
				final.flags_diff := final.flags_orig xor final.flags_calc;

			end if;

			if (or final.result_diff = '1') or (or final.flags_diff = '1') then
				print("TEST FAILED");
				print("A                 = 0x" & to_hstring(final.data1));
				print("B                 = 0x" & to_hstring(final.data2));
				print("C                 = 0x" & to_hstring(final.data3));
				print("RESULT DIFFERENCE = 0x" & to_hstring(final.result_diff));
				print("RESULT REFERENCE  = 0x" & to_hstring(final.result_orig));
				print("RESULT CALCULATED = 0x" & to_hstring(final.result_calc));
				print("FLAGS DIFFERENCE  = 0x" & to_hstring(final.flags_diff));
				print("FLAGS REFERENCE   = 0x" & to_hstring(final.flags_orig));
				print("FLAGS CALCULATED  = 0x" & to_hstring(final.flags_calc));
				finish;
			end if;

		end if;

	end process;

end architecture;
