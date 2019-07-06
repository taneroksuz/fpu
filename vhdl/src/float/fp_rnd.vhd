-- args: --std=08 --ieee=synopsys

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.lzc_wire.all;
use work.fp_cons.all;
use work.fp_wire.all;

entity fp_rnd is
	port(
		fp_rnd_i : in  fp_rnd_in_type;
		fp_rnd_o : out fp_rnd_out_type
	);
end fp_rnd;

architecture behavior of fp_rnd is

begin

	process(fp_rnd_i)
		variable sig  : std_logic;
		variable expo : integer range -8191 to 8191;
		variable mant : std_logic_vector(53 downto 0);
		variable rema : std_logic_vector(1 downto 0);
		variable fmt  : std_logic_vector(1 downto 0);
		variable rm   : std_logic_vector(2 downto 0);
		variable grs  : std_logic_vector(2 downto 0);
		variable snan : std_logic;
		variable qnan : std_logic;
		variable dbz  : std_logic;
		variable inf  : std_logic;
		variable zero : std_logic;

		variable odd : std_logic;

		variable rnded : natural range 0 to 1;

		variable result : std_logic_vector(63 downto 0);
		variable flags  : std_logic_vector(4 downto 0);

	begin
		sig  := fp_rnd_i.sig;
		expo := fp_rnd_i.expo;
		mant := fp_rnd_i.mant;
		rema := fp_rnd_i.rema;
		fmt  := fp_rnd_i.fmt;
		rm   := fp_rnd_i.rm;
		grs  := fp_rnd_i.grs;
		snan := fp_rnd_i.snan;
		qnan := fp_rnd_i.qnan;
		dbz  := fp_rnd_i.dbz;
		inf  := fp_rnd_i.inf;
		zero := fp_rnd_i.zero;

		result := 64X"0";
		flags  := "00000";

		odd := mant(0) or or(grs(1 downto 0)) or to_std_logic(rema = 2X"1");
		flags(0)     := to_std_logic(rema /= 2X"0") or or(grs);

		rnded := 0;
		case rm is
			when "000" =>               --rne--
				if grs(2) and odd then
					rnded := 1;
				end if;
			when "001" =>               --rtz--
				null;
			when "010" =>               --rdn--
				if sig and flags(0) then
					rnded := 1;
				end if;
			when "011" =>               --rup--
				if not sig and flags(0) then
					rnded := 1;
				end if;
			when "100" =>               --rmm--
				if flags(0) then
					rnded := 1;
				end if;
			when others =>
				null;
		end case;

		if expo = 0 then
			flags(1) := flags(0);
		end if;

		mant := std_logic_vector(unsigned(mant) + rnded);

		rnded := 0;
		if fmt = "00" then
			if mant(24) then
				rnded := 1;
			elsif mant(23) then
				if expo = 0 then
					expo := 1;
					if expo = 1 then
						flags(1) := not grs(1);
					end if;
				end if;
			end if;
		elsif fmt = "01" then
			if mant(53) then
				rnded := 1;
			elsif mant(52) then
				if expo = 0 then
					expo := 1;
					if expo = 1 then
						flags(1) := not grs(1);
					end if;
				end if;
			end if;
		end if;

		expo := expo + rnded;
		mant := mant srl rnded;

		if snan then
			flags := "10000";
		elsif qnan then
			flags := "00000";
		elsif dbz then
			flags := "01000";
		elsif inf then
			flags := "00000";
		elsif zero then
			flags := "00000";
		end if;

		if fmt = "00" then
			if snan or qnan then
				result := 32X"00000000" & '0' & 9X"1FF" & 22x"000000";
			elsif dbz or inf then
				result := 32X"00000000" & sig & 8X"FF" & 23x"000000";
			elsif zero then
				result := 32X"00000000" & sig & 8X"00" & 23x"000000";
			elsif expo = 0 then
				result := 32X"00000000" & sig & 8X"00" & mant(22 downto 0);
			elsif expo > 254 then
				flags  := "00101";
				result := 32X"00000000" & sig & 8X"FF" & 23x"000000";
			else
				result := 32X"00000000" & sig & std_logic_vector(to_unsigned(expo, 8)) & mant(22 downto 0);
			end if;
		elsif fmt = "01" then
			if snan or qnan then
				result := '0' & 12X"FFF" & 51X"0000000000000";
			elsif dbz or inf then
				result := sig & 11X"7FF" & 52X"0000000000000";
			elsif zero then
				result := sig & 11X"000" & 52X"0000000000000";
			elsif expo = 0 then
				result := sig & 11X"000" & mant(51 downto 0);
			elsif expo > 2046 then
				flags  := "00101";
				result := sig & 11X"7FF" & 52X"0000000000000";
			else
				result := sig & std_logic_vector(to_unsigned(expo, 11)) & mant(51 downto 0);
			end if;
		end if;

		fp_rnd_o.result <= result;
		fp_rnd_o.flags <= flags;

	end process;

end behavior;
