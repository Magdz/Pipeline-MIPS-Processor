library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;

entity TestBench is
end;

architecture Test of TestBench is
component TopFrame
	port(
	--Input Signals
	clk, reset: in STD_logic;
	MemWrite: buffer STD_logic;
	Adr, WD: buffer STD_logic_vector(31 downto 0)
	);
end component; 

signal clk, reset, MemWrite: STD_logic;
signal DataAdr, WriteData: STD_logic_vector(31 downto 0);

begin
	Top: TopFrame port map (clk, reset, MemWrite, DataAdr, WriteData);
	
	process begin
		clk <= '1';
		wait for 5 ns;
		clk <= '0';
		wait for 5 ns;
	end process;
	
	process begin
		reset <= '1';
		wait for 22 ns;
		reset <= '0';
		wait;
	end process;
	
	--Driving process
	process (clk) begin
		if (clk'event and clk = '0' and MemWrite = '1') then
		if (conv_integer(DataAdr) = 84 and conv_integer(WriteData) = 7) then report "Simulation succeeded";
		elsif (DataAdr /= 80) then report "Simulation failed";
		end if;
		end if;
	end process;
	
end;	