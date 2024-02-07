library ieee; 
use ieee.std_logic_1164.all;

entity dff is
    port(
        clk : in  std_logic;
        D   : in  std_logic; 
        Q   : out std_logic );
end dff;

architecture behavioral of dff is
begin
    process(clk) begin
        if rising_edge(clk) then
            Q <= D;
    end if;
    end process;
end architecture behavioral;
