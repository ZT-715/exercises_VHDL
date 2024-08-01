--  
--  De acordo com a tarefa selecionada, proponha um modelo VHDL e um
--  testbench adequado para o problema indicado (o testbench deve ser
--  capaz de verificar as condições de temporização indicadas):
-- 
--  Tarefa B: proponha um modelo comportamental para um flip-flop
--  tipo D sensível a borda de descida, com as seguintes restrições
--  temporais de operação: setup de 3ns, hold de 2ns e largura
--  mínima do pulso de clock de 5ns.
-- 
-- 
 
package DFF_delays is
    constant SETUP: time := 3 ns;
    constant HOLD: time  := 2 ns;
    constant MIN_CLK_PULSE : time := 5 ns;
end package DFF_delays;

library ieee;
use ieee.std_logic_1164.all;
use work.DFF_delays.all;

entity DFF is
 
    generic(SETUP: time := SETUP;
            HOLD: time  := HOLD;
            MIN_CLK_PULSE: time := MIN_CLK_PULSE);

    port(clk, rst, d : in std_logic;
         q : out std_logic);

end entity;

architecture falling_edge_DFF_w_hold_and_setup of DFF is
    signal hold_on: bit := '0';
    signal clock_check: bit := '1';
begin
   
    DFF: process(rst, clk, d)
    variable last_clock_event: time := 0 ns;
    begin
        if (rst = '1') then
            q <= '1';
        else

            if (falling_edge(clk)) then 
                q <= d; 
                
                if (d'last_event < SETUP) then
                    report "Input last_event " & time'image(d'last_event) & " < SETUP time.";
                    q <= 'U';
                end if;
                
                if ((now - last_clock_event) < MIN_CLK_PULSE) then
                    report "Clock above maximum frequency.";
                    q <= 'U';
                end if;
                
                last_clock_event := now;
            --- end if;
            
            elsif (d'event and hold_on = '1') then
                report "Input event " & time'image(now) & " on HOLD time.";
                q <= 'U';
            end if;

        end if;

        
    end process DFF;

    HOLDING: process
    begin
    wait until clk'event and clk = '0';    
        
        hold_on <= '1', '0' after HOLD;
       
    wait for 0 ns;
    end process HOLDING; 

end architecture;



    