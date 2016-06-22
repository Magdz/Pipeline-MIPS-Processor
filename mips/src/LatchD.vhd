	 library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;



entity LatchD is
port(
	clk, reset, PCSrc: in STD_LOGIC;	 
	notStallD: in std_logic;
	InstrRD,PCPlus4F: in STD_LOGIC_VECTOR(31 downto 0);
	InstrD,PCPlus4D: out STD_LOGIC_VECTOR(31 downto 0));
end;

architecture async of LatchD is
begin
process(clk, PCSrc) begin	 
	if rising_edge(clk) then
	if PCSrc = '1' then 
		InstrD <= x"00000000";
		PCPlus4D <= x"00000000";
	elsif notStallD = '1' then
	InstrD <= InstrRD;
	PCPlus4D <= PCPlus4F;	 
	end if;
end if;
end process;
end;
