library ieee;
use ieee.std_logic_1164.all;

library work;
use work.proc_config.mips_ctrl_state_type;
use work.mipsISA.all;

entity mipsCtrlFsm is
    port (
        clk : in std_logic;
        rst : in std_logic;
        op : in std_logic_vector(5 downto 0);
        jr : in std_logic;
        regDst : out std_logic_vector(1 downto 0);
        memRead : out std_logic;
        memToReg : out std_logic;
        aluOp : out std_logic_vector(1 downto 0);
        memWrite : out std_logic;
        regWrite : out std_logic;
        aluSrcA : out std_logic;
        aluSrcB : out std_logic_vector(1 downto 0);
        pcSrc : out std_logic_vector(1 downto 0);
        irWrite : out std_logic;
        IorD : out std_logic;
        pcWrite : out std_logic;
        pcWriteCond : out std_logic;
        lui : out std_logic;

        -- debug port
        mipsCtrlState_debug : out mips_ctrl_state_type
    );
end mipsCtrlFsm;

architecture behavioral of mipsCtrlFsm is
    signal state_reg : mips_ctrl_state_type;
begin

    process(clk, rst)
    begin
        if rst = '1' then
            state_reg <= INSTR_FETCH;
        elsif rising_edge(clk) then
            case state_reg is
                when INSTR_FETCH =>
                    state_reg <= INSTR_DECODE;
                when INSTR_DECODE =>
                    if op /= R_FORMAT_OPCODE and
                       op /= JR_FUNCT and
                       op /= ADDI_OPCODE and
                       op /= ADDIU_OPCODE and
                       op /= LW_OPCODE and
                       op /= SW_OPCODE and
                       op /= LUI_OPCODE and
                       op /= BEQ_OPCODE and
                       op /= J_OPCODE and
                       op /= JAL_OPCODE then
                        state_reg <= INSTR_FETCH;
                    elsif op = LW_OPCODE or op = SW_OPCODE then
                        state_reg <= MEM_ADDR_CALC;
                    elsif op = ADDI_OPCODE or op = ADDIU_OPCODE then
                        state_reg <= ADDI_CALC;
                    elsif op = R_FORMAT_OPCODE then
                        state_reg <= EXECUTION;
                    elsif op = JAL_OPCODE then
                        state_reg <= JAL_ADD;
                    elsif op = J_OPCODE then
                        state_reg <= JUMP_COMPL;
                    elsif op = LUI_OPCODE then
                        state_reg <= LUI_COMPL;
                    elsif op = BEQ_OPCODE then
                        state_reg <= BRANCH_COMPL;
                    else
                        state_reg <= INSTR_DECODE;
                    end if;

                when EXECUTION =>
                    if jr = '1' then
                        state_reg <= JR_COMPL;
                    else
                        state_reg <= RTYPE_COMPL;
                    end if;

                when JR_COMPL =>
                    state_reg <= INSTR_FETCH;

                when RTYPE_COMPL =>
                    state_reg <= INSTR_FETCH;

                when LUI_COMPL =>
                    state_reg <= INSTR_FETCH;

                when BRANCH_COMPL =>
                    state_reg <= INSTR_FETCH;

                when JAL_ADD =>
                    state_reg <= LR_WRITE;

                when LR_WRITE =>
                    state_reg <= JUMP_COMPL;

                when JUMP_COMPL =>
                    state_reg <= INSTR_FETCH;

                when ADDI_CALC =>
                    state_reg <= ITYPE_COMPL;

                when ITYPE_COMPL =>
                    state_reg <= INSTR_FETCH;

                when MEM_ADDR_CALC =>
                    if op = LW_OPCODE then
                        state_reg <= MEM_READ;
                    elsif op = SW_OPCODE then
                        state_reg <= MEM_WRITE;
                    end if;

                when MEM_READ =>
                    state_reg <= MEM_READ_COMPL;

                when MEM_WRITE =>
                    state_reg <= INSTR_FETCH;

                when MEM_READ_COMPL =>
                    state_reg <= INSTR_FETCH;

                when others =>
                    state_reg <= INSTR_FETCH;
            end case;
        end if;
    end process;

    process(state_reg)
    begin
        case state_reg is
            when INSTR_FETCH =>
                -- Logik für Ausgänge zuweisen
                memRead <= '1';
                aluSrcA <= '0';
                IorD <= '0';
                irWrite <= '1';
                aluSrcB <= "01";
                aluOp <= "00";
                pcWrite <= '1';
                pcSrc <= "00";
                lui <= '0';
                regDst <= "00";
                memToReg <= '0';
                memWrite <= '0';
                regWrite <= '0';
                pcWriteCond <= '0';

            when INSTR_DECODE =>
                -- Logik für Ausgänge zuweisen
                memRead <= '0';
                aluSrcA <= '0';
                IorD <= '0';
                irWrite <= '0';
                aluSrcB <= "11";
                aluOp <= "00";
                pcWrite <= '0';
                pcSrc <= "00";
                lui <= '0';
                regDst <= "00";
                memToReg <= '0';
                memWrite <= '0';
                regWrite <= '0';
                pcWriteCond <= '0';

            when EXECUTION =>
                -- Logik für Ausgänge zuweisen
                if jr = '1' then
                    pcWrite <= '0';
                    pcSrc <= "01";
                else
                    regDst <= "00";
                    regWrite <= '0';
                    memToReg <= '0';
                    lui <= '0';
                    aluSrcB <= "00";
                    aluSrcA <= '1';
                    aluOp <="10";
                end if;

            when LUI_COMPL =>
                -- Logik für Ausgänge zuweisen
                regDst <= "00";
                regWrite <= '1';
                memToReg <= '0';
                lui <= '1';
                aluSrcB <="00";

            when BRANCH_COMPL =>
                -- Logik für Ausgänge zuweisen
                aluSrcA <= '1';
                aluSrcB <= "00";
                aluOp <= "01";
                pcWriteCond <= '1';
                pcSrc <= "01";

            when JAL_ADD =>
                -- Logik für Ausgänge zuweisen
                regDst <= "00";
                regWrite <= '0';
                memToReg <= '0';
                lui <= '0';
                aluSrcB <="01";

            when ADDI_CALC =>
                -- Logik für Ausgänge zuweisen
                regDst <= "00";
                regWrite <= '0';
                memToReg <= '0';
                lui <= '0';
                aluSrcA <='1';
                aluSrcB <="10";


            when MEM_ADDR_CALC =>
                -- Logik für Ausgänge zuweisen
                if op = LW_OPCODE then
                    memRead <= '0';
                    IorD <= '0';
                    aluSrcB <= "10" ;
                    aluSrcA <= '1'; 
                elsif op = SW_OPCODE then
                    memWrite <= '0';
                    IorD <= '0';
                    aluSrcB <= "10" ;
                    aluSrcA <= '1'; 
                end if;

            when MEM_READ =>
                -- Logik für Ausgänge zuweisen
                regDst <= "00";
                regWrite <= '0';
                memToReg <= '0';
                memRead <= '1';
                aluSrcB <= "00";
                aluSrcA <='0';
                IorD <='1';

            when ITYPE_COMPL =>
            aluSrcB <= "00";
            regWrite <= '1';
            aluSrcA <='0';

            when JR_COMPL =>
            regDst <= "00";
            pcSrc <="01";
            aluSrcB <="00";
            pcWrite <= '1';
            aluOp <="00";
            aluSrcA <='0';

            when JUMP_COMPL =>
            regDst <="00";
            aluSrcB <= "00";
            pcSrc <= "10";
            pcWrite <='1';
            regWrite <='0';
            
            when RTYPE_COMPL =>
            regDst <="01";
            aluOp <="00";
            regWrite <='1';
            aluSrcA <= '0';

            when LR_WRITE =>
            regDst <="10";
            aluSrcB <="00";
            pcSrc <="00";
            regWrite <= '1';

            when MEM_READ_COMPL =>
            memRead <='0';
            regWrite <= '1';
            IorD <= '0';
            memToReg <= '1';
            aluSrcA <='0';

            when MEM_WRITE =>
            memWrite <= '1';
            aluSrcA <= '0';
            aluSrcB <="00";
            IorD <= '1';

    when others =>

        end case;
    end process;

    mipsCtrlState_debug <= state_reg;

end behavioral;
