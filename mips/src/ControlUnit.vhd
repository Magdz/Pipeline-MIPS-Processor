library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ControlUnit is
	port(	 
	--Input
	op,funct: in std_logic_vector(5 downto 0);	

	--Ouput
	RegWriteD,MemtoRegD,MemWriteD, ALUSrcD,RegDstD,PCSrcD: out std_logic;	 
	ALUControlD: out std_logic_vector(2 downto 0)
	); 
end;						   

architecture struct of ControlUnit is
component ALUDec is
port(	
	--Input
	funct: in std_logic_vector(5 downto 0);
	ALUOp: in std_logic_vector(1 downto 0);	
	
	--Output
	ALUControl: out std_logic_vector(2 downto 0)
);
end component;

component MainDec is
port(	
	--Input
	op: in std_logic_vector(5 downto 0);	
	
	--Output
	RegWrite, MemToReg, MemWrite, ALUSrc, RegDst, Branch: out std_logic;
	ALUOp: out std_logic_vector (1 downto 0)
);
end component;	 

--Control Unit Internal Signals
signal 	RegWrite, MemToReg, MemWrite, ALUSrc, RegDst, Branch: std_logic;
signal ALUOp: std_logic_vector (1 downto 0);   
signal ALUControl: std_logic_vector(2 downto 0);	

begin	
--Mapping	   
MainDecoder: MainDec port map (funct,RegWrite, MemToReg, MemWrite, ALUSrc, RegDst, Branch,ALUOp); 
ALUDecoder: ALUDec port map (funct, ALUOp,ALUControl);
end;