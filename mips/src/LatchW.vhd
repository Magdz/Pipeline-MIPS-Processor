library IEEE;
use IEEE.std_logic_1164.all;


entity LatchW is
	port(	  
	reset, clk : in std_logic;
	RD: in std_logic_vector(31 downto 0);
	WriteDataM: in std_logic_vector(31 downto 0);
	WriteRegM: in std_logic_vector(4 downto 0);
	
	ReadDataW: out std_logic_vector(31 downto 0);
	ALUOutW: out std_logic_vector(31 downto 0);
	WriteRegW: out std_logic_vector(4 downto 0)
	);
end;											

architecture behave of LatchW is
begin
	process(clk) 
	begin	   
		ReadDataW  <= RD;
		ALUOutW   <= WriteDataM;
		WriteRegW <= WriteRegM;
	end process;
end;

