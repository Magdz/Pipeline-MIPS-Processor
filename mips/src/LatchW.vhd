library IEEE;
use IEEE.std_logic_1164.all;


entity LatchW is
	port(	  
	reset, clk : in std_logic;
	RD: in std_logic_vector(31 downto 0);
	ALUOutM: in std_logic_vector(31 downto 0);
	WriteRegM: in std_logic_vector(4 downto 0);
	
	ReadDataW: out std_logic_vector(31 downto 0);
	ALUOutW: out std_logic_vector(31 downto 0);
	WriteRegW: out std_logic_vector(4 downto 0)
	);
end;											

architecture behave of LatchW is
begin
	process (clk) 
	begin
		if rising_edge(clk) then
		ReadDataW  <= RD;
		ALUOutW   <= ALUOutM;
		WriteRegW <= WriteRegM;
		end if;
	end process;
end;

