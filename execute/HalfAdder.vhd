library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity HA is
port(
     x,y : in std_logic;
     S,C : out std_logic
  );
end HA;


architecture gateLevel of HA is

begin

	S <= x xor y;
	C <= x and y;

end architecture gateLevel;