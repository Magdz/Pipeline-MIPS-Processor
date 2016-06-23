						   library IEEE;
use IEEE.STD_LOGIC_1164.ALL;		 



entity Shifter25 is	 
	Port(
	inp: in STD_LOGIC_VECTOR(31 downto 0);
	PCPlus4D: in STD_LOGIC_VECTOR (31 downto 0);
	outp: out STD_LOGIC_VECTOR (31 downto 0)
	);
end Shifter25;

architecture Behavioral of Shifter25 is

signal number : std_logic_vector(31 downto 0);

begin 										  
	outp <=  PCPlus4D(31 downto 28) & inp(25 downto 0) & "00" ;
end Behavioral;