library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- This file calculates the word aligned displacement
-- for displacement L and S depending on the instructions
-- opcode.

entity Displacement_Calculation is
  Port ( 
        rst : in std_logic;
        Displacement_L : in std_logic_vector(8 downto 0);
        Displacement_S : in std_logic_vector(5 downto 0);
        Opcode : in std_logic_vector(6 downto 0);
        Displacement_Final : out std_logic_vector(15 downto 0)
  );
end Displacement_Calculation;

architecture Behavioral of Displacement_Calculation is

begin

    process(Displacement_L, Displacement_S, Opcode)
    begin
        if rst = '1' then
            Displacement_Final <= X"0000";
        elsif Opcode = "1000000" or Opcode = "1000001" or Opcode = "1000010" then
            --displacement l
            Displacement_Final <= std_logic_vector(resize(signed(Displacement_L) * to_signed(2, 9), 16));
        elsif Opcode = "1000011" or Opcode = "1000100" or Opcode = "1000101" or Opcode = "1000110" then
            --displacement s
            Displacement_Final <= std_logic_vector(resize(signed(Displacement_L) * to_signed(2, 6), 16));
        else
            Displacement_Final <= X"0000";
        end if;
    
    end process;

end Behavioral;
