library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bin2Char_tb is
end bin2Char_tb;

architecture behavioral of bin2Char_tb is

    signal bin : std_logic_vector(3 downto 0);
    signal bitmask, bitmask_ref : std_logic_vector(6 downto 0);
    constant NUM_TESTCASES : integer := 16;

begin

    BIN_2_CHAR_INST: entity work.bin2Char(behavioral)
    port map(bin => bin, bitmask => bitmask);

    process
        variable numErrors : integer := 0;
        variable display: string(1 to 40) := (8 => lf, 16 => lf, 24 => lf, 32 => lf, 40 => lf, others => ' ');

        variable Bx : std_logic_vector(3 downto 0);
    begin

        for i in 0 to NUM_TESTCASES - 1 loop

            bin <= std_logic_vector(to_unsigned(i, 4));

            Bx := std_logic_vector(to_unsigned(i, 4));
            bitmask_ref(6) <= (Bx(3) or Bx(2) or Bx(1)) and (Bx(3) or (not Bx(2)) or (not Bx(1)) or (not Bx(0))) and ((not Bx(3)) or (not Bx(2)) or Bx(1) or Bx(0));
            bitmask_ref(5) <= (Bx(3) or Bx(2) or (not Bx(0))) and (Bx(3) or Bx(2) or (not Bx(1))) and (Bx(3) or (not Bx(1)) or (not Bx(0))) and ((not Bx(3)) or (not Bx(2)) or Bx(1) or (not Bx(0)));
            bitmask_ref(4) <= (Bx(3) or (not Bx(0))) and (Bx(2) or Bx(1) or (not Bx(0))) and (Bx(3) or (not Bx(2)) or Bx(1));
            bitmask_ref(3) <= (Bx(3) or Bx(2) or Bx(1) or (not Bx(0))) and (Bx(3) or (not Bx(2)) or Bx(1) or Bx(0)) and ((not Bx(2)) or (not Bx(1)) or (not Bx(0))) and ((not Bx(3)) or Bx(2) or (not Bx(1)) or Bx(0));
            bitmask_ref(2) <= (Bx(3) or Bx(2) or (not Bx(1)) or Bx(0)) and ((not Bx(3)) or (not Bx(2)) or Bx(0)) and ((not Bx(3)) or (not Bx(2)) or (not Bx(1)));
            bitmask_ref(1) <= (Bx(3) or (not Bx(2)) or Bx(1) or (not Bx(0))) and ((not Bx(2)) or (not Bx(1)) or Bx(0)) and ((not Bx(3)) or (not Bx(1)) or (not Bx(0))) and ((not Bx(3)) or (not Bx(2)) or Bx(0));
            bitmask_ref(0) <= (Bx(3) or Bx(2) or Bx(1) or (not Bx(0))) and (Bx(3) or (not Bx(2)) or Bx(1) or Bx(0)) and ((not Bx(3)) or Bx(2) or (not Bx(1)) or (not Bx(0))) and ((not Bx(3)) or (not Bx(2)) or Bx(1) or (not Bx(0)));

            wait for 5 ns;

            if bitmask(0) = '1' then display(02) := '='; else display(02) := ' '; end if;
            if bitmask(1) = '1' then display(11) := '|'; else display(11) := ' '; end if;
            if bitmask(2) = '1' then display(27) := '|'; else display(27) := ' '; end if;
            if bitmask(3) = '1' then display(34) := '='; else display(34) := ' '; end if;
            if bitmask(4) = '1' then display(25) := '|'; else display(25) := ' '; end if;
            if bitmask(5) = '1' then display(09) := '|'; else display(09) := ' '; end if;
            if bitmask(6) = '1' then display(18) := '='; else display(18) := ' '; end if;

            if bitmask_ref(0) = '1' then display(06) := '='; else display(06) := ' '; end if;
            if bitmask_ref(1) = '1' then display(15) := '|'; else display(15) := ' '; end if;
            if bitmask_ref(2) = '1' then display(31) := '|'; else display(31) := ' '; end if;
            if bitmask_ref(3) = '1' then display(38) := '='; else display(38) := ' '; end if;
            if bitmask_ref(4) = '1' then display(29) := '|'; else display(29) := ' '; end if;
            if bitmask_ref(5) = '1' then display(13) := '|'; else display(13) := ' '; end if;
            if bitmask_ref(6) = '1' then display(22) := '='; else display(22) := ' '; end if;


            if bitmask /= bitmask_ref then
                report "falsche Bitmaske bei bin2Char = """ &
                    integer'image(to_integer(unsigned'("" & bin(3)))) &
                    integer'image(to_integer(unsigned'("" & bin(2)))) &
                    integer'image(to_integer(unsigned'("" & bin(1)))) &
                    integer'image(to_integer(unsigned'("" & bin(0)))) &
                """: """ &
                    integer'image(to_integer(unsigned'("" & bitmask(6)))) &
                    integer'image(to_integer(unsigned'("" & bitmask(5)))) &
                    integer'image(to_integer(unsigned'("" & bitmask(4)))) &
                    integer'image(to_integer(unsigned'("" & bitmask(3)))) &
                    integer'image(to_integer(unsigned'("" & bitmask(2)))) &
                    integer'image(to_integer(unsigned'("" & bitmask(1)))) &
                    integer'image(to_integer(unsigned'("" & bitmask(0)))) &
                """ (erwartet: """ &
                    integer'image(to_integer(unsigned'("" & bitmask_ref(6)))) &
                    integer'image(to_integer(unsigned'("" & bitmask_ref(5)))) &
                    integer'image(to_integer(unsigned'("" & bitmask_ref(4)))) &
                    integer'image(to_integer(unsigned'("" & bitmask_ref(3)))) &
                    integer'image(to_integer(unsigned'("" & bitmask_ref(2)))) &
                    integer'image(to_integer(unsigned'("" & bitmask_ref(1)))) &
                    integer'image(to_integer(unsigned'("" & bitmask_ref(0)))) &
                """)" & lf & display severity error;
                numErrors := numErrors + 1;
            else
                --report "korrekte bitmaske! erhalten:" & lf & display & "erwartet";
            end if;

            wait for 5 ns;

        end loop;

        if numErrors = 0 then
            report "Der bin2Char-Konverter funktioniert einwandfrei! (bin2Char: 3/3 Punkte)" severity note;
            report "CI: All good." severity note;
        else
            report integer'image(numErrors) & " von " & integer'image(NUM_TESTCASES) & " Tests fehlerhaft" severity note;
            if numErrors <= 2  then
                report "Der bin2Char-Konverter funktioniert nicht einwandfrei! (bin2Char: 2/3 Punkte)" severity failure;
            elsif numErrors >= NUM_TESTCASES - 1 then
                report "Der bin2Char-Konverter funktioniert nicht einwandfrei! (bin2Char: 0/3 Punkte)" severity failure;
            else
                report "Der bin2Char-Konverter funktioniert nicht einwandfrei! (bin2Char: 1/3 Punkte)" severity failure;
            end if;
        end if;

        wait;

    end process;

end behavioral;
