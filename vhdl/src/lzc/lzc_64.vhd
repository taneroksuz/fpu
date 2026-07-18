-- args: --std=08 --ieee=synopsys

library ieee;
  use ieee.std_logic_1164.all;
  use work.lzc_lib.all;

entity lzc_64 is
  port (
    a : in    std_logic_vector(63 downto 0);
    z : out   std_logic_vector(5 downto 0);
    v : out   std_logic
  );
end entity lzc_64;

architecture behavior of lzc_64 is

  signal z0 : std_logic_vector(4 downto 0);
  signal z1 : std_logic_vector(4 downto 0);

  signal v0 : std_logic;
  signal v1 : std_logic;

  signal s0  : std_logic;
  signal s1  : std_logic;
  signal s2  : std_logic;
  signal s3  : std_logic;
  signal s4  : std_logic;
  signal s5  : std_logic;
  signal s6  : std_logic;
  signal s7  : std_logic;
  signal s8  : std_logic;
  signal s9  : std_logic;
  signal s10 : std_logic;

begin

  lzc_32_comp_0 : component lzc_32
    port map (
      a => a(31 downto 0),
      z => z0,
      v => v0
    );

  lzc_32_comp_1 : component lzc_32
    port map (
      a => a(63 downto 32),
      z => z1,
      v => v1
    );

  s0  <= v1 or v0;
  s1  <= (not v1) and z0(0);
  s2  <= z1(0) or s1;
  s3  <= (not v1) and z0(1);
  s4  <= z1(1) or s3;
  s5  <= (not v1) and z0(2);
  s6  <= z1(2) or s5;
  s7  <= (not v1) and z0(3);
  s8  <= z1(3) or s7;
  s9  <= (not v1) and z0(4);
  s10 <= z1(4) or s9;

  v    <= s0;
  Z(0) <= s2;
  Z(1) <= s4;
  Z(2) <= s6;
  Z(3) <= s8;
  Z(4) <= s10;
  Z(5) <= v1;

end architecture behavior;
