-- a) multiplexador genérico, adaptável a qualquer número de entradas 
-- lembre-se que o número de seletores deverá ser definido em razão disso, de um único bit
--
--b) altere sua implementação para que o mux agora permita igualmente que cada entrada 
-- (e consequentemente a saída única) possa representar um barramento de bits
--
--c) proponha um testbench adequado que permita validar o comportamento desse mux 
-- para uma quantidade qualquer de entradas

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity generic_mux is

	generic(
		INPUTS : integer := 2);

	port(
    -- make array of std_logic_vector(channel ou barramento downto 0) e
    -- utilizar mesmo subelemento para y
    
    -- validar com o professor
    -- a parte dificil deve ser o testbench
		i: in std_logic_vector(INPUTS-1 downto 0); 
		sel: in integer range 0 to INPUTS-1;
		y: out std_logic
	);
	
--  assert ((INPUTS mod 2) = 0) report "INPUTS must be power of 2." severity error;    
--  assert (INPUTS > 1) report "INPUTS must be equal or grater than 2." severity error;

end entity;

architecture imp of generic_mux is
begin

    y <= i(sel);

end architecture;