library ieee;
use ieee.std_logic_1164.all;
use work.DFF_delays.all;

entity DFF_tb is
end entity;

architecture tb of DFF_tb is

signal rst, clk, d, q: std_logic;

begin
    -- Tempo de simulação é de 55 ns 
    -- checagem feita por padrão de onda
    DUT: entity work.DFF port map(rst => rst,
                                  clk => clk,
                                  d => d,
                                  q => q);
    
    
    rst <= '1', '0' after MIN_CLK_PULSE/2;
    
    -- Gera 3 pulsos de clock que respeitam a frequencia máxima da entidade
    -- depois gera um pulso de clock com o dobro da frequencia máxima.
    CLOCK: process
    begin
    report "Inicio dos testes com DFF:"
    severity note;
    
        for i in integer range 0 to 4 loop
            clk <= '0';
            wait for MIN_CLK_PULSE;
            clk <= '1';
            wait for MIN_CLK_PULSE;
        end loop;
    
    report "Teste de clock acima da frequencia máxima: "
    severity note;
    
        for i in integer range 0 to 2 loop
            clk <= '0';
            wait for MIN_CLK_PULSE/4;
            clk <= '1';
            wait for MIN_CLK_PULSE/4;
        end loop;

        wait;
    end process CLOCK;

    EXITATE: process
    begin

        -- Atribuição inicial em 0 ns
        d <= '1';
        wait for 0 ns;


        -- Mudança logo no último instante antes de SETUP
        wait for (2*MIN_CLK_PULSE - SETUP);
            d <= '0'; 

            report "Variação de entrada D no limite do DFF: "
            severity note;

        -- Mudança após HOLD
        wait for (SETUP + HOLD);
            d <= '1';         

        -- Mudança de sinal em tempos de setup
        wait for (2*MIN_CLK_PULSE - HOLD + 2*MIN_CLK_PULSE - SETUP*0.5);      
            d <= '0';
            
            report "Variação de entrada D acima do limite do DFF: "
            severity note; 

        -- Mudança de sinal em tempos de hold     
        wait for (2*MIN_CLK_PULSE + SETUP*0.5 + HOLD*0.5);
            d <= '1';

            report "Fim do teste de exitações."
            severity note;

        wait; -- Fim       
    end process EXITATE;

end architecture tb;
        

        
    
