library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DecodeLatch is
    port(
	--Input
	clk,clr, RegWriteD,MemtoRegD,MemWriteD, ALUSrcD,RegDstD: in std_logic;	 
	ALUControlD: in std_logic_vector(2 downto 0); 

	--Output
	RegWriteE,MemtoRegE,MemWriteE, ALUSrcE,RegDstE: out std_logic;	 
	ALUControlE: out std_logic_vector(2 downto 0)
	);
end;

architecture behave of DecodeLatch is
begin
    process(clk, clr)
    begin
        if (clk'event and clk='1') then
			if (clr = '1') then 
			RegwriteE <= '-';
			MemWriteE <= '-';
			
			else
				RegWriteE   <= RegWriteD;
				MemtoRegE   <= MemtoRegD;
				MemWriteE   <= MemWriteD;
				ALUSrcE     <= ALUSrcD;
				RegDstE     <= RegDstD;
				ALUControlE <= ALUControlD;
	    	end if;
		end if;
	end process;
end;