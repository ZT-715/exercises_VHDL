library ieee;
use ieee.std_logic_1164.all;

entity serialadd is
  port(
    a,b: in std_logic_vector(7 downto 0);
	 start: in std_logic;
	 resetn: in std_logic;
	 clk: in std_logic;
	 sum: out std_logic_vector(8 downto 0)
  );
end serialadd;

architecture imp of serialadd is
  signal df: std_logic; -- flip-flop
  -- conexoes
  signal ain,bin: std_logic_vector(8 downto 0);
  signal areg,breg,sumreg: std_logic_vector(8 downto 0);
  signal cout,reset,enable,load: std_logic;
  signal ysum: std_logic;
begin
  -- processo do FFD
  process(clk) 
  begin
    if (clk'event and clk='1') then
	   if (enable='1') then
		  if (reset='1') then 
		    df<= '0';
		  else
		    df <= cout;
		  end if;
		end if;
	 end if;
  end process;
  ain <= '0' & a;
  bin <= '0' & b;
  -- instancias
  controle: entity work.controller(imp) port map(start,clk,resetn,reset,enable,load);
  apiso: entity work.piso(imp) port map(clk,'0',ain,'0',enable,load,areg);
  bpiso: entity work.piso(imp) port map(clk,'0',bin,'0',enable,load,breg);
  sum_piso: entity work.piso(imp) port map(clk,reset,"000000000",ysum,enable,'0',sumreg);
  somador: entity work.fadder(imp) port map (areg(0),breg(0),df,ysum,cout);
  sum <= sumreg;
end imp;