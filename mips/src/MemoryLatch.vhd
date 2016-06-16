library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MemoryLatch is
    port(
	--Input
	clk,RegWriteM,MemtoRegM: in std_logic;

	--Output
	RegWriteW,MemtoRegW: out std_logic	 
	);
end;

architecture behave of MemoryLatch is
begin
        process(clk)
        begin
        if (clk'event and clk='1') then
		RegWriteW   <= RegWriteM;
		MemtoRegW  <= MemtoRegM;
        end if;
        end process;
end;