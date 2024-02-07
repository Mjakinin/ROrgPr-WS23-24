library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult32x32 is
    port (
        a : in std_logic_vector(31 downto 0);
        b : in std_logic_vector(31 downto 0);
        y : out std_logic_vector(63 downto 0)
    );
end mult32x32;

architecture structural of mult32x32 is
    signal a_upper, a_lower, b_upper, b_lower : std_logic_vector(15 downto 0);
    
    signal a_upper_extended25 : signed(24 downto 0);
    signal b_upper_extended25 : signed(24 downto 0);
    signal b_upper_extended18 : unsigned(17 downto 0);
    signal a_lower_extented25 : signed(24 downto 0);
    signal b_lower_extented18 : unsigned(17 downto 0);
    signal a_lower_extented18 : unsigned(17 downto 0);
    
    signal mult1_result, mult2_result, mult3_result, mult4_result : signed(42 downto 0); 
    
    signal concat1 : std_logic_vector(63 downto 0);
    signal addition1 : signed(32 downto 0);
    signal addition_result : std_logic_vector(63 downto 0);
    signal addition_result2 : signed(63 downto 0);

    component mult25x18 is
        port (
            a : in signed(24 downto 0);
            b : in signed(17 downto 0);
            y : out signed(42 downto 0)
        );
    end component;

begin
    -- Aufteilung von a und b in obere und untere Hälften
    a_upper <= a(31 downto 16);
    a_lower <= a(15 downto 0);
    b_upper <= b(31 downto 16);
    b_lower <= b(15 downto 0);

    -- Direkte Zuweisungen
    a_upper_extended25(24 downto 16) <= (others => a_upper(15));
    a_upper_extended25(15 downto 0) <= signed(a_upper(15 downto 0));
    b_upper_extended25(24 downto 16) <= (others => b_upper(15));
    b_upper_extended25(15 downto 0) <= signed(b_upper(15 downto 0));
    b_upper_extended18(17 downto 16) <= (others => b_upper(15));
    b_upper_extended18(15 downto 0) <= unsigned(b_upper(15 downto 0));
    
    a_lower_extented25(24 downto 16) <= (others => '0');
    a_lower_extented25(15 downto 0) <= signed(a_lower(15 downto 0));
    a_lower_extented18(17 downto 16) <= (others => '0');
    a_lower_extented18(15 downto 0) <= unsigned(a_lower(15 downto 0));
    b_lower_extented18(17 downto 16) <= (others => '0');
    b_lower_extented18(15 downto 0) <= unsigned(b_lower(15 downto 0));

    mult1_inst : mult25x18
        port map (
            a => a_upper_extended25,
            b => signed(b_upper_extended18),
            y => mult1_result
        );

    mult2_inst : mult25x18
        port map (
            a => a_lower_extented25,
            b => signed(b_lower_extented18),
            y => mult2_result
        );

    mult3_inst : mult25x18
        port map (
            a => a_upper_extended25,
            b => signed(b_lower_extented18),
            y => mult3_result
        );

    mult4_inst : mult25x18
        port map (
            a => b_upper_extended25,
            b => signed(a_lower_extented18),
            y => mult4_result
        );

    concat1(31 downto 0) <= std_logic_vector(mult2_result(31 downto 0));
    concat1(63 downto 32) <= std_logic_vector(mult1_result(31 downto 0));

    addition1 <= (mult3_result(32 downto 0)) + (mult4_result(32 downto 0));

    process(addition1)
    begin
        if addition1(32) = '1' then
            addition_result(63 downto 48) <= (others => '1');
        else
            addition_result(63 downto 48) <= (others => '0');
        end if;

        addition_result(47 downto 16) <= std_logic_vector(addition1(31 downto 0));
        addition_result(15 downto 0) <= (others => '0');

    end process;
    
    addition_result2 <= signed(concat1) + signed(addition_result);

    y <= std_logic_vector(addition_result2);

end architecture;

