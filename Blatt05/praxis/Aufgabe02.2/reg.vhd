library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity reg is
    generic(
        WIDTH : integer);
    port(
        clk : in  std_logic;
        rst : in  std_logic;
        en  : in  std_logic;
        D   : in  std_logic_vector(WIDTH - 1 downto 0);
        Q   : out std_logic_vector(WIDTH - 1 downto 0));
end reg;

architecture behavioral of reg is
    signal buffer1 :std_logic_vector(WIDTH-1 downto 0):=(others=>'0');
begin
    process(clk,rst,en) begin
        if rising_edge(clk) then
            if rst = '1' then
                Q <=buffer1;
            elsif en ='1' then
                Q <= D;
            end if;
        end if;
    end process;
end architecture behavioral;
