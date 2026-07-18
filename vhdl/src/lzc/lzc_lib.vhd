-- args: --std=08 --ieee=synopsys

library ieee;
  use ieee.std_logic_1164.all;

package lzc_lib is

  component lzc_4 is
    port (
      a : in    std_logic_vector(3 downto 0);
      z : out   std_logic_vector(1 downto 0);
      v : out   std_logic
    );
  end component lzc_4;

  component lzc_8 is
    port (
      a : in    std_logic_vector(7 downto 0);
      z : out   std_logic_vector(2 downto 0);
      v : out   std_logic
    );
  end component lzc_8;

  component lzc_16 is
    port (
      a : in    std_logic_vector(15 downto 0);
      z : out   std_logic_vector(3 downto 0);
      v : out   std_logic
    );
  end component lzc_16;

  component lzc_32 is
    port (
      a : in    std_logic_vector(31 downto 0);
      z : out   std_logic_vector(4 downto 0);
      v : out   std_logic
    );
  end component lzc_32;

  component lzc_64 is
    port (
      a : in    std_logic_vector(63 downto 0);
      z : out   std_logic_vector(5 downto 0);
      v : out   std_logic
    );
  end component lzc_64;

  component lzc_128 is
    port (
      a : in    std_logic_vector(127 downto 0);
      z : out   std_logic_vector(6 downto 0);
      v : out   std_logic
    );
  end component lzc_128;

  component lzc_256 is
    port (
      a : in    std_logic_vector(255 downto 0);
      z : out   std_logic_vector(7 downto 0);
      v : out   std_logic
    );
  end component lzc_256;

end package lzc_lib;
