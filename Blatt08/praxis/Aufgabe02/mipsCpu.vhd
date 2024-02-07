library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.proc_config.all;
entity mipsCpu is
	generic
    	(
        PROG_FILE_NAME : string;
		DATA_FILE_NAME : string
	);
	port
    	(
        clk : in std_logic;
		rst : in std_logic;
		 
		-- instruction insertion ports
		testMode_debug : in std_logic;
		testInstruction_debug : in std_logic_vector(31 downto 0);
		 
		-- ram access ports
		ramInsertMode_debug : in std_logic;
		ramWriteEn_debug : in std_logic;
		ramWriteAddr_debug : in std_logic_vector(LOG2_NUM_RAM_ELEMENTS - 1 downto 0);	
		ramWriteData_debug : in std_logic_vector(RAM_ELEMENT_WIDTH - 1 downto 0);
		ramElements_debug : out ram_elements_type;
		 
		-- register file access port
		registers_debug : out reg_vector_type;
		 
		-- intermediate result ports
		pc_next_debug : out std_logic_vector(PC_WIDTH - 1 downto 0);
		pc7SegDigits_debug : out pc_7seg_digits_type
	);
end mipsCpu;

architecture structural of mipsCpu is
    signal read_data_rom : std_logic_vector(PC_WIDTH-1 downto 0) := (others => '0');
    signal pc_freeze: std_logic_vector(PC_WIDTH-1 downto 0) := (others => '0');
    signal pc_instr : std_logic_vector(PC_WIDTH-1 downto 0) := (others => '0');
    signal readData_ram : std_logic_vector(RAM_ELEMENT_WIDTH-1 downto 0); 
    signal ramAddr : std_logic_vector(LOG2_NUM_RAM_ELEMENTS-1 downto 0);
    signal writeData : std_logic_vector(RAM_ELEMENT_WIDTH-1 downto 0);
    signal shifted_number : std_logic_vector(PC_WIDTH-1 downto 0);
    signal adress_reg: std_logic_vector(LOG2_NUM_REGS-1 downto 0);
    signal adress_data : std_logic_vector(REG_WIDTH-1 downto 0);
    signal instruction : std_logic_vector(PC_WIDTH-1 downto 0);
	signal readData1 : std_logic_vector(REG_WIDTH-1 downto 0);
    signal readData2 : std_logic_vector(REG_WIDTH-1 downto 0);
    signal alu_Result : std_logic_vector(ALU_WIDTH-1 downto 0);
	signal pc_next : std_logic_vector(PC_WIDTH-1 downto 0);
    signal Alu_2 : std_logic_vector(ALU_WIDTH-1 downto 0);
	signal signExtNumber : signed(PC_WIDTH-1 downto 0);
    signal operation : std_logic_vector(3 downto 0);
    signal aluOp : std_logic_vector(1 downto 0);
    signal reg_vect : reg_vector_type;
    signal regWrite : std_logic;
    signal memtoReg : std_logic;
	signal memWrite : std_logic;
    signal overflow: std_logic;
    signal memRead : std_logic;
	signal regDst : std_logic; 
	signal branch : std_logic;
    signal aluSrc : std_logic;
	signal writeEn: std_logic;
    signal invclk: std_logic;
    signal zero: std_logic;
