-- args: --std=08 --ieee=synopsys

library ieee;
use ieee.std_logic_1164.all;

package fp_cons is

	constant funct_fadd     : std_logic_vector(4 downto 0) := "00000";
	constant funct_fsub     : std_logic_vector(4 downto 0) := "00001";
	constant funct_fmul     : std_logic_vector(4 downto 0) := "00010";
	constant funct_fdiv     : std_logic_vector(4 downto 0) := "00011";
	constant funct_fsqrt    : std_logic_vector(4 downto 0) := "01011";
	constant funct_fsgnj    : std_logic_vector(4 downto 0) := "00100";
	constant funct_fmax     : std_logic_vector(4 downto 0) := "00101";
	constant funct_fcmp     : std_logic_vector(4 downto 0) := "10100";
	constant funct_fclass   : std_logic_vector(4 downto 0) := "11100";
	constant funct_fmv_f2i  : std_logic_vector(4 downto 0) := "11100";
	constant funct_fmv_i2f  : std_logic_vector(4 downto 0) := "11110";
	constant funct_fcvt_f2i : std_logic_vector(4 downto 0) := "11000";
	constant funct_fcvt_i2f : std_logic_vector(4 downto 0) := "11010";
	constant funct_fcvt_f2f : std_logic_vector(4 downto 0) := "01000";

	constant funct_fmadd  : std_logic_vector(6 downto 0) := "1000011";
	constant funct_fmsub  : std_logic_vector(6 downto 0) := "1000111";
	constant funct_fnmsub : std_logic_vector(6 downto 0) := "1001011";
	constant funct_fnmadd : std_logic_vector(6 downto 0) := "1001111";

	constant opcode_fp     : std_logic_vector(6 downto 0) := "1010011";
	constant opcode_fload  : std_logic_vector(6 downto 0) := "0000111";
	constant opcode_fstore : std_logic_vector(6 downto 0) := "0100111";
	constant opcode_fmadd  : std_logic_vector(6 downto 0) := "1000011";
	constant opcode_fmsub  : std_logic_vector(6 downto 0) := "1000111";
	constant opcode_fnmsub : std_logic_vector(6 downto 0) := "1001011";
	constant opcode_fnmadd : std_logic_vector(6 downto 0) := "1001111";

end fp_cons;
