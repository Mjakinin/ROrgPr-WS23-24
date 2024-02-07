library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clkReduce is
    generic( divisor : integer := 4 );
    port( clk_in  : in  std_logic;
          clk_out : out std_logic );
end clkReduce;

architecture behavioral of clkReduce is
signal counter : integer range 0 to divisor - 1 := 0;
signal clk_out_int : STD_LOGIC := '0';
begin
    process(clk_in)
    begin
        if rising_edge(clk_in) or falling_edge(clk_in) then
            if counter = divisor - 1 then
                counter <= 0;
                clk_out_int <= not clk_out_int;
            elsif counter > divisor then
                    counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    clk_out <= clk_out_int;
end behavioral;
