library ieee;
use ieee.std_logic_1164.all;

entity piso is 
  port(
    clk: in std_logic;
	 rst: in std_logic;
	 data: in std_logic_vector(8 downto 0);
	 sin: in std_logic;
	 en: in std_logic;
	 load: in std_logic;
	 y: out std_logic_vector(8 downto 0)
  );
end piso;

architecture imp of piso is
  signal mem: std_logic_vector(8 downto 0);
begin
  y<= mem;
  process(clk)
  begin
    if (clk'event and clk='1') then
	   if (en='1') then
		  if (rst='1') then 
		    mem<= (others => '0');
		  else 
		    if (load='1') then
			   mem<= data;
			 else
			   mem(7 downto 0)<= mem(8 downto 1);
				mem(8)<= sin;
			 end if;
		  end if;
		end if;
	 end if;
  end process;
end imp;