library ieee;
use ieee.std_logic_1164.all;
--use ieee.math_real.all;

package mux_input_array is
    type input_arr is array (natural range <>, natural range <>) of std_logic;
    type output_arr is array (natural range <>) of std_logic;
end package mux_input_array;

use work.mux_input_array.all;

entity gen_mux is
    generic (
        INPUTS : integer := 2;
        BUS_SIZE : integer := 8
    );
                       
    port (
        i: in input_arr(0 to INPUTS-1 ,BUS_SIZE-1 downto 0);
        sel: in integer range 0 to INPUTS-1;
        y: out output_arr(BUS_SIZE-1 downto 0)
    );
    
begin 

    assert BUS_SIZE >= 1
    report "BUS_SIZE must be greater than 0."
    severity failure;

    assert INPUTS > 1
    report "gen_mux INPUTS must be greater than 1."
    severity failure;
    
--    assert 2**integer(ceil(log2(real(INPUTS)))) = INPUTS
--    report "gen_mux INPUTS  must be power of 2."
--    severity failure;

end entity gen_mux;

architecture imp of gen_mux is
begin
    gen: for n_bit in integer range 0 to BUS_SIZE-1 generate
    begin
        y(n_bit) <= i(sel, n_bit);
    end generate;
end architecture;
