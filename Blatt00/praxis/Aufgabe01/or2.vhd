library ieee;
use ieee.std_logic_1164.all;

--      Entity "or2"
--             ┌─────────┐
--     a ──────┤         ├────── y
--             │   or2   │
--     b ──────┤         │
--             └─────────┘

-- Es werden lediglich die Ports (Ein- und Ausgänge) definiert. ("Blackbox")
entity or2 is
    port (
        a : in std_logic;
        b : in std_logic;
        y : out std_logic
    );
end or2;

--      Architecture "or2"
-- Eingangs- und Ausgangsport werden nicht explizit definiert, sondern vom Entity übernommen.
-- Es wird die eigentliche Logik definiert. ("Inhalt der Blackbox")
architecture behavioral of or2 is
begin
    y <= a or b;
end architecture;
