library ieee;
use ieee.std_logic_1164.all;
use work.mux_input_array.all;

entity tb_mux_gen is

    constant CLOCK_PERIOD : time := 20 ns;
    constant MUX_INPUTS: integer := 2;
    constant MUX_BUS_SIZE: integer := 8;

end entity;

architecture tb of tb_mux_gen is
    signal clk: std_logic := '1';

    signal i: input_array(0 to MUX_INPUTS-1, MUX_BUS_SIZE-1 downto 0) := (others => '0');
    signal sel: integer range 0 to MUX_INPUTS-1 := 0;
    signal y: output_array(MUX_BUS_SIZE-1 downto 0);

begin

    uut:entity work.gen_mux(imp)
        generic map(INPUTS => MUX_INPUTS,
                    BUS_SIZE => MUX_BUS_SIZE)
        port map(i => i, sel => sel, y => y);


    CLOCK: process
    begin
        clk <= not clk wait for CLOCK_PERIOD/2;
    end process;

    TB: process
    begin
        for n in range sel'range loop
            for b in range y'range loop
                for o in std_logic range 0 to 1 loop
                    i(n)(b) <= o;
                    sel <= n;
                    wait for CLOCK_PERIOD;

                    assert y(b) = o
                    report "Output bit " & std_logic'to_image(y(b)) & " diverges from input
                    " & integer'to_image(n) & " which is " & std_logic'to_image(o) 
                    severity failure;
                end loop;
                
                report "Test of bit " & integer'to_image(b) & " from input
                " & integer'to_image(n) & " ok!"

            end loop;
        end loop;
    end process;
end architecture;
