library ieee;
use ieee.std_logic_1164.all;

entity xnor2 is
    port (a : in std_logic ;
    b : in std_logic ;
    y : out std_logic );
    end xnor2 ;
architecture behavioral of xnor2 is
    begin
    y <= a xnor b;
    end behavioral ;

