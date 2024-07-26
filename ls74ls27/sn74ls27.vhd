-- Considere o problema de modelagem completa de um circuito lógico,
-- conforme os parâmetros das portas da família 74LS. 

-- A partir disso, proponha, conforme o problema indicado abaixo,
-- um modelo VHDL completo para a porta lógica indicada (consulte 
-- o datasheet a fim de determinar os atrasos necessários), com
-- destaque aos atrasos inerciais e de rejeição, bem como um testbench
-- que seja capaz de avaliar os atrasos em questão exibindo inclusive 
-- eventuais situações onde mudanças dos valores das entradas não 
-- serão refletidas nas saídas.

-- Considere que as portas lógicas devem rejeitar qualquer alteração
-- nas entradas com duração inferior ao menor atraso de propagação observado. 

library work;
use work.sn74ls27_delays.all;

entity sn74ls27 is

port(
    a1, a2, a3, b1, b2, b3, c1, c2, c3: in bit;
    y1, y2, y3: out bit);

end entity;

architecture behaviour of sn74ls27 is
    
    signal y : bit_vector(2 downto 0);
    signal a : bit_vector(2 downto 0);
    signal b : bit_vector(2 downto 0);
    signal c : bit_vector(2 downto 0);
    
begin

    y1 <= y(0);
    y2 <= y(1);
    y3 <= y(2);
    
    a(0) <= a1;
    a(1) <= a2;
    a(2) <= a3;
    
    b(0) <= b1;
    b(1) <= b2;
    b(2) <= b3;
   
    c(0) <= c1; 
    c(1) <= c2;
    c(2) <= c3; 
 
    specification: process(a,b,c)
        variable result: bit;
    begin
        for i in natural range 0 to 2 loop
            result := not(a(i) or (b(i) or c(i)));
            
            -- Tplh 15 ns max
            if result = '1' then
                y(i) <= inertial '1' after TPLH;
            -- Tphl 15 ns max
            else -- result = '0' then
                y(i) <= inertial '0' after TPHL; 
            end if;
        end loop;          
    end process;
  

end architecture;