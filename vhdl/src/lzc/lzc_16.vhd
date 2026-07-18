-- args: --std=08 --ieee=synopsys

library ieee;
  use ieee.std_logic_1164.all;
  use work.lzc_lib.all;

entity lzc_16 is
  port (
    a : in    std_logic_vector(15 downto 0);
    z : out   std_logic_vector(3 downto 0);
    v : out   std_logic
  );
end entity lzc_16;

architecture behavior of lzc_16 is

  signal z0 : std_logic_vector(2 downto 0);
  signal z1 : std_logic_vector(2 downto 0);

  signal v0 : std_logic;
  signal v1 : std_logic;

  signal s0 : std_logic;
  signal s1 : std_logic;
  signal s2 : std_logic;
  signal s3 : std_logic;
  signal s4 : std_logic;
  signal s5 : std_logic;
  signal s6 : std_logic;

begin

  lzc_8_comp_0 : component lzc_8
    port map (
      a => a(7 downto 0),
      z => z0,
      v => v0
    );

  lzc_8_comp_1 : component lzc_8
    port map (
      a => a(15 downto 8),
      z => z1,
      v => v1
    );

  s0 <= v1 or v0;
  s1 <= (not v1) and z0(0);
  s2 <= z1(0) or s1;
  s3 <= (not v1) and z0(1);
  s4 <= z1(1) or s3;
  s5 <= (not v1) and z0(2);
  s6 <= z1(2) or s5;

  v    <= s0;
  Z(0) <= s2;
  Z(1) <= s4;
  Z(2) <= s6;
  Z(3) <= v1;

end architecture behavior;
