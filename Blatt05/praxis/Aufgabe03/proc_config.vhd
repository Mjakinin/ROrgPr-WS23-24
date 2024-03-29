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
	--subtype ram_elements_type is ROrgPrSimLib.proc_config.ram_elements_type;

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
	constant LOG2_NUM_ROM_ELEMENTS : integer := 10;
	type pc_7seg_digits_type is array (0 to 3) of std_logic_vector(6 downto 0);
	
	-- processor clock frequency
	constant CLK_PERIOD : time := 10 ns;

end proc_config;

package body proc_config is

end proc_config;
