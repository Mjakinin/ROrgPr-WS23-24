library ieee;
use ieee.std_logic_1164.all;

entity alu_1bit is
    port (
        operation : in std_logic_vector(1 downto 0);
        a : in std_logic;
        aInvert : in std_logic;
        b : in std_logic;
        bInvert : in std_logic;
        carryIn : in std_logic;
        less : in std_logic;
        result : out std_logic;
        carryOut : out std_logic;
        set : out std_logic
    );
end alu_1bit;

architecture structural of alu_1bit is
    signal a_temp : std_logic;
    signal b_temp : std_logic;
    signal result_1: std_logic;
begin

    process (a,aInvert) 
    begin
        if aInvert = '0' then
            a_temp <= a;
        else
            a_temp <= (not a);
        end if;
    end process;

    process(b,bInvert)
    begin
        if bInvert = '0' then
            b_temp <= b;
        else
            b_temp <= not b;
        end if;
    end process;

    process (operation,a_temp,b_temp,set,less)
    begin
            if operation = "00" then
                result <= (a_temp and b_temp);
            elsif operation = "01" then
                result <= (a_temp or b_temp);
            elsif operation = "10" then
                result <= set;
            elsif operation = "11" then
                result <= less;
        end if;
    end process;
    bit_adder: entity work.adder_1bit
        port map (
            a    => a_temp,
            b    => b_temp,
            cin  => carryIn,
            sum  => set,
            cout => carryOut
        );
end architecture;