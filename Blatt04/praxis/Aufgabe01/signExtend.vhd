library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signExtend is
    generic(
        INPUT_WIDTH 	: integer;
        OUTPUT_WIDTH 	: integer
    );
    port(
        number 	: in signed(INPUT_WIDTH - 1 downto 0);
        signExtNumber 	: out signed(OUTPUT_WIDTH - 1 downto 0)
    );
end signExtend;

architecture behavioral of signExtend is
begin
process(number) is
    begin
        if number(INPUT_WIDTH - 1) = '1' then -- MSB = 1
            signExtNumber(OUTPUT_WIDTH - 1 downto INPUT_WIDTH) <= (others => '1');
            signExtNumber(INPUT_WIDTH - 1 downto 0) <= number;
        else -- MSB = 0
            signExtNumber(OUTPUT_WIDTH - 1 downto INPUT_WIDTH) <= (others => '0');
            signExtNumber(INPUT_WIDTH - 1 downto 0) <= number;
        end if;
end process;
end architecture;
