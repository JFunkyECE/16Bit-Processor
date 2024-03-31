
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Program_Counter is
  Port ( 
   
  clk : IN std_logic;   
  reset : IN std_logic;
  PC_IN : IN std_logic_vector(15 downto 0);
  PC_OUT : OUT std_logic_vector(15 downto 0)
  
  );
end Program_Counter;

architecture Behavioral of Program_Counter is
begin
    process(clk, reset) -- Include reset in the sensitivity list
    begin
        if reset = '1' then
            PC_OUT <= (others => '0'); -- Initialize PC_OUT to 0 on reset
        elsif falling_edge(clk) then
            PC_OUT <= PC_IN; -- Update PC_OUT on the falling edge of clk
        end if;
    end process;
end Behavioral;
