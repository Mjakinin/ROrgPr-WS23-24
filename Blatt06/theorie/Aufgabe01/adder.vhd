library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
    generic(WIDTH : integer := 32);
    port ( a, b  : in  std_logic_vector(WIDTH-1 downto 0);
           sum    : out std_logic_vector(WIDTH-1 downto 0);
           cout   : out std_logic);
end entity;

architecture behavioral of adder is
    component fulladd is
        port ( a, b, cin : in  std_logic;
               sum, cout : out std_logic);
    end component;

    signal carry : std_logic_vector(WIDTH downto 0);
begin
    carry(0) <= '0';  --Carry-In auf 0

    --n-Bit-Addierer durch Iteration von 1-Bit-Volladdierer
    adder_gen: for i in 0 to WIDTH-1 generate
        FullAdder: fulladd port map (a(i), b(i), carry(i), sum(i), carry(i+1));
    end generate;

    cout <= carry(WIDTH);
end architecture behavioral;

