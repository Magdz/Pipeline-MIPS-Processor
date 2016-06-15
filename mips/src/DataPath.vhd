					  library IEEE;
use IEEE.STD_LOGIC_1164.all; use STD.TEXTIO.all;
use IEEE.STD_LOGIC_UNSIGNED.all; use IEEE.STD_LOGIC_ARITH.all;

entity DataPath is 
	port(
	clk, reset: in STD_logic;
	-- Inputs from Controller
	PCSrcD,RegDestE,AluSrcE,MemWriteM,MemtoRegW,RegWriteW: in STD_logic;
					 -- Inputs from Hazard Unit
	StallF,StallD,ForwardAD,ForawrdAB,FlushE,ForwardAE,ForwardBE : in STD_logic;
	ALUControlE: in STD_logic_vector (2 downto 0);
	-- Inputs from Memory
	DataRD: in STD_logic_vector (31 downto 0); 
	--Output to Memory
	AluOutM,WriteDataM: Out STD_Logic_vector(31 downto 0) ;
									 RsD,RtD,RdD:out STD_logic_vector(4 downto 0);
	-- Input From Instruction Memory
	ImemRD: out STD_logic_vector (31 downto 0) 	  );	
	
end;				   			   

architecture struct of DataPath is 
component ALU 
	port(
	A: in STD_LOGIC_VECTOR(31 downto 0);	--input A	  
	B: in STD_LOGIC_VECTOR(31 downto 0);  	--input B
	C: in STD_LOGIC_VECTOR(2 downto 0);	 --control 
	Z: out STD_LOGIC :='0';			  --zero
	AluOut: out STD_LOGIC_VECTOR (31 downto 0)
	);
end component;	   

component Mux2
	generic (width: integer);
	port(
	selector : in std_logic;
	in0, in1 : in std_logic_vector(width-1 downto 0);
	output   : out STD_LOGIC_VECTOR(width-1 downto 0)
	) ;
end component;

component Mux4	
	generic(width: integer);
	port(				  
	selector: in STD_LOGIC_VECTOR (1 downto 0);
	in0, in1, in2, in3: in STD_LOGIC_VECTOR (width-1 downto 0);
	output: out STD_LOGIC_VECTOR (width-1 downto 0)
	);
end component;

component Latch	
	generic(width: integer);
	port(
	clk, reset: in STD_LOGIC;
	en: in STD_LOGIC;
	d: in STD_LOGIC_VECTOR(width-1 downto 0);
	q: out STD_LOGIC_VECTOR(width-1 downto 0));
end component;

			component Signext 
	port(
	a: in STD_LOGIC_VECTOR (15 downto 0);
	output: out STD_LOGIC_VECTOR(31 downto 0)
	);
end component;								 
component Adder 
	port(a, b: in  STD_LOGIC_VECTOR(31 downto 0);
	y: out STD_LOGIC_VECTOR(31 downto 0)); 
end component;


--Signals___________________________________________
signal instr: std_logic_vector (31 downto 0);
signal data : std_logic_vector (31 downto 0);	  
signal SrcA, SrcB, ALUResult, ALUOut : std_logic_vector  (31 downto 0);	   
--Reg Signals 
signal writeReg: std_logic_vector (4 downto 0);
signal regInput: std_logic_vector (31 downto 0);   
signal RD1, RD2,WD3: std_logic_vector (31 downto 0); 
signal instrD: std_logic_vector (31 downto 0);
signal A1,A2,A3: std_logic_vector(4 downto 0);

						
begin 
	
	end;

