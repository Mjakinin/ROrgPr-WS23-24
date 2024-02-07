library ieee;
use ieee.std_logic_1164.all;

library ROrgPrSimLib;
use ROrgPrSimLib.all;

use work.all;

entity neq4 is
	port(a : in std_logic_vector(3 downto 0);
		 b : in std_logic_vector(3 downto 0);
		 y : out std_logic);
end neq4;

architecture logic of neq4 is
	begin	
		process(a,b) begin
		if a(3 downto 0)= b(3 downto 0) then
			y <= '0';
			else 
			y<= '1';
		end if;
		end process;
		
	end logic;
	
	architecture netlist of neq4 is
	begin
		y <= '0' when a = b else '1';
	
	end netlist;
	