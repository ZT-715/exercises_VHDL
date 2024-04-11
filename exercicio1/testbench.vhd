library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity testbench is

-- Use "run 14417920 ns" para completar simulação
constant CLK_PERIOD: time := 20 ns;

-- clocks de descida
constant SUM_DELAY: time := 10*CLK_PERIOD;
subtype INPUT_RANGE is integer range 0 to 255;
   
end entity;

architecture imp of testbench is
signal start, clk, rst: std_logic := '0';
signal a, b: std_logic_vector(7 downto 0) := "00000000";
signal saida: std_logic_vector(8 downto 0);

begin
uut: entity work.serialadd(imp) port map (a, b, start, rst, clk, saida);

CLK_TOGGLE:process
begin
    wait for CLK_PERIOD/2;
    clk <= not clk;
end process;

TESTS:process
variable result: integer;
begin

    report "Inicio dos testes:";    
    
    for i in INPUT_RANGE loop
        for j in INPUT_RANGE loop

            wait for CLK_PERIOD;
  
            report "sum(a,b): " & integer'image(i) 
            & " + " & integer'image(j) & ":";
            
            a <= conv_std_logic_vector(i,a'length);
            b <= conv_std_logic_vector(j,b'length);        
        
            start <= '1';
            rst <= '1';
            
            wait for SUM_DELAY;
            
            result := conv_integer(unsigned(saida));
            
            report "= " & integer'image(result);
            assert (i+j) = result severity failure;
                                
            start <= '0';
            
         end loop;
    end loop;
    
    report "End sim.";
    wait;
end process;
end architecture;

