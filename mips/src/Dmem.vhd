library IEEE;
use IEEE.std_logic_1164.all;			
use IEEE.STD_LOGIC_UNSIGNED.all; use IEEE.STD_LOGIC_ARITH.all;

entity Dmem is
	port(
	clk,WE: in std_logic;
	A: in std_logic_vector(31 downto 0);
	RD: out std_logic_vector(31 downto 0);
	WD: in std_logic_vector(31 downto 0));
end;

architecture behave of Dmem is
type ramtype is array (63 downto 0) of std_logic_vector (31 downto 0);
signal memD: ramtype;
begin

	process(clk)
	begin
		if (rising_edge(clk) and WE = '1') then 
			memD(conv_integer(A(7 downto 2))) <= WD;
		end if;
		RD <= memD(conv_integer(A(7 downto 2)));
	end process;

end;
