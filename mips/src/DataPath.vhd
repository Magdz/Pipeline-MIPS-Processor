library IEEE;
use IEEE.STD_LOGIC_1164.all; use STD.TEXTIO.all;
use IEEE.STD_LOGIC_UNSIGNED.all; use IEEE.STD_LOGIC_ARITH.all;

entity DataPath is 
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
	WriteRegW: buffer STD_Logic_vector (4 downto 0);
	-- Inputs from Memory
	DataRD: in STD_logic_vector (31 downto 0); 
	
	--Output to Memory
	AluOutM: buffer STD_Logic_vector(31 downto 0);
	WriteDataM: buffer STD_Logic_vector(31 downto 0) ;
	RsD,RtD: buffer STD_logic_vector(4 downto 0);
	-- Input From Instruction Memory
	InstrRD: in STD_logic_vector (31 downto 0); 	 
	PCF: buffer STD_logic_vector(31 downto 0)
	);	
	
end;				   			   

architecture struct of DataPath is 
component ALU 
	port(
	A: in STD_LOGIC_VECTOR(31 downto 0);	--input A	  
	B: in STD_LOGIC_VECTOR(31 downto 0);  	--input B
	C: in STD_LOGIC_VECTOR(2 downto 0);	 --control 
--	Z: out STD_LOGIC :='0';			  --zero not needed in pipeline
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
component Equator
	port(a, b: in  STD_LOGIC_VECTOR(31 downto 0); y: out STD_LOGIC); 
	end component;

component Shifter32 	
Port(
inp: in STD_LOGIC_VECTOR(31 downto 0);
outp: out STD_LOGIC_VECTOR (31 downto 0)

); end component ;
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



component LatchD  
	port(
	clk, reset: in STD_LOGIC;	 
	en: in std_logic;
	d1,d2: in STD_LOGIC_VECTOR(31 downto 0);
	q1,q2: out STD_LOGIC_VECTOR(31 downto 0));
end component;
	


component LatchE 
	port(
		clk, clr: in STD_LOGIC;	 
		RD1D,RD2D: in STD_LOGIC_VECTOR(31 downto 0);
		RD1E,RD2E: out STD_LOGIC_VECTOR(31 downto 0);	 
		RsD,RtD,RdD: in STD_LOGIC_VECTOR(4 downto 0);		  
		RsE,RtE,RdE: out STD_LOGIC_VECTOR(4 downto 0));
end component;

component LatchM
	port(
	clk: in STD_LOGIC;	 
	
	ALUOutE: in std_logic_vector(31 downto 0);
	WriteDataE: in STD_LOGIC_VECTOR(31 downto 0);
	WriteRegE: in STD_LOGIC_VECTOR(4 downto 0);
	
	ALUOutM: out std_logic_vector(31 downto 0);	
	WriteDataM: out STD_LOGIC_VECTOR(31 downto 0);  
	WriteRegM: out STD_LOGIC_VECTOR(4 downto 0)
	);
end component;

component LatchW 
		port(	  
	clk : in std_logic;
	RD: in std_logic_vector(31 downto 0);
	WriteDataM: in std_logic_vector(31 downto 0);
	WriteRegM: in std_logic_vector(4 downto 0);
	
	ReadDataW: out std_logic_vector(31 downto 0);
	ALUOutW: out std_logic_vector(31 downto 0);
	WriteRegW: buffer std_logic_vector(4 downto 0)
	);
end component; 
component RegFile
		 port( 
	clk, we3: in std_logic;
	ra1, ra2 : in std_logic_vector (4 downto 0); -- Read Address Port
	wa3 : in std_logic_vector(4 downto 0);	   -- Write Address Port
	wd3 : in std_logic_vector (31 downto 0);
	rd1, rd2 : out std_logic_vector(31 downto 0)
	);				
	end component;


--Signals___________________________________________
signal instr: std_logic_vector (31 downto 0);
signal data : std_logic_vector (31 downto 0);	  
signal SrcA, SrcB, ALUResult, ALUOut : std_logic_vector  (31 downto 0);	
--Fetch Signals
signal PCPlus4F: std_logic_vector (31 downto 0); 
signal PC: std_logic_vector (31 downto 0);

--Decode Signals  
signal PCPlus4D: std_logic_vector (31 downto 0);
signal writeReg: std_logic_vector (4 downto 0);
signal regInput: std_logic_vector (31 downto 0);   	
signal EqSrcA,EqSrcB: std_logic_vector (31 downto 0);   
signal PCBranchD: std_logic_vector (31 downto 0);
signal SignImmD: std_logic_vector (31 downto 0);
signal RD1, RD2,WD3: std_logic_vector (31 downto 0);
signal AdderSrcA :std_logic_vector (31 downto 0);
signal SignExIn: std_logic_vector(15 downto 0);
signal instrD: std_logic_vector (31 downto 0);
signal A1,A2,A3: std_logic_vector(4 downto 0); 	 
signal RdD: std_logic_vector (4 downto 0);
signal WE3: Std_logic;
signal EqualD: Std_logic;
--Execute Stage Signals
signal RD1E, RD2E: std_logic_vector(31 downto 0);  
signal RD1D, RD2D: std_logic_vector(31 downto 0);
signal srcAE, srcBE: std_logic_vector(31 downto 0);
signal WriteDataE, signImmE: std_logic_vector(31 downto 0);	 
signal ALUOutE: std_logic_vector(31 downto 0);
signal RdE, WriteRegE: std_logic_vector(4 downto 0);	
signal WriteRegM: std_logic_vector(4 downto 0);
signal notstallF, notStallD: std_logic;
--WriteBack Stage Signals
signal ResultW, ReadDataW,ALUOutW: std_logic_vector(31 downto 0);	 

						
begin 				   
	notstallF <= not stallF; 
	--Fetch Stage
	PCMux : Mux2 Generic map (32) port map (PCSrcD,PCPlus4F,PCBranchD,PC);
	PCLatch: Latch generic map (32) port map (clk, notstallF, '1', PC, PCF); 
	PCAdder: Adder port map (PCF, x"00000004", PCPlus4F);
	
	
	--Decode Stage
	notStallD <= not StallD;
	A1<= InstrD(25 downto 21);
	A2<= InstrD(20 downto 16);
	A3<= WriteRegW(4 downto 0);
	RsD	<= InstrD(25 downto 21);
	RtD <= InstrD(20 downto 16);
	RdD <= InstrD(15 downto 11);
	SignExIn<= InstrD(15 downto 0);
	MuxD1: 	    Mux2 generic map (32) port map (ForwardAD, RD1, ALUOutM, EqSrcA); 
	MuxD2:     	  Mux2 generic map (32) port map (ForwardAD, RD2, ALUOutM, EqSrcA); 
	Equ: Equator port map (EqSrcA,EqSrcB,EqualD); 
	Reg_File: RegFile port map (clk,WE3,A1,A2,A3,WD3,RD1,RD2);
	Sign_Extend: Signext port map (SignExIn,SignImmD);	
	Latch_Decode: LatchD port map (clk,reset,StallD,InstrRD,PCPlus4F,InstrD,PCPlus4D);
	Shifter: Shifter32 port map (SignImmD,AdderSrcA);
	AdderD: Adder port map (AdderSrcA,PCPlus4D,PCBranchD);
	
	
	
	
	
	--Execute Stage
	srcAMux4E:	 Mux4 generic map (32) port map (ForwardAE, RD1E, ResultW, ALUoutM, x"00000000", srcAE);
	srcBMux4E:	 Mux4 generic map (32) port map (ForwardBE, RD2E, ResultW, ALUoutM, x"00000000", WriteDataE);
	srcBMux2E: 	 Mux2 generic map (32) port map (ALUSrcE, WriteDataE, signImmE, srcBE);
	ALUCompE : 	 ALU  port map (srcAE, srcBE, ALUControlE, ALUOutE);
	RegDstMux2E: Mux2 generic map (5) port map (RegDstE,RtE,RdE, WriteRegE);
	ExecLatch: 	 LatchE port map (clk, FlushE, RD1D, RD2D, RD1E, RD2E, RsD, RtD, RdD, RsE, RtE, RdE);
	
	--Memory Stage
	MemLatch:    LatchM port map (clk, ALUOutE, WriteDataE, WriteRegE, ALUOutM, WriteDataM, WriteRegM);
	
	--WriteBack Stage
	WBLatch:     LatchW port map (clk, DataRD, WriteDataM, WriteRegM, ReadDataW, ALUOutW, WriteRegW);
	ResMux2E:    Mux2 generic map (32) port map (MemtoRegW, ReadDataW, ALUOutW,ResultW);
	
	
	
	
	
end;

