library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity controller is 
  port(
    start: in std_logic;
	 clk: in std_logic;
	 resetn: in std_logic;
	 reset: out std_logic;
	 enable: out std_logic;
	 load: out std_logic
  );
end controller;

architecture imp of controller is
  signal mload: std_logic;
  type tstate is (WAIT_STATE,WORK_STATE,END_STATE); 
  attribute enum_encoding: string;
  attribute enum_encoding of tstate: type is "00 01 11";
  signal atual,futuro: tstate;
  signal counter: std_logic_vector(3 downto 0);
begin
  -- processo do clock
  process(clk,resetn)
  begin
    if (resetn='0') then
	   atual <= WAIT_STATE;
		counter <= (others => '0');
	 elsif (clk'event and clk='1') then
	   atual <= futuro;
		if (atual = WAIT_STATE) then
		  counter <= "0000";
		elsif (atual = WORK_STATE) then
		  counter <= counter+1;
		end if;
	 end if;
  end process;
  -- logica do controlador
  process(atual,start,counter)
  begin
    futuro <= atual;
    case(atual) is
	   when WAIT_STATE =>
		  if (start='1') then 
		    futuro <= WORK_STATE;
		  end if;
		when WORK_STATE =>
		  if (counter="1000") then
		    futuro <= END_STATE;
		  end if;
		when others => -- END_STATE
		  if (start='0') then
		    futuro <= WAIT_STATE;
		  end if;
	 end case;
  end process;
  -- logica de saida
  reset <= '1' when (atual=WAIT_STATE) and (start='1') else '0';
  mload <= '1' when (atual=WAIT_STATE) and (start='1') else '0';
  enable <= '1' when (mload='1') or (atual=WORK_STATE) else '0';
  load <= mload;
end imp;