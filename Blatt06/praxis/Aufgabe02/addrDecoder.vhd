library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity addrDecoder is
    generic (
        ADDR_WIDTH      : integer;
        POW2_ADDR_WIDTH : integer
    );
    port (
        address : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
        bitmask : out std_logic_vector(POW2_ADDR_WIDTH - 1 downto 0)
    );
end addrDecoder;

architecture behavioral of addrDecoder is
begin
    process(address)
    variable m : integer;
    begin
        -- Setze m auf den Wert des m-ten Bits der Binärdarstellung von address
        m := to_integer(unsigned(address));
        
        -- Bitmask initialisieren
        bitmask <= (others => '0');
        
        -- Setze das m-te Bit des Ausgangssignals 'bitmask'
        if m < POW2_ADDR_WIDTH then
            bitmask(m) <= '1';
        end if;
    end process;
end behavioral;
