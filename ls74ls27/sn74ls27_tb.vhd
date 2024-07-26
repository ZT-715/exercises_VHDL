-- Testa sn74ls27 para todas as possíveis entradas
-- contabilizando delay Tplh e Tphl ambos de 15 ns.

library work;
use work.sn74ls27_delays.all;
use work.threewaynor_test.all;

entity sn74ls27_tb is
end entity;

architecture tb of sn74ls27_tb is
signal a, b, c, y: bit_vector(2 downto 0);
begin

DUV: entity work.sn74ls27 
        port map(a1 => a(0),
                 a2 => a(1),
                 a3 => a(2),
                 b1 => b(0),
                 b2 => b(1),
                 b3 => b(2),
                 c1 => c(0),
                 c2 => c(1),
                 c3 => c(2),
                 y1 => y(0),
                 y2 => y(1),
                 y3 => y(2));
                 
                 
test_3_way_nor(a(0), b(0), c(0), y(0), TPLH, TPHL, string'("C:\Users\gabri\OneDrive\Documentos\VHDL_exercises\ls74ls27\test1.txt"));
test_3_way_nor(a(1), b(1), c(1), y(1), TPLH, TPHL, string'("C:\Users\gabri\OneDrive\Documentos\VHDL_exercises\ls74ls27\test2.txt"));
test_3_way_nor(a(2), b(2), c(2), y(2), TPLH, TPHL, string'("C:\Users\gabri\OneDrive\Documentos\VHDL_exercises\ls74ls27\test3.txt"));

                 
end architecture;
                
            
            