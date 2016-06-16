	 library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;



entity Latch is
generic(width: integer);
port(
clk, clr: in STD_LOGIC;	 
en: in std_logic;
d1,d2: in STD_LOGIC_VECTOR(width-1 downto 0);
q1,q2: out STD_LOGIC_VECTOR(width-1 downto 0));
end;
architecture async of Latch is
begin
process(clk, clr) begin	 
	if clr = '1' then q1 <=x"0000";
		q2<= 	x"0000"				 ;
elsif rising_edge(clk) and en = '1' then
q1 <= d1;
q2 <= d2;

			 end if    ;
end process;
end;
