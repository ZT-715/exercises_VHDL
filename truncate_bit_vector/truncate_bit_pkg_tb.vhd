library ieee;
use ieee.numeric_bit.all;
use std.textio.all;
use work.round_bit_pkg.all;

entity round_bit_pkg_tb is
    
end entity;

architecture tb of round_bit_pkg_tb is

type test_values is record
    input: bit_vector(8 downto 0);
    multiplier: integer range 0 to 8;
    output: bit_vector(8 downto 0);
end record;

type test_vector is array (natural range <>) of test_values;

constant VALUES: test_vector(3 downto 0) := ((B"101_101_101", 1, B"101_101_101"),
                                            (B"101_101_111", 2, B"101_101_110"),
                                            (B"101_101_101", 4, B"101_101_100"),
                                            (B"101_101_101", 8, B"101_101_000"));

                                            
 file fout: text open write_mode is "C:\Users\gabri\OneDrive\Documentos\VHDL_exercises\truncate_bit_vector\bit_out.txt"; 
                                       
 begin

TEST: process
 variable line_buffer: line;

variable output: bit_vector(8 downto 0);

begin

for i in VALUES'range loop
   
    write(line_buffer, string'("Test ") &
                integer'image(VALUES(i).multiplier));
    writeline(fout, line_buffer);
    
    output := round_bit_vector(VALUES(i).input, VALUES(i).multiplier);
    
    write(line_buffer, string'("IN | OUT"));
    writeline(fout, line_buffer);

    
    for n in VALUES(i).input'range loop
        write(line_buffer, bit'image(VALUES(i).input(n)) &
        string'("| ") & bit'image(output(n)));
        
        writeline(fout, line_buffer);

    end loop;
    
    for n in VALUES(i).input'range loop
        assert VALUES(i).output(n) = output(n)
        report "Error in bit " & integer'image(n)
        severity failure;    
    end loop;
    
    wait for 20 ns;

end loop;

report "Success!";
wait;
end process;

end architecture;
