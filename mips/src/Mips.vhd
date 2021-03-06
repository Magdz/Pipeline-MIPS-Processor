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
	WE: out std_logic;
	MemWriteM: buffer std_logic
	);				 					  
	
end;				 

architecture struct of Mips is

component DataPath 
	port(
	clk, reset: in STD_logic;
	-- Inputs from Controller
	PCSrcD : in std_logic_vector(1 downto 0);
	RegDstE,AluSrcE,MemWriteM,MemtoRegW,RegWriteW: in STD_logic;
	-- Inputs from Hazard Unit
	StallF,ForwardAD,ForwardBD,FlushE : in STD_logic;
	StallD: inout STD_LOGIC;
	ForwardAE,ForwardBE : in STD_logic_vector(1 downto 0);
	-- Outputs to Hazard Unit
	RsE: buffer std_Logic_vector(4 downto 0);
	RtE: buffer std_Logic_vector(4 downto 0);
	ALUControlE: in STD_logic_vector (2 downto 0);
	WriteRegE, WriteRegM, WriteRegW: out STD_Logic_vector (4 downto 0);
	-- Inputs from Memory
	DataRD: in STD_logic_vector (31 downto 0); 
	
	--Output to Memory
	AluOutM: buffer STD_Logic_vector(31 downto 0);
	WriteDataM: buffer STD_Logic_vector(31 downto 0) ;
	RsD,RtD: buffer STD_logic_vector(4 downto 0);
	-- Input From Instruction Memory
	InstrRD: in STD_logic_vector (31 downto 0); 	 
	PCF: out STD_logic_vector(31 downto 0);
	-- Output to Controller						
	EqualD: out STD_logic;
	op, funct: out STD_logic_vector (5 downto 0)
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
	FlushE,  StallF: out std_logic;
	StallD: inout std_logic;
	
	--Decode Stage Forwarding
	ForwardAD, ForwardBD : out STD_Logic;
	
	--Stall Detection Logic			
	RegWriteE, MemtoRegM: in std_logic;
	WriteRegE: in std_logic_vector(4 downto 0);
	branchD , jumpD: in std_logic
	);
end component;
component Controller
	port(	 
	--Input
	clk, reset: in std_logic;
	op,funct: in std_logic_vector(5 downto 0);
	EqualD: in std_logic;
	
	--Decode Stage Output
	PCSrcD: out std_logic_vector (1 downto 0);
	FlushE: in STD_Logic;
	
	--Execute Stage Output
	RegDstE, ALUSrcE, MemtoRegEo: out std_logic;
	ALUControlE: out std_logic_vector(2 downto 0);
	
	--Memory Stage Output
	MemWriteM: out std_logic;
	RegWriteM: buffer STD_logic;
	
	--Writeback Stage Output
	RegWriteW, MemtoRegW: out std_logic;
	BranchD,RegWriteE, MemtoRegM, JumpD: buffer std_logic
	);
end component;				   

--Controller
signal op, funct: std_logic_vector(5 downto 0);
signal EqualD : std_logic;
signal PCSrcD: std_logic_vector (1 downto 0);
signal RegDstE, ALUSrcE: std_logic;
signal ALUControlE: std_logic_vector(2 downto 0);
signal MemtoRegW, RegWriteW: std_logic;

signal StallF, StallD, ForwardAD, ForwardBD, FlushE: std_logic;
signal ForwardAE, ForwardBE: std_logic_vector(1 downto 0);
signal RsE, RtE, RsD, RtD: std_logic_vector(4 downto 0);
signal ALUOutM, WriteDataM: std_logic_vector(31 downto 0); 
signal WriteRegW: std_logic_vector(4 downto 0);		

signal RegWriteM, MemtoRegE, RegWriteE,MemtoRegM: std_logic; 
signal WriteRegE, WriteRegM: std_logic_vector(4 downto 0);

signal branchD, JumpD: std_logic;
begin
	WE <= MemWriteM;
	
	cont: Controller port map (clk, reset, op, funct, EqualD, PCSrcD, FlushE, RegDstE, ALUSrcE, MemtoRegE,
	ALUControlE,MemWriteM, RegWriteM, RegWriteW, MemtoRegW, branchD,RegWriteE, MemtoRegM , JumpD
	);
	
	dp: DataPath port map (
	clk, reset, PCSrcD, RegDstE, AluSrcE,
	MemWriteM, MemtoRegW, RegWriteW, StallF,
	ForwardAD, ForwardBD, FlushE, StallD,
	ForwardAE, ForwardBE, RsE, RtE, ALUControlE, 
	WriteRegE, WriteRegM, WriteRegW, DataRD, AluOutM,
	WriteDataM, RsD, RtD, InstrRD, PCF, EqualD, op, funct
	);		   
	
	Hazunit: HazardUnit port map(
	RegWriteW, RegWriteM,rsE, rtE, WriteRegM, WriteRegW,ForwardBE, ForwardAE,
	MemtoRegE,rsD,  rtD,
	FlushE, StallF, StallD,	
	ForwardAD, ForwardBD,			
	RegWriteE, MemtoRegM,
	WriteRegE,
	branchD, jumpD
	);
	
	dataA <= AluOutM;  
	WD <= WriteDataM;
	
end;

