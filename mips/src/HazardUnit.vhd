library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity HazardUnit is
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
	
end;

architecture behave of HazardUnit is			   
--Lw Stall Signal
signal lwStall:  std_logic;	
signal s1, s2: std_logic;

--Decode Stage Forwarding
signal s3, s4: std_logic;
signal s5, s6: std_logic;

--Stall Detection Logic
signal s7, s8: std_logic;
signal s9, s10: std_logic;
begin															 
	-- Forwarding Logic
	process(RegWriteW,RegWriteM)  
	begin	
		--Forward to SrcA
		if (rsE /= x"00" and rsE = writeRegM and RegWriteM = '1')  then	--Forward from Memory
			ForwardAE <= "10";
		elsif (rsE /= x"00" and rsE = writeRegW and RegWriteW = '1')  then --Forward from WriteBack
			ForwardAE <= "10";
		else ForwardAE <= "00";
		end if;
		--Forward to SrcB
		if (rtE /= x"00" and rtE = writeRegM and RegWriteM = '1')  then	--Forward from Memory 
			ForwardBE <= "10";
		elsif (rtE /= x"00" and rtE = writeRegW and RegWriteW = '1')  then --Forward from WriteBack
			ForwardBE <= "10";
		else ForwardBE <= "00";
		end if;		
	end process;  
	
	--Stalling Logic									 
	-- tests if the destination register of lw matches either source operands of Decode Stage
	-- Instruction then must be stalled by clearing both the decode and execute stage

	s1 <= '1' when rsD = rtE else '0';
	s2 <= '1' when rtD = rtE else '0'; 
	lwStall <= (s1 or s2) and MemtoRegE;
	StallF <= lwStall;
	StallD <= lwStall;
	FlushE <= lwStall;
	
	--Decode Stage Forwarding
	s3 <= '1' when rsD /= x"00" else '0';
	s4 <= '1' when rsD = WriteRegM else '0';
	ForwardAD <= ((s3 and s4) and RegWriteM); 	
	
	s5 <= '1' when rtD /= x"00" else '0';
	s6 <= '1' when rtD = WriteRegM else '0';
	ForwardBD <= (s5 and s6) and RegWriteM; 
	
	--Stall Detection Logic
	s7 <= '1' when WriteRegE = rsD else '0';
	s8 <= '1' when WriteRegE = rtD else '0';
		
	s9 <= '1' when WriteRegM = rsD else '0';
	s10 <= '1' when WriteRegM = rtD else '0';
	
	branchStall <= ((branchD and  RegWriteE) and (s7 or s8))
	or 
	((branchD and MemtoRegM) and (s9 or s10));
	
end;
