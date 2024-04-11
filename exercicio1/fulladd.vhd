library ieee;
use ieee.std_logic_1164.all;

entity fadder is
  port(
    a,b,cin: in std_logic;
	 y,cout: out std_logic
  );
end fadder;

architecture imp of fadder is
begin
  y <= a xor b xor cin;
  cout <= (a and b) or (a and cin) or (b and cin);
end imp;