library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library ROrgPrSimLib;

package proc_config is

    -- RAM configuration and data types
    constant NUM_RAM_ELEMENTS : integer := 1024;
    constant LOG2_NUM_RAM_ELEMENTS : integer := 10;
    constant RAM_ELEMENT_WIDTH : integer := 32;
    -- Uncomment the next line and comment out the one after it, if the ROrgPrSimLib is not working on your system (e.g. macOS).
    type ram_elements_type is array (0 to NUM_RAM_ELEMENTS - 1) of std_logic_vector(RAM_ELEMENT_WIDTH - 1 downto 0);
   -- subtype ram_elements_type is ROrgPrSimLib.proc_config.ram_elements_type;

    -- Register File configuration and data types
    constant NUM_REGS : integer := 32;
    constant LOG2_NUM_REGS : integer := 5;
    constant REG_WIDTH : integer := 32;
    -- Uncomment the next line and comment out the one after it, if the ROrgPrSimLib is not working on your system (e.g. macOS).
    type reg_vector_type is array (NUM_REGS - 1 downto 0) of std_logic_vector(REG_WIDTH - 1 downto 0);
    --subtype reg_vector_type is ROrgPrSimLib.proc_config.reg_vector_type;

    -- ALU configuration
    constant ALU_WIDTH : integer := 32;

    -- PC
    constant PC_WIDTH : integer := 32;
    constant NUM_ROM_ELEMENTS : integer := 1024;
    type pc_7seg_digits_type is array (0 to 3) of std_logic_vector(6 downto 0);

    -- processor clock frequency
    constant CLK_PERIOD : time := 10 ns;

    -- MIPS control state machine
    -- We get the original type from ROrgPrSimLib (that's why the alias), but here is the
    -- type definition you could also find there:
    --
    -- Uncomment it and comment out the alias if you work without the ROrgPrSimLib.
    --
    type mips_ctrl_state_type is (INSTR_FETCH, INSTR_DECODE, BRANCH_COMPL, JUMP_COMPL, EXECUTION, RTYPE_COMPL, MEM_ADDR_CALC, MEM_WRITE,  MEM_READ, MEM_READ_COMPL,JAL_ADD,LR_WRITE, JR_COMPL, LUI_COMPL,ADDI_CALC, ITYPE_COMPL);
    --alias mips_ctrl_state_type is ROrgPrSimLib.proc_config.mips_ctrl_state_type;

    function toInt (state : mips_ctrl_state_type) return integer;
    function toString (state : mips_ctrl_state_type) return string;

end proc_config;

package body proc_config is

    function toInt (state : mips_ctrl_state_type) return integer is
    begin
        case state is
            when INSTR_FETCH => return 0;
            when INSTR_DECODE => return 1;
            when BRANCH_COMPL => return 2;
            when JUMP_COMPL => return 3;
            when EXECUTION => return 4;
            when RTYPE_COMPL => return 5;
            when MEM_ADDR_CALC => return 6;
            when MEM_WRITE => return 7;
            when MEM_READ => return 8;
            when MEM_READ_COMPL => return 9;
            when JAL_ADD => return 10;
            when LR_WRITE => return 11;
            when JR_COMPL => return 12;
            when LUI_COMPL => return 13;
            when ADDI_CALC => return 14;
            when ITYPE_COMPL => return 15;
        end case;
    end function;

    function toString (state : mips_ctrl_state_type) return string is
    begin
        case state is
            when INSTR_FETCH => return "INSTR_FETCH";
            when INSTR_DECODE => return "INSTR_DECODE";
            when BRANCH_COMPL => return "BRANCH_COMPL";
            when JUMP_COMPL => return "JUMP_COMPL";
            when EXECUTION => return "EXECUTION";
            when RTYPE_COMPL => return "RTYPE_COMPL";
            when MEM_ADDR_CALC => return "MEM_ADDR_CALC";
            when MEM_WRITE => return "MEM_WRITE";
            when MEM_READ => return "MEM_READ";
            when MEM_READ_COMPL => return "MEM_READ_COMPL";
            when JAL_ADD => return "JAL_ADD";
            when LR_WRITE => return "LR_WRITE";
            when JR_COMPL => return "JR_COMPL";
            when LUI_COMPL => return "LUI_COMPL";
            when ADDI_CALC => return "ADDI_CALC";
            when ITYPE_COMPL => return "ITYPE_COMPL";
        end case;
    end function;

end proc_config;
