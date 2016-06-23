library IEEE;
use IEEE.std_logic_1164.all;

entity TopFrame	is
	port(clk, reset	: in std_logic;
	MemWrite: buffer STD_logic;
	Adr, WD: buffer STD_logic_vector(31 downto 0)
	);
end;

architecture  struct of  TopFrame is
component Dmem 
	port(
	clk,WE: in std_logic;
	A: in std_logic_vector(31 downto 0);
	RD: out std_logic_vector(31 downto 0);
	WD: in std_logic_vector(31 downto 0));
end component;

component imem 
	port( 
	A: in std_logic_vector (31 downto 0);
	RD: out std_logic_vector(31 downto 0)
	);
end component;
component Mips
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

end component;					
signal ALUOutM: std_Logic_vector (31 downto 0);
signal WriteDataM: std_Logic_vector (31 downto 0); 
signal dataRD: std_Logic_vector (31 downto 0);
signal WE: std_logic;
signal PCF: std_Logic_vector (31 downto 0);
signal InstrRD: std_Logic_vector (31 downto 0);


begin
	instmem: Imem port map (PCF, InstrRD);
	mps    : Mips port map (clk, reset, PCF, InstrRD, ALUOutM, WriteDataM, dataRD, WE, MemWrite);
	datamem: Dmem port map (clk, WE, Adr, dataRD, WD); 
	
	
	WD <= WriteDataM;
	Adr <= ALUOutM;
end;
