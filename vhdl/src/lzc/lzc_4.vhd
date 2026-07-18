-- args: --std=08 --ieee=synopsys

library ieee;
  use ieee.std_logic_1164.all;
  use work.lzc_lib.all;

entity lzc_4 is
  port (
    a : in    std_logic_vector(3 downto 0);
    z : out   std_logic_vector(1 downto 0);
    v : out   std_logic
  );
end entity lzc_4;

architecture behavior of lzc_4 is

  signal a0 : std_logic := '0';
  signal a1 : std_logic := '0';
  signal a2 : std_logic := '0';
  signal a3 : std_logic := '0';

  signal s0 : std_logic;
  signal s1 : std_logic;
  signal s2 : std_logic;
  signal s3 : std_logic;
  signal s4 : std_logic;

begin

  a0 <= a(0);
  a1 <= a(1);
  a2 <= a(2);
  a3 <= a(3);

  s0 <= a3 or a2;
  s1 <= a1 or a0;
  s2 <= s1 or s0;
  s3 <= (not s0) and a1;
  s4 <= a3 or s3;

  v    <= s2;
  Z(0) <= s4;
  Z(1) <= s0;

end architecture behavior;