begin
    process(clk) begin
        invclk <= not clk;
    end process;
    -- Instruction Memory
	INSTR_ROM: entity work.flashROM(behavioral) 
	generic map(
    NUM_ELEMENTS => NUM_ROM_ELEMENTS,
	LOG2_NUM_ELEMENTS => LOG2_NUM_ROM_ELEMENTS,
	ELEMENT_WIDTH => PC_WIDTH,
	INIT_FILE_NAME => PROG_FILE_NAME)
	port map(
    address => pc_instr(11 downto 2),
    readData => read_data_rom
	);
    -- Data Memory
	DATA_RAM: entity work.flashRAM(behavioral)
	generic map(
    NUM_ELEMENTS => NUM_RAM_ELEMENTS,
	LOG2_NUM_ELEMENTS => LOG2_NUM_RAM_ELEMENTS,
	ELEMENT_WIDTH => RAM_ELEMENT_WIDTH,
	INIT_FILE_NAME => DATA_FILE_NAME)
	port map(
    clk => invclk,
 	address => ramAddr,	
 	writeEn => writeEn,
 	writeData => writeData,
 	readEn => memRead,
 	readData => readData_ram,
 	ramElements_debug => ramElements_debug
	);
	instruction	<=	testInstruction_debug when testMode_debug = '1' else read_data_rom; --für die im Test Modus ausgeführten Instruktionen
	MIPS_CTRL: entity work.mipsCtrl
	port map(	
    op => instruction(31 downto 26),
	regDst => regDst,
	branch => branch,
	memRead => memRead,
	memToReg => memtoReg,
	aluOp => aluOp,
	memWrite => memWrite,
	aluSrc => aluSrc,
	regWrite => regWrite
	);
	adress_reg 	<= 	instruction(20 downto 16) when regDst = '0' else instruction(15 downto 11) when regDst= '1';
	adress_data <= 	alu_Result when memtoReg = '0' else readData_ram ;
	MIPS_ALU: entity work.mipsAlu(behavioral)
	generic map
	(WIDTH => ALU_WIDTH)
	port map(	
    ctrl => operation,
	a => readData1,
	b => Alu_2,
	result => alu_Result,
	overflow => overflow,
	zero => zero
	);	
	SIGN_EXTEND: entity work.signExtend(behavioral)
	generic map (
    INPUT_WIDTH => 16,
	OUTPUT_WIDTH => 32
	)
	port map(	
    number => signed(instruction(15 downto 0)),							
	signExtNumber => signExtNumber
	);
	LEFTSHIFT: entity work.leftShifter(behavioral)
	generic map(	
    WIDTH => 32,
	SHIFT_AMOUNT => 2
	)
	port map(	
    number => std_logic_vector(signExtNumber), 
	shiftedNumber => shifted_number
	);
    ALU_CTRL: entity work.aluCtrl(behavioral)
	port map(
    aluOp => aluOp,
	f => instruction(5 downto 0),
	operation => operation
	);
	Alu_2 <= readData2 when aluSrc = '0' else std_logic_vector(signExtNumber);
    REG_FILE: entity work.regFile
	generic map (	
    NUM_REGS => NUM_REGS,
	LOG2_NUM_REGS => LOG2_NUM_REGS,
	REG_WIDTH => REG_WIDTH
	)
	port map(	
    clk => clk,
	rst => rst,
	readAddr1 => instruction(25 downto 21),
    readAddr2 => instruction(20 downto 16),
	readData1 => readData1,
	readData2 => readData2,
	writeEn => regWrite,
	writeAddr => adress_reg,
	writeData => adress_data,
	reg_vect_debug => reg_vect
	);
	writeData <= ramWriteData_debug when ramInsertMode_debug = '1' else readData2;
    writeEn <= memWrite when ramInsertMode_debug = '0' else ramWriteEn_debug;
    ramAddr <= alu_Result(LOG2_NUM_RAM_ELEMENTS+1 downto 2) when ramInsertMode_debug = '0' else ramWriteAddr_debug;
    registers_debug <= reg_vect;
    
    pc_next <= std_logic_vector(unsigned(pc_instr) + unsigned(shifted_number) + 4) 
    when (branch = '1' and zero = '1') else std_logic_vector(signed(pc_instr) + 4); --sprung wenn zero und branch = 1, sonst nächste Instruktion (+4)
    pc_next_debug <= pc_next; --nächsten Befehl laden
	process(clk)
	variable buffer1 : integer := 0;
	begin
		if (clk = '1' and testMode_debug = '0') then
			pc_instr <= pc_freeze when rst = '1' or buffer1 = 0 else pc_next; 
			if (buffer1 = 0) then
				buffer1 := 1;
			end if;
		end if;
	end process;
--7Segment Anzeige steuern
       bin2char1: entity work.bin2Char
	    port map(
		bin => pc_instr(3 downto 0),
		bitmask => pc7SegDigits_debug(0)
	    );
	    bin2char2: entity work.bin2Char
	    port map(
		bin => pc_instr(7 downto 4),
		bitmask => pc7SegDigits_debug(1)
	    );
	    bin2char3: entity work.bin2Char
	    port map(
		bin => pc_instr(11 downto 8),
		bitmask => pc7SegDigits_debug(2)
	    );
	    bin2char4: entity work.bin2Char
	    port map(
		bin => pc_instr(15 downto 12),
		bitmask => pc7SegDigits_debug(3)
	);

end architecture;
