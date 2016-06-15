library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Mux4 is
	generic(width: integer);
	port(				  
	
	selector: in STD_LOGIC_VECTOR (1 downto 0);
	in0, in1, in2, in3: in STD_LOGIC_VECTOR (width-1 downto 0);
	output: out STD_LOGIC_VECTOR (width-1 downto 0)
	);
end	;  

architecture behave of MUX4 is
begin
	output <= in0 when selector =  "00";
	output <= in1 when selector =  "01";
	output <= in2 when selector =  "10";
	output <= in3 when selector =  "11";
end	;
