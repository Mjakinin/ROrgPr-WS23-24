library ieee;
use ieee.std_logic_1164.all;

entity and2 is
    port (a : in std_logic ;
    b : in std_logic ;
    y : out std_logic );
    end and2 ;
architecture behavioral of and2 is
    begin
    y <= a and b;
    end behavioral ;

