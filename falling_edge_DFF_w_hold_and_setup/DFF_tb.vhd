library ieee;
use ieee.std_logic_1164.all;
use work.DFF_delays.all;

entity DFF_tb is
end entity;

architecture tb of DFF_tb is

signal rst, clk, d, q : std_logic;

begin
    -- Tempo de simulação é 3.5 períodos de clock - 17.5 ns
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
    
        for i in integer range 0 to 2 loop
            clk <= '0';
            wait for MIN_CLK_PULSE/2;
            clk <= '1';
            wait for MIN_CLK_PULSE/2;
        end loop;
    
    report "Teste de clock acima da frequencia máxima (DEVE apresentar erro): "
    severity note;
    
        clk <= '0';
        wait for MIN_CLK_PULSE/4;
        clk <= '1';
        wait for MIN_CLK_PULSE/4;
        
        wait;
    end process CLOCK;

    EXITACION: process
    begin
    
    d <= '1';
    
    wait until clk'event and clk = '0';
        
        report "Variação de entrada D no limite do DFF (não deve apresentar erros): "
        severity note;
    
        -- Mudança após HOLD
        d <= '0' after HOLD; 
        
        -- Mudança logo no último instante antes de SETUP
        d <= '1' after MIN_CLK_PULSE - SETUP; 
    
    wait until clk'event and clk = '0';
    
        report "Variação de entrada D acima do limite do DFF (DEVE apresentrar erros: "
        severity note;
    
        d <= '0' after HOLD*0.5;
        
        d <= '1' after MIN_CLK_PULSE - SETUP*0.5;
   
    wait until clk'event and clk = '0';
    
        report "Fim do teste de exitações."
        severity note;

    wait;
    
    end process EXITACION;

end architecture tb;
        

        
    
