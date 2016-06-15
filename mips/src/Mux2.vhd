library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Mux2 is
	generic (width: integer);
	port(
	selector : in std_logic;
	in0, in1 : in std_logic_vector(width-1 downto 0);
	output   : out STD_LOGIC_VECTOR(width-1 downto 0)
	) ;											 
end;											 

architecture behave of Mux2 is
begin
	output <= in0 when selector = '0' else in1;
end;

