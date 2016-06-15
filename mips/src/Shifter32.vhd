library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity Shifter32 is	 
	
Port(
inp: in STD_LOGIC_VECTOR(31 downto 0);
outp: out STD_LOGIC_VECTOR (31 downto 0)

);
end Shifter32;

architecture Behavioral of Shifter32 is

begin
outp <= inp(29 downto 0) & "00";

end Behavioral;
