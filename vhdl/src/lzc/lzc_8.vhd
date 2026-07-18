-- args: --std=08 --ieee=synopsys

library ieee;
  use ieee.std_logic_1164.all;
  use work.lzc_lib.all;

entity lzc_8 is
  port (
    a : in    std_logic_vector(7 downto 0);
    z : out   std_logic_vector(2 downto 0);
    v : out   std_logic
  );
end entity lzc_8;

architecture behavior of lzc_8 is

  signal z0 : std_logic_vector(1 downto 0);
  signal z1 : std_logic_vector(1 downto 0);

  signal v0 : std_logic;
  signal v1 : std_logic;

  signal s0 : std_logic;
  signal s1 : std_logic;
  signal s2 : std_logic;
  signal s3 : std_logic;
  signal s4 : std_logic;

begin

  lzc_4_comp_0 : component lzc_4
    port map (
      a => a(3 downto 0),
      z => z0,
      v => v0
    );

  lzc_4_comp_1 : component lzc_4
    port map (
      a => a(7 downto 4),
      z => z1,
      v => v1
    );

  s0 <= v1 or v0;
  s1 <= (not v1) and z0(0);
  s2 <= z1(0) or s1;
  s3 <= (not v1) and z0(1);
  s4 <= z1(1) or s3;

  v    <= s0;
  Z(0) <= s2;
  Z(1) <= s4;
  Z(2) <= v1;

end architecture behavior;
