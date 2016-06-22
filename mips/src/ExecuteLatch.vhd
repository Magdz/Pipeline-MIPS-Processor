					  library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ExecuteLatch is
    port(
	--Input
	clk, RegWriteE,MemtoRegE,MemWriteE: in std_logic;

	--Output
	RegWriteM,MemtoRegM,MemWriteM: out std_logic	 
	);
end;

architecture behave of ExecuteLatch is
begin
        process(clk)
        begin
        if (clk'event and clk='1') then
		RegWriteM   <= RegWriteE;
		MemtoRegM  <= MemtoRegE;
		MemWriteM   <= MemWriteE;
        end if;
        end process;
end;