library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

library work;
use work.proc_config.all;

entity addrDecoder_tb is
end addrDecoder_tb;

architecture behavioral of addrDecoder_tb is

    signal address : std_logic_vector(LOG2_NUM_REGS - 1 downto 0) := (others => '0');
    signal bitmask : std_logic_vector(NUM_REGS - 1 downto 0);

begin

    ADDR_DEC: entity work.addrDecoder(behavioral)
    generic map(ADDR_WIDTH => LOG2_NUM_REGS,
                POW2_ADDR_WIDTH => NUM_REGS)
    port map(address => address,
             bitmask => bitmask);

    TESTBENCH: process
        variable points : integer := 2;
        variable numErrors : integer := 0;
        variable l : line;
        variable bitmask_ref : unsigned(NUM_REGS - 1 downto 0) := (others => '0');
    begin

        bitmask_ref(NUM_REGS-1) := '1';
        for i in 0 to NUM_REGS - 1 loop
            address <= std_logic_vector(to_unsigned(i, LOG2_NUM_REGS));
            bitmask_ref := rotate_left(bitmask_ref, 1);
            wait for 5 ns;
            if unsigned(bitmask) /= bitmask_ref then
                if numErrors < 4 then
                    write(l, time'image(now));
                    write(l, string'(": Falsches Ergebnis am Adressdekoder: x"""));
                    hwrite(l, bitmask);
                    write(l, string'(""" (erwartet: x"""));
                    hwrite(l, bitmask_ref);
                    write(l, string'(""")"));
                    writeline(OUTPUT, l);
                elsif numErrors = 4 then
                    write(l, time'image(now));
                    write(l, string'(": Weitere Fehler werden nicht angezeigt ..."));
                    writeline(OUTPUT, l);
                end if;
                numErrors := numErrors + 1;
            end if;
            wait for 5 ns;
        end loop;

        -- evaluation
        if numErrors = 0 then
            report "Der Adressdekoder funktioniert einwandfrei! (addrDecoder: 2/2 Punkte)" severity note;
            report "CI: All good." severity note;
        else
            report "Der Adressdekoder funktioniert nicht einwandfrei! (addrDecoder: 0/2 Punkte)" severity failure;
        end if;

        wait;
    end process;

end behavioral;
