	 library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;



entity Latch is
generic(width: integer);
port(
clk, reset: in STD_LOGIC;	 
en: in std_logic;
d1,d2,d3: in STD_LOGIC_VECTOR(31 downto 0);
q1,q2,q3: out STD_LOGIC_VECTOR(31 downto 0);	 
RsD,RtD,RdD: in STD_LOGIC_VECTOR(4 downto 0);		  
RsE,RtE,RdE: out STD_LOGIC_VECTOR(4 downto 0));
end;
architecture async of Latch is
begin
process(clk, reset) begin	 
	if reset = '1' then 
		q1<=    x"00000000";
		q2<= 	x"00000000"		;	
		q3<= 	x"00000000";
		RsE<=	CONV_STD_LOGIC_VECTOR(0, 5);
		RtE<=	CONV_STD_LOGIC_VECTOR(0, 5);
		RdE<=	CONV_STD_LOGIC_VECTOR(0, 5);
		
elsif rising_edge(clk) and en = '1' then
q1 <= d1;
q2 <= d2;
q3<=d3;	
RsE<=	RsD;
RtE<=	RtD;
RdE<=	RdD;
		

			 end if    ;
end process;
end;
