library IEEE;
use IEEE.STD_logic_1164.all;

entity Mips is
	port(
	clk, reset: in std_logic;
	
	--Instruction Memory Link
	PCF: out std_logic_vector(31 downto 0);
	InstrRD: in std_logic_vector(31 downto 0);
	
	--Data Memory Link
	DataA:  out std_logic_vector(31 downto 0);
	WD: out std_logic_vector(31 downto 0);
	DataRd: in std_logic_vector(31 downto 0);
	WE: out std_logic
	);				 					  
	
end;				 

architecture struct of Mips is

component DataPath 
	port(
	clk, reset: in STD_logic;
	-- Inputs from Controller
	PCSrcD,RegDstE,AluSrcE,MemWriteM,MemtoRegW,RegWriteW: in STD_logic;
	-- Inputs from Hazard Unit
	StallF,StallD,ForwardAD,ForawrdBD,FlushE : in STD_logic;
	ForwardAE,ForwardBE : in STD_logic_vector(1 downto 0);
	-- Outputs to Hazard Unit
	RsE: buffer std_Logic_vector(4 downto 0);
	RtE: buffer std_Logic_vector(4 downto 0);
	ALUControlE: in STD_logic_vector (2 downto 0);
	WriteRegW: out STD_Logic_vector (4 downto 0);
	-- Inputs from Memory
	DataRD: in STD_logic_vector (31 downto 0); 
	
	--Output to Memory
	AluOutM: buffer STD_Logic_vector(31 downto 0);
	WriteDataM: buffer STD_Logic_vector(31 downto 0) ;
	RsD,RtD: buffer STD_logic_vector(4 downto 0);
	-- Input From Instruction Memory
	InstrRD: in STD_logic_vector (31 downto 0); 	 
	PCF: out STD_logic_vector(31 downto 0)
	);
end component;		

component HazardUnit
port(
	--Forwarding
	RegWriteW, RegWriteM : in STD_Logic; --Control Signals to know whether the destination register will be written.
	rsE, rtE, WriteRegM, WriteRegW: in STD_Logic_vector(4 downto 0); -- To compare source and destination registers
	ForwardBE, ForwardAE : out STD_Logic_vector (1 downto 0); 	--To output the data to the ALUSrc through the MUX
	
	--Stalling
	MemtoRegE: in std_logic;  
	rsD,  rtD: in std_logic_vector(4 downto 0);
	FlushE, StallD, StallF: out std_logic;
	
	--Decode Stage Forwarding
	ForwardAD, ForwardBD : out STD_Logic;
	
	--Stall Detection Logic			
	RegWriteE, MemtoRegM: in std_logic;
	WriteRegE: in std_logic_vector(4 downto 0);
	branchD : in std_logic;
	branchStall: out std_logic
	);
end component;
component Controller
	port(	 
	--Input
	clk, reset: in std_logic;
	op,funct: in std_logic_vector(5 downto 0);
	EqualD: in std_logic;
	
	--Decode Stage Output
	PCSrcD: out std_logic;
	
	--Execute Stage Output
	RegDstE, ALUSrcE: out std_logic;
	ALUControlE: out std_logic_vector(2 downto 0);
	
	--Memory Stage Output
	MemWriteM: out std_logic;
	
	--Writeback Stage Output
	RegWriteW, MemtoRegW: out std_logic
	);
end component;				   

--Controller
signal op, funct: std_logic_vector(5 downto 0);
signal EqualD, PCSrcD: std_logic;
signal RegDstE, ALUSrcE: std_logic;
signal ALUControlE: std_logic_vector(2 downto 0);
signal MemWriteM, MemtoRegW, RegWriteW: std_logic;

signal StallF, StallD, ForwardAD, ForwardBD, FlushE: std_logic;
signal ForwardAE, ForwardBE: std_logic_vector(1 downto 0);
signal RsE, RtE, RsD, RtD: std_logic_vector(4 downto 0);
signal ALUOutM, WriteDataM: std_logic_vector(31 downto 0); 
signal WriteRegW: std_logic_vector(4 downto 0);		

signal RegWriteM, MemtoRegE, RegWriteE,MemtoRegM,branchStall: std_logic; 
signal WriteRegE, WriteRegM: std_logic_vector(4 downto 0);

signal branchD: std_logic;
begin
	cont: Controller port map (clk, reset, op, funct, EqualD, PCSrcD, RegDstE, ALUSrcE,
	ALUControlE,MemWriteM,RegWriteW, MemtoRegW);
	
	process begin
		op <="000000";
		wait;
	end process;
	
	process begin
		funct <= "100000" ;
		wait;
	end process;
	
	process begin
		EqualD <= '0';
		wait;
	end process;
	
	--dp: DataPath port map (
	--clk, reset,	PCSrcD, RegDstE, AluSrcE,
	--MemWriteM, MemtoRegW, RegWriteW, StallF,
	--StallD, ForwardAD, ForwardBD, FlushE,
	--ForwardAE, ForwardBE, RsE, RtE, ALUControlE, 
	--WriteRegW, DataRD, AluOutM,
	--WriteDataM, RsD, RtD, InstrRD);
	
	--Hazunit: HazardUnit port map(
	--RegWriteW, RegWriteM,rsE, rtE, WriteRegM, WriteRegW,ForwardBE, ForwardAE,
	--MemtoRegE,rsD,  rtD,
	--FlushE, StallD, StallF,	
	--ForwardAD, ForwardBD,			
	--RegWriteE, MemtoRegM,
	--WriteRegE,
	--branchD,
	--branchStall
	--);
	
end;

