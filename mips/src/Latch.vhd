library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;



entity Latch is
generic(width: integer);
port(
clk, reset: in STD_LOGIC;	 
en: in std_logic;
d: in STD_LOGIC_VECTOR(width-1 downto 0);
q: out STD_LOGIC_VECTOR(width-1 downto 0));
end;
architecture async of Latch is
begin
process(clk, reset) begin	 
	if reset = '1' then q <= CONV_STD_LOGIC_VECTOR(0, width);
elsif rising_edge(clk) and en = '1' then
q <= d;

			 end if    ;
end process;
end;
