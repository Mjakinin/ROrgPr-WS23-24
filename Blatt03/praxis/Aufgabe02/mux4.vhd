library ieee;
use ieee.std_logic_1164.all;

entity mux4 is
    generic(DATA_WIDTH : integer := 32);
    port( a, b, c, d : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
          sel        : in  std_logic_vector(1 downto 0);
          y          : out std_logic_vector(DATA_WIDTH - 1 downto 0) );
end mux4;

architecture behavioral of mux4 is
    begin
        process(a,b,c,d,sel) begin
            if sel(1) = '0' and sel(0) = '0' then
                y <= a;
            elsif sel(1) = '0' and sel(0) = '1' then
                y <= b;
            elsif sel(1) = '1' and sel(0) = '0' then
                y <= c;
            elsif sel(1) = '1' and sel(0) = '1' then
                y <= d;
                end if;
            end process;
    end behavioral;