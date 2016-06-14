library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity aludec is
	port(
	funct: in std_logic_vector(5 downto 0);
	ALUOp: in std_logic_vector(1 downto 0);
	ALUControl: out std_logic_vector(2 downto 0)
	);
	
end aludec;									   

architecture behave of aludec is
begin
process(ALUOp, funct)
begin
case(ALUOp)	is
	when "00" =>
	ALUControl <= "010"; --Add (lw/lb/addi)
	when "01" =>
	ALUControl <= "110"; --Subtract (beq)
	when others =>
	case(funct)is
		when "100000" => 
		ALUControl <= "010";  --Add
		when "100010" =>	 
		ALUControl <= "110";  --Subtract
		when "100100" =>
		ALUControl <= "000";  --AND
		when "100101" =>
		ALUControl <= "001";  --OR
		when "101010" =>
		ALUControl <= "111";  --SLT	   
		when others =>
		ALUControl <= "---";  --undefined Function
	end Case;					  
end Case;
end process;
end;
