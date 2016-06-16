library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Controller is
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
end;			
architecture struct of Controller is
component ControlUnit is
port(	

--Input
op,funct: in std_logic_vector(5 downto 0);	

--Ouput
RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, RegDstD, BranchD: out std_logic;	 
ALUControlD: out std_logic_vector(2 downto 0)
);
end component;


--Latches
component DecodeLatch is
port(
	--Input
	clk,RegWriteD,MemtoRegD,MemWriteD, ALUSrcD,RegDstD: in std_logic;	 
	ALUControlD: in std_logic_vector(2 downto 0); 

	--Output
	RegWriteE,MemtoRegE,MemWriteE, ALUSrcE,RegDstE: out std_logic;	 
	ALUControlE: out std_logic_vector(2 downto 0)
);
end component;	

component ExecuteLatch is
port(	
--Input
clk,RegWriteE,MemtoRegE,MemWriteE: in std_logic;	 

--Output
RegWriteM,MemtoRegM,MemWriteM: out std_logic	 
);
end component;	 

component MemoryLatch is
port(	
--Input
clk,RegWriteM,MemtoRegM: in std_logic;

--Output
RegWriteW,MemtoRegW: out std_logic
);
end component;			

--Internal Signals
signal BranchD, RegWriteD,MemtoRegD,MemWriteD, ALUSrcD,RegDstD,MemtoRegE,MemWriteE,RegWriteM,MemtoRegM,RegWriteE: std_logic;	 
signal ALUControlD: std_logic_vector(2 downto 0);

begin		
	
--Decode PCSrc Logic
PCSrcD <= BranchD and EqualD;

--Mappings
cu: ControlUnit port map (op, funct, RegWriteD,MemtoRegD,MemWriteD, ALUSrcD,RegDstD, BranchD, ALUControlD);
dlatch: DecodeLatch port map(clk,RegWriteD,MemtoRegD,MemWriteD, ALUSrcD,RegDstD,ALUControlD
								,RegWriteE,MemtoRegE,MemWriteE, ALUSrcE,RegDstE, ALUControlE);
elatch: ExecuteLatch port map(clk,RegWriteE,MemtoRegE,MemWriteE,RegWriteM,MemtoRegM,MemWriteM);
mlatch: MemoryLatch port map(clk,RegWriteM,MemtoRegM,RegWriteW,MemtoRegW);

PCSrcD <= BranchD and EqualD;

end;