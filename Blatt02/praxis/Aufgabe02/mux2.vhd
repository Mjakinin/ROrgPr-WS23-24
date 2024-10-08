library ieee;
use ieee.std_logic_1164.all;

entity mux2 is
	port(a : in std_logic;
		 b : in std_logic;
         s : in std_logic;
		 y : out std_logic);
end mux2;

architecture behavioral of mux2 is
    begin 
        process(a, b, s) 
        begin
            case s is
                when '0' =>
                    y <= a;
                when '1' =>
                    y <= b;
                when others =>
                    y <= 'X'; -- Falsche Eingabe, setze Ausgabe auf 'X'
            end case;
        end process;
    end behavioral;