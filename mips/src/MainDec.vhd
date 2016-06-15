library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MainDec is

	port(	   
	--Input
	op: in std_logic_vector (5 downto 0);	
	
	--Output
	RegWrite, MemToReg, MemWrite, ALUSrc, RegDst, Branch: out std_logic;
	ALUOp: out std_logic_vector (1 downto 0)
	);
end;

--Main decoder architecture 
architecture behave of MainDec is

--Intermediate signal
signal controls: std_logic_vector(8 downto 0);

--Driver
begin
	process(op) begin
		case op is
		when "000000" => controls <= "110000010"; -- R-type instructions
		when "100011" => controls <= "101001000"; -- LW
		when "101011" => controls <= "001010000"; -- SW
		when "000100" => controls <= "000100001"; -- BEQ
		when "001000" => controls <= "101000000"; -- ADDI
		when "000010" => controls <= "000000100"; -- J		
		when others   => controls <= "---------"; -- Illlegal op
		end case;
	end process;

	--Set control signals	 
	regwrite <= controls(8);											
	regdst <= controls(7);
	alusrc <= controls(6);
	branch <= controls(5);
	memwrite <= controls(4);
	memtoreg <= controls(3);
	--jump <= controls(2);
	aluop <= controls(1 downto 0);
end;
