library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;

entity LatchM is
port(
	reset, clk: in STD_LOGIC;	 
	
	ALUOutE: in std_logic_vector(31 downto 0);
	WriteDataE: in STD_LOGIC_VECTOR(31 downto 0);
	WriteRegE: in STD_LOGIC_VECTOR(4 downto 0);
	
	ALUOutM: out std_logic_vector(31 downto 0);	
	WriteDataM: out STD_LOGIC_VECTOR(31 downto 0);  
	WriteRegM: out STD_LOGIC_VECTOR(4 downto 0)
	);
end;
architecture async of LatchM is
begin
	process(clk)
	begin
		if rising_edge(clk)	then
		ALUOutM    <= ALUOutE;
		WriteDataM <= WriteDataE;
		WriteRegM  <= WriteRegE;
		end if;
	end process;
end;
