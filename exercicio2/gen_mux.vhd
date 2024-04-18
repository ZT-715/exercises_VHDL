library ieee;
use ieee.std_logic_1164.all;

package mux_input_array is
--    type input_arr is array (natural range 0 to 1) of std_logic_vector(7 downto 0);
    type input_arr is array (natural range <>) of std_logic_vector;
end package mux_input_array;

use work.mux_input_array.all;

entity gen_mux is
    generic (
        INPUTS : integer := 2;
        BUS_SIZE : integer := 8
    );
                       
    port (
        i: in input_arr(0 to INPUTS-1)(BUS_SIZE-1 downto 0);
        sel: in integer range 0 to INPUTS-1;
        y: out std_logic_vector(BUS_SIZE-1 downto 0)
    );
end entity gen_mux;

architecture imp of gen_mux is
begin
    gen: for n_bit in BUS_SIZE'range generate
    begin
        y(n_bit) <= i(sel)(n_bit);
    end generate;
end architecture;
