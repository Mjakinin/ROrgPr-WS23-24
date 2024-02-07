library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.proc_config.all;
use work.flashRAM;

entity mipsCpu_mc is
    generic(INIT_FILE_NAME : string);
    port(clk : in std_logic;
         rst : in std_logic;

         -- debug ports
         ramElements_debug   : out ram_elements_type;
         registers_debug     : out reg_vector_type;
         pc7SegDigits_debug  : out pc_7seg_digits_type;
         mipsCtrlState_debug : out mips_ctrl_state_type
         );
end mipsCpu_mc;

architecture structural of mipsCpu_mc is
begin

    -- Beschreibung der Multicycle-MIPS-CPU hier ergänzen

    -- Daten und Instruktionsspeicher
    INSTR_AND_DATA_RAM: entity work.flashRAM(behavioral)
        generic map(NUM_ELEMENTS => ,
                    LOG2_NUM_ELEMENTS => ,
                    ELEMENT_WIDTH => ,
                    INIT_FILE_NAME => INIT_FILE_NAME)
        port map(clk => ,
                 address => ,
                 readEn => ,
                 readData => ,
                 writeEn => ,
                 writeData => ,
                 ramElements_debug => ramElements_debug);

end architecture;
