	 library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;



entity LatchE is
	port(
		clk, clr: in STD_LOGIC;	 
		RD1D,RD2D: in STD_LOGIC_VECTOR(31 downto 0);
		RD1E,RD2E: out STD_LOGIC_VECTOR(31 downto 0);	 
		RsD,RtD,RdD: in STD_LOGIC_VECTOR(4 downto 0);		  
		RsE,RtE,RdE: out STD_LOGIC_VECTOR(4 downto 0));
end;
architecture async of LatchE is
begin
	process(clk, clr) begin	 
		if clr = '1' then 
			RD1E <= x"00000000";
			RD2E <= x"00000000"		;	
			RsE  <=	CONV_STD_LOGIC_VECTOR(0, 5);
			RtE  <=	CONV_STD_LOGIC_VECTOR(0, 5);
			RdE  <=	CONV_STD_LOGIC_VECTOR(0, 5);
		elsif rising_edge(clk) then
			RD1E <= RD1D;
			RD2E <= RD2D;
			RsE  <=	RsD;
			RtE  <=	RtD;
			RdE  <=	RdD;	
		 end if;
	end process; 
end;