library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.proc_config.all;

entity regFile is
    generic(NUM_REGS : integer;
            LOG2_NUM_REGS : integer;
            REG_WIDTH : integer);
    port(clk : in std_logic;
         rst : in std_logic;
         readAddr1 : in std_logic_vector(LOG2_NUM_REGS - 1 downto 0);
         readData1 : out std_logic_vector(REG_WIDTH - 1 downto 0);
         readAddr2 : in std_logic_vector(LOG2_NUM_REGS - 1 downto 0);
         readData2 : out std_logic_vector(REG_WIDTH - 1 downto 0);
         writeEn   : in std_logic;
         writeAddr : in std_logic_vector(LOG2_NUM_REGS - 1 downto 0);
         writeData : in std_logic_vector(REG_WIDTH - 1 downto 0);
         reg_vect_debug : out reg_vector_type);
end regFile;

architecture structural of regFile is
   -- Array, das alle Einzelregister enthält
signal reg_vect : reg_vector_type;

-- Adressdekoder
signal writeAddrMask : std_logic_vector(NUM_REGS - 1 downto 0);

begin
--intantiierung des dekoders
addr_dec_inst : entity work.addrDecoder
        generic map(
            ADDR_WIDTH      => LOG2_NUM_REGS,
            POW2_ADDR_WIDTH => NUM_REGS
        )
        port map(
            address => writeAddr,  -- Index anpassen
            bitmask => writeAddrMask
        );

RegFile:for i in 1 to NUM_REGS - 1 generate
--instantierung der n-1 register mit schreibvorgang (ohne zero Register)
reg_inst : entity work.reg
    generic map(
            WIDTH => REG_WIDTH
        )
        port map(
            clk => clk,
            rst => rst,
            en  => writeAddrMask(i) and writeEn,
            D   => writeData,
            Q   => reg_vect(i)
        );
end generate;
reg_vect(0) <= (others => '0'); -- zero register (immer 0!)
readData1 <= reg_vect(to_integer(unsigned(readAddr1))); --erster Leseport
readData2 <= reg_vect(to_integer(unsigned(readAddr2))); --zweiter Leseport

--debug port für die Testbench
reg_vect_debug <= reg_vect; 
end architecture structural;


