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
    constant MAX_CLK_PERIOD : time := 5 ns;
end package DFF_delays;

use work.DFF_delays.all;

entity DFF is
 
    generic(SETUP: time := SETUP;
            HOLD: time  := HOLD);

    port(clk, rst, d : in bit;
         q : out bit);
     
end entity;


architecture falling_edge_imp of DFF is
begin

    FF: process(clk, rst)
    begin
        if (rst = '1') then
        q <= '0';
        elsif (falling_edge(clk)) then 
            -- reject signals that change faster than 
            -- the required setup and hold time.

            -- signal is set after 3 ns, but it must not
            -- oscilate in a 5 ns period before the 
            -- transaction is completed.
            q <= reject MAX_CLK_PERIOD inertial d after SETUP;
        end if;
    end process;

end architecture;



    