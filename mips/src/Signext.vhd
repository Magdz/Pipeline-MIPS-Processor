library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Signext is
	port(
	a: in STD_LOGIC_VECTOR (15 downto 0);
	output: out STD_LOGIC_VECTOR(31 downto 0)
	);
end;										  

architecture behave of Signext is
begin
	output <= X"0000" & a when a(15) = '0' else X"FFFF" & a;
end;