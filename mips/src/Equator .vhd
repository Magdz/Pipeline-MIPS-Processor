-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


use IEEE.STD_LOGIC_UNSIGNED.all;
entity adder is
port(a, b: in  STD_LOGIC_VECTOR(31 downto 0); y: out STD_LOGIC); 
end adder;

architecture Behavioral of adder is

begin
 y <='1'  when a=b else '0';

end Behavioral;

