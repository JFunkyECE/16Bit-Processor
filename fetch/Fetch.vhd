library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Fetch is
  Port ( 
    clk : IN std_logic;
    reset : IN std_logic;
    PC : IN std_logic_vector(15 downto 0); --read from program counter register
    PC_Updated : OUT std_logic_vector(15 downto 0); --holds updated PC value after incrementing by 2 or getting branch instruction
    
    Data_OUT_ROM : IN std_logic_vector(15 downto 0); 
    Data_OUT_RAM : IN std_logic_vector(15 downto 0);
    Instruction_Register : OUT std_logic_vector(15 downto 0);
    
    PC_STALL : IN STD_LOGIC; --Stalls the program counter
    
    --new signals for branch
    branch_select : IN std_logic;
    branch_PC : IN std_logic_vector(15 downto 0)
        
  );

end Fetch;

architecture Behavioral of Fetch is
begin
  process (branch_select, branch_PC, reset, PC, Data_OUT_RAM, Data_OUT_ROM, PC_STALL) -- Updated process sensitivity list to include reset
  begin
    if reset = '1' then
      -- Initialize outputs to 0 on reset
      PC_Updated <= (others => '0');
      Instruction_Register <= (others => '0');
    elsif PC_STALL = '0' then
        if branch_select = '0' then 
          -- Update logic based on clock signal
          PC_Updated <= std_logic_vector(unsigned(PC) + to_unsigned(2, 16));
        else
          PC_Updated <= branch_PC;
        end if;
    elsif PC_STALL = '1' then
        PC_Updated <= PC;
    end if;
    
    if reset = '0' and PC(15 downto 10) = "000000" then
        Instruction_Register <= Data_OUT_ROM;
    elsif reset = '0' then
        Instruction_Register <= Data_OUT_RAM;
    end if;
    
  end process;
end Behavioral;
