/* 
 * De acordo com a tarefa selecionada, proponha um modelo VHDL e um
 * testbench adequado para o problema indicado (o testbench deve ser
 * capaz de verificar as condições de temporização indicadas):
 *
 * Tarefa B: proponha um modelo comportamental para um flip-flop
 * tipo D sensível a borda de descida, com as seguintes restrições
 * temporais de operação: setup de 3ns, hold de 2ns e largura
 * mínima do pulso de clock de 5ns.
 *
 */
 
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
begin

    DFF: process
    variable result : std_logic := '0';
    begin
       
        if (rst = '1') then
            q <= '0';
        elsif (falling_edge(clk)) then 
            q <= d; 
            
            if (d'last_event < SETUP) then
                q <= 'U';
            end if;
            
            wait until d'event for HOLD;
            
            if (d /= q) then
                q <= 'U';
            end if;
            
        end if;
        
            
    end process DFF;
    
    ASSERTS: process
    begin
    if (falling_edge(clk) and rst /= '1') then
            
            assert clk'last_event >= MIN_CLK_PULSE/2
                report "Clock frequency above maximum threshold."
                severity ERROR;
    
            -- Sinal deve ser estável por SETUP antes de falling_edge
            -- e NÃO pode oscilar por HOLD depois do falling_edge.
            assert d'last_event >= SETUP
                report "SETUP time not respected."
                severity ERROR;
                
            wait for HOLD;
            
            assert d'last_event >= HOLD + SETUP
                report "HOLD time not respected."
                severity ERROR;
            
    end if;
    end process ASSERTS;
    
end architecture;



    