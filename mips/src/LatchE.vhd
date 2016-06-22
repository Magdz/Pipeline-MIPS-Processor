	 library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;



entity LatchE is
	port(
		reset, clk, clr: in STD_LOGIC;	 
		RD1D,RD2D: in STD_LOGIC_VECTOR(31 downto 0);
		RD1E,RD2E: out STD_LOGIC_VECTOR(31 downto 0);	 
		RsD,RtD,RdD: in STD_LOGIC_VECTOR(4 downto 0);		  
		RsE,RtE,RdE: out STD_LOGIC_VECTOR(4 downto 0);
		SignImmD: in STD_logic_vector(31 downto 0);
		signImmE: out STD_logic_vector(31 downto 0)
		);
end;
architecture async of LatchE is
begin
	process(clk, clr) begin	 
		if clk'event and clk = '1'  then
			if clr = '1' then 
			    RsE  <=	"-----";
				RtE  <= "-----";
				RdE  <=	"-----";
				signImmE <= x"00000000"; 
			else 
				RD1E <= RD1D;
				RD2E <= RD2D;
				RsE  <=	RsD;
				RtE  <=	RtD;
				RdE  <=	RdD;
				signImmE <= SignImmD;
			end if; 
		end if;
		 
	end process; 
end;