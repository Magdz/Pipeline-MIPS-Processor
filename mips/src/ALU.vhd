library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity ALU is	 
		
		
Port(
A: in STD_LOGIC_VECTOR(31 downto 0);	--input A	  
B: in STD_LOGIC_VECTOR(31 downto 0);  	--input B
C: in STD_LOGIC_VECTOR(2 downto 0);	 --control 
Z: out STD_LOGIC :='0';			  --zero
AluOut: out STD_LOGIC_VECTOR (31 downto 0));
end ALU;

architecture Behavioral of ALU is					
signal Result : STD_LOGIC_VECTOR(31 downto 0);	
		
begin	
	
	Result <= A and B when C = "000" else
	A or B when C	 = "001" else 
	A and not(B)  when  C = "100" else 
	A or not(B)  when  C = "101" else 
	A+B when C = "010" else
	A-B when C = "110" else	  
	CONV_STD_LOGIC_VECTOR(1, 32) when A < B and C = "111" else
	CONV_STD_LOGIC_VECTOR(0, 32) when A >= B and C = "111" ;

	
Z <= '1' when  Result = 0 else '0' ;	 
			 
AluOut<=Result;
						
end Behavioral;


