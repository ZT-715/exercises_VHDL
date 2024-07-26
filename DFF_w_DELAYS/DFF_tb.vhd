use work.DFF_delays.all;

entity DFF_tb is

end entity;

architecture tb of DFF_tb is

signal rst, clk, d, q : bit;

begin

    clk <= '0', not clk after MAX_CLK_PERIOD/2;

    DUT: entity work.DFF port map(rst => rst,
                                  clk => clk,
                                  d => d,
                                  q => q);

    TEST: process
    begin

        wait until q'event;

        assert now - clk'last_event = SETUP
            report time'image(now) & " - output changes faster than setup time."
            severity failure;

        wait for HOLD;

        assert now - q'last_event = HOLD
            report time'image(now) & " - output changes before hold period end."
            severity failure; 

    end process TEST;

    EXITACION: process
    begin

        rst <= '1', '0' after 10 ns;
        d <= '0', '1' after 20 ns,
                  '0' after 30 ns,
                  '1' after 35 ns,
                  '0' after 38 ns;
        wait;

    end process EXITACION;

end architecture tb;
        

        
    
