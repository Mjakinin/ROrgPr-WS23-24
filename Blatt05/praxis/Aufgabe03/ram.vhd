
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.proc_config.ram_elements_type;

entity ram is
    generic(
        NUM_ELEMENTS      : integer;
        LOG2_NUM_ELEMENTS : integer;
        ELEMENT_WIDTH     : integer);
    port(
        clk               : in  std_logic;
        address           : in  std_logic_vector( LOG2_NUM_ELEMENTS - 1 downto 0 );
        writeEn           : in  std_logic;
        writeData         : in  std_logic_vector( ELEMENT_WIDTH - 1 downto 0 );
        readEn            : in  std_logic;
        readData          : out std_logic_vector( ELEMENT_WIDTH - 1 downto 0 );
        ramElements_debug : out ram_elements_type);
end ram;

architecture behavioral of ram is

    -- Signal, das alle Elemente des RAMs enthält
    signal ramElements : ram_elements_type := (others => (others => '0'));
  --  signal readValue   : std_logic_vector(ELEMENT_WIDTH - 1 downto 0):= (others => '0');

begin

    process (clk)
    begin
        if rising_edge(clk) then
            -- Schreibvorgang
            if writeEn = '1' then
                ramElements(to_integer(unsigned(address))) <= writeData;
            end if;

            -- Lesen erfolgt erst nach ausreichender Zeit für das Schreiben
            if readEn = '1' then
                -- Verschiebung des Lesevorgangs
                readData <= ramElements(to_integer(unsigned(address)));
            end if;
            if readEn='1' and writeEn = '1' then
                readData <= writeData;
            end if;
        end if;
    end process;

    -- RAM-Inhalt über den Debug-Port nach außen führen
    ramElements_debug <= ramElements;
    -- Wert für das Lesen zur Verfügung stellen
   -- readData <= readValue;

end architecture;