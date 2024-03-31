library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Fetch is
  Port ( 
    clk : IN std_logic;
    reset : IN std_logic;
    PC : IN std_logic_vector(15 downto 0); --read from program counter register
    PC_Updated : OUT std_logic_vector(15 downto 0); --holds updated PC value after incrementing by 2 or getting branch instruction
    
    Data_OUT : IN std_logic_vector(15 downto 0); -- holds data thats filled into fetch latch
    
    Instruction_Register : OUT std_logic_vector(15 downto 0)
    -- Need to add signal for reading branch enable that will select new value for PC_OUT once branching is implemented
    -- Need to add RAM functionality once ROM is working well enough
    
  );

end Fetch;

architecture Behavioral of Fetch is
begin
  process (PC, reset) -- Updated process sensitivity list to include reset
  begin
    if reset = '1' then
      -- Initialize outputs to 0 on reset
      PC_Updated <= (others => '0');
      Instruction_Register <= (others => '0');
    else 
      -- Update logic based on clock signal
      Instruction_Register <= Data_OUT;
      PC_Updated <= std_logic_vector(unsigned(PC) + to_unsigned(2, 16));
    end if;
  end process;
end Behavioral;
