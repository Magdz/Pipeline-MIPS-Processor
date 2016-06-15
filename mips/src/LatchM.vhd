	 library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;



entity Latch is
generic(width: integer);
port(
clk, reset: in STD_LOGIC;	 
en: in std_logic;
d1,d2: in STD_LOGIC_VECTOR(width-1 downto 0);
q1,q2: out STD_LOGIC_VECTOR(width-1 downto 0);	 
WriteRegE:in  STD_LOGIC_VECTOR(4 downto 0);
WriteRegM:out   STD_LOGIC_VECTOR(4 downto 0));
end;
architecture async of Latch is
begin
process(clk, reset) begin	 
	if reset = '1' then q1 <=x"0000";
		q2<= 	x"0000"				 ;
		WriteRegM<=CONV_STD_LOGIC_VECTOR(0,5);
		
elsif rising_edge(clk) and en = '1' then
q1 <= d1;
q2 <= d2;
  WriteRegM<=WriteRegE;

			 end if    ;
end process;
end;
