library IEEE;
use IEEE.STD_LOGIC_1164.all;		
use IEEE.STD_LOGIC_UNSIGNED.all;

entity RegFile is
	port( 
	clk, we3: in std_logic;
	ra1, ra2 : in std_logic_vector (4 downto 0); -- Read Address Port
	wa3 : in std_logic_vector(4 downto 0);	   -- Write Address Port
	wd3 : in std_logic_vector (31 downto 0);
	rd1, rd2 : out std_logic_vector(31 downto 0)
	);											 
	
end;

architecture behave of Regfile is
type ram_type is array (31 downto 0) of STD_LOGIC_VECTOR (31 downto 0);
signal mem: ram_type;

begin
	process(clk) begin
		if clk'event and clk = '1' then
			if we3 = '1'  then
			mem(CONV_INTEGER(wa3)) <= wd3  ;	
			end if;
		end if;		   
	end process;
	
	process(ra1,ra2) begin
		--set register data to 0s if ra1 or ra2 is register 0;						
			if(CONV_INTEGER(ra1) = 0)	then
				rd1 <= (others => '0');		 
			else
				rd1 <= mem(CONV_INTEGER(ra1));
			end if;
			
			if(CONV_INTEGER(ra2) = 0)	then
				rd2 <= (others => '0');		 
			else
				rd2 <= mem(CONV_INTEGER(ra2));
			end if;
			
	end process;	

end;


