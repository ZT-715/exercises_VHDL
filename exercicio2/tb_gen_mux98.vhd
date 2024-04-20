library ieee;
use ieee.std_logic_1164.all;
use work.mux_input_array.all;

-- 54700ns to run given all std_logic values are tested

entity tb_mux_gen is

    constant CLOCK_PERIOD : time := 20 ns;
    constant MUX_INPUTS: integer := 2;
    constant MUX_BUS_SIZE: integer := 8;

end entity;

architecture tb of tb_mux_gen is
    signal clk: std_logic := '1';

    signal i: input_arr(0 to MUX_INPUTS-1, MUX_BUS_SIZE-1 downto 0) :=
    (others => (others => '0'));
    signal sel: integer range 0 to MUX_INPUTS-1 := 0;
    signal y: output_arr(MUX_BUS_SIZE-1 downto 0);

begin
    uut:entity work.gen_mux(imp)
        generic map(INPUTS => MUX_INPUTS,
                    BUS_SIZE => MUX_BUS_SIZE)
        port map(i => i, sel => sel, y => y);

    clk <= not clk after CLOCK_PERIOD/2;

    TB: process
        variable out_bit, inp_bit: integer range 0 to 1 := 0;
    begin
        for n in integer range 0 to MUX_INPUTS-1 loop
            for b in integer range 0 to MUX_BUS_SIZE-1 loop
                for o in std_logic loop

                    i(n, b) <= o;
                    sel <= n;

                    wait for CLOCK_PERIOD;

                    if(o = '0') then 
                        inp_bit := 0;
                    else inp_bit := 1;
                    end if;

                    if(y(b) = '0') then
                        out_bit := 0;
                    else out_bit := 1;
                    end if;

                    assert y(b) = o
                    report "Output bit " & integer'image(out_bit) & " diverges from input "
                    & integer'image(n) & " which is " & integer'image(inp_bit)
                    severity failure;
                end loop;
                
                report "Test of bit " & integer'image(b) & " from input " & integer'image(n) & " ok!";

            end loop;
        end loop;
        report "Success! All bits working.";
        wait;
    end process;
end architecture;
