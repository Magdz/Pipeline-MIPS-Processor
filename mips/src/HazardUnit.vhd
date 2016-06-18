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
	FlushE, StallF: out std_logic;	
	stallD: inout std_logic;
	
	--Decode Stage Forwarding
	ForwardAD, ForwardBD : out STD_Logic;
	
	--Stall Detection Logic			
	RegWriteE, MemtoRegM: in std_logic;
	WriteRegE: in std_logic_vector(4 downto 0);
	branchD : in std_logic
	);
	
end;

architecture behave of HazardUnit is			   
--Lw Stall Signal		
signal lwStall,branchStall: std_logic;	

--Decode Stage Forwarding

--Stall Detection Logic

begin
	-- Forwarding Logic
	process(rsE, rtE, WriteRegM, RegWriteM, writeRegW, RegWriteW)  
	begin				 
		ForwardAE <= "00";	  
		ForwardBE <= "00";
		--Forward to SrcA
		if (rsE /= "00000" )  then
			if (rsE = writeRegM and RegWriteM = '1')  then	--Forward from Memory
			ForwardAE <= "10";
			elsif ( rsE = writeRegW and RegWriteW = '1')  then --Forward from WriteBack
			ForwardAE <= "01";
			end if;				  
		end if;
		--Forward to SrcB
		if (rtE /= "00000" ) then 
			if (rtE = writeRegM and RegWriteM = '1')  then	--Forward from Memory 
			ForwardBE <= "10";
			elsif (rtE = writeRegW and RegWriteW = '1')  then --Forward from WriteBack
			ForwardBE <= "01";
			end if;		
		end if;	
	end process;  
	
	--Stalling Logic									 
	-- tests if the destination register of lw matches either source operands of Decode Stage
	-- Instruction then must be stalled by clearing both the decode and execute stage

	lwstall <= '1' when ((memtoregE = '1') and ((rtE = rsD) or (rtE = rtD)))
				else '0'; 				
	
	branchstall <= '1' when ((branchD = '1') and
								(((regwriteE = '1') and
								((writeregE = rsD) or (writeregE = rtD))) or
								((memtoregM = '1') and
								((writeregM = rsD) or (writeregM = rtD)))))
						   else '0';
	stallD <= (lwstall or branchstall) after 1 ns;
	stallF <= stallD after 1 ns;
	flushE <= stallD after 1 ns;
	
	--Decode Stage Forwarding
	forwardaD <= '1' when ((rsD /= "00000") and (rsD = writeregM) and
	(						regwriteM = '1'))
					else '0';	
	
	forwardbD <= '1' when ((rtD /= "00000") and (rtD = writeregM) and
							(regwriteM = '1'))
					else '0';
	
end;
