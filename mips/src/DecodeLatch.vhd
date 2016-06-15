library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DecodeLatch is
    port(
	--Input
	clk,RegWriteD,MemtoRegD,MemWriteD, ALUSrcD,RegDstD: in std_logic;	 
	ALUControlD: in std_logic_vector(2 downto 0); 

	--Output
	RegWriteE,MemtoRegE,MemWriteE, ALUSrcE,RegDstE: out std_logic;	 
	ALUControlE: out std_logic_vector(2 downto 0)
	);
end;

architecture behave of DecodeLatch is
begin
        process(clk)
        begin
        if (clk='1') then
		RegWriteE   <= RegWriteD;
		MemtoRegE   <= MemtoRegD;
		MemWriteE   <= MemWriteD;
		ALUSrcE     <= ALUSrcD;
		RegDstE     <= RegDstD;
		ALUControlE <= ALUControlD;
        end if;
        end process;
end;