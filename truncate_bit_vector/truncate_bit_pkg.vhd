/*
 * Exercicio:
 * 
 * Escreva um subprograma que faça o alinhamento de um endereço
 * com codificação binária natural informado em um parâmetro do
 * tipo bit_vector; o subprograma deve apresentar um segundo
 * parâmetro que indica o padrão de alinhamento - se tiver 
 * valor 1, o endereço não deve ser alterado; se tiver valor 2,
 * o endereço deve ser arredondado para um múltiplo de 2,
 * limpando o bit menos significativo; se tiver valor 4, os dois
 * bits menos significativos devem ser zerados; se tiver valor 8,
 * os três bits menos significativos devem ser zerados. O valor
 * padrão de alinhamento deve ser 4.
 *
 */


package round_bit_pkg is 


function round_bit_vector(constant input: in  bit_vector;
                          constant multiplier: in natural range 1 to 8 := 4)
                          return bit_vector;

end package;

library ieee;
use ieee.numeric_bit.all;

package body round_bit_pkg is

function round_bit_vector(constant input: in  bit_vector;
                          constant multiplier: in natural range 1 to 8 := 4)
                          return bit_vector is
 variable output: unsigned(input'range) := unsigned(input);
begin    
    
        case multiplier is
            when 1 =>
                output := unsigned(input);  
            when 2 =>
                output := unsigned(input(input'high downto 1) & B"0");
            when 4 =>
                output := unsigned(input(input'high downto 2) & B"00");
            when 8 =>
                output := unsigned(input(input'high downto 3) & B"000");
            when others =>
                output := (others => '0');  
        end case;
        
    return bit_vector(output);
            
end function;

end package body;

