-----------------------------------------------------------
--
-- ECE441/ECE543
--
-- Heirarchical design of a full adder
--
-- (c)2022 Dr. D. Capson    Dept. of ECE
--                          University of Victoria
--
-----------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity FullAdder is
  port (
        X,Y,Cin:  in std_logic;
        SUM,Cout: out std_logic
    );
end FullAdder;
      
        
architecture structural of FullAdder is

-- intermediate signals (refer to logic circuit for FA)
signal p1,p2,p3 : std_logic;

component HA is
    port (
          x : in STD_LOGIC;
          y : in STD_LOGIC;
          s : out STD_LOGIC;
          c : out STD_LOGIC
      );
end component;
begin
    
--  instantiate two HAs

  HA0: HA port map(x => X, y => Y, s => p1, c => p2);
  HA1: HA port map(x => p1, y => Cin, s => SUM, c => p3);

  Cout <= p2 or p3;
   
end architecture structural;