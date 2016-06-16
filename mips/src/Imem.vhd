library IEEE;
use IEEE.STD_LOGIC_1164.all; use STD.TEXTIO.all;
use IEEE.STD_LOGIC_UNSIGNED.all; use IEEE.STD_LOGIC_ARITH.all;

entity imem is
	port( 
	A: in std_logic_vector (31 downto 0);
	RD: out std_logic_vector(31 downto 0)
	);
end;									 

architecture behave of imem is
type ramtype is array (63 downto 0) of std_logic_vector(31 downto 0);  -- 64 x 32 wide Ram (2KB)--
begin		  
	process is
	File mem_file: TEXT;
	variable L: Line;
	variable ch: character;
	variable index, result: integer; 
	variable mem: ramtype;
	begin
		for i in 0 to 63 loop
			mem(conv_integer(i)):=conv_std_logic_vector(0,32);
		end loop;
		index := 0;
		FILE_OPEN(mem_file,"Data.txt",read_mode);
		while not ENDFILE(mem_file) loop
			readline(mem_file,L);
			result := 0;
			for i in 1 to 8	  loop
				read(L,ch);
				if '0' <= ch and ch<='9' then 
					result := result*16 + character'pos(ch) - character'pos('0');
				elsif 'a' <= ch and ch <= 'f' then
					result := result*16 + character'pos(ch) - character'pos('a');
				else
					report "Format error on line" & integer'image(index) severity error;
				end if;		
			end loop;	
			mem(index) := conv_std_logic_vector(result,32);
			index := index + 1;
		end loop;
		FILE_CLOSE(mem_file);
		
		loop 
			rd <= mem(conv_integer(A));
			wait on A;
		end loop;		
	end process;
end;

