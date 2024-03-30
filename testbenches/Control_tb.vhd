library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

 
ENTITY Control_tb  IS

END Control_tb ;

 
ARCHITECTURE behavior OF Control_tb  IS
 
    -- Signal Declarations
    SIGNAL clk : STD_LOGIC := '0';
    constant clk_period : time := 10 ns;
 
    SIGNAL rst : STD_LOGIC := '1'; 
    
    SIGNAL Instruction : STD_LOGIC_VECTOR(15 downto 0) := X"0000";
    SIGNAL INPUT_SIGNAL : STD_LOGIC_VECTOR(15 downto 0) := X"0000";   
    SIGNAL read_data1 : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL read_data2 : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL dataOUT : STD_LOGIC_VECTOR(15 downto 0);   
    SIGNAL read_index1 : STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL read_index2 : STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL data_addr_Out : STD_LOGIC_VECTOR(2 downto 0);  
    SIGNAL wb_select : STD_LOGIC;
    COMPONENT Control
    PORT(
         clk : IN STD_LOGIC;
         rst : IN STD_LOGIC;
         Instruction : IN STD_LOGIC_VECTOR(15 downto 0);
         INPUT_SIGNAL : IN STD_LOGIC_VECTOR(15 downto 0);
         read_data1 : out STD_LOGIC_VECTOR(15 downto 0);
         read_data2 : out STD_LOGIC_VECTOR(15 downto 0);
         read_index1 : out STD_LOGIC_VECTOR(2 downto 0);
         read_index2 : out STD_LOGIC_VECTOR(2 downto 0);
         data_addr_Out : out STD_LOGIC_VECTOR(2 downto 0);
         data_Out : out STD_LOGIC_VECTOR(15 downto 0);
         wb_select : out STD_LOGIC
        );
    END COMPONENT;

BEGIN
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process; 

    -- Instantiate the Unit Under Test (UUT)
   uut: Control PORT MAP (
          clk => clk,
          rst => rst,
          Instruction => Instruction,
          INPUT_SIGNAL => INPUT_SIGNAL,
          read_data1 => read_data1,
          read_data2 => read_data2,
          read_index1 => read_index1,
          read_index2 => read_index2,
          data_addr_Out => data_addr_Out,
          data_Out =>dataOUT,
          wb_select => wb_select
        );
 
    -- Test process
   stim_proc: PROCESS
   BEGIN       
    -- Initialize Inputs
    wait for clk_period*2; 
    rst <= '0';  -- Release reset
    wait for clk_period;  -- Wait for reset to propagate
 
    -- Store 1 in register 0
    INPUT_SIGNAL <= X"0001"; -- Immediate value to store
    Instruction <= "0100001000000000"; -- Store operation for register 0
    wait for clk_period; -- Wait for the operation to complete

    -- Store 1 in register 1
    Instruction <= "0100001001000000"; -- Store operation for register 1
    wait for clk_period; -- Wait for the operation to complete
    
    Instruction <= "0000000000000000"; -- NoOp
    wait for clk_period*3; -- Wait for the operation to complete
  
    
    -- Add register 0 and register 1, store result in register 2
    Instruction <= "0000001010000001"; -- Add registers 0 and 1
    wait for clk_period; -- Wait for the operation to complete
    
   -- Add result in register 2 with register 0, store back in register 3
    Instruction <= "0000001011000010"; -- Add registers 2 and 0
    wait for clk_period; -- Wait for the operation to complete
    
     -- multiply result in register 2 with register 2, store back in register 4
     Instruction <= "0000011100010010"; -- Add registers 2 and 0
     wait for clk_period; -- Wait for the operation to complete
    
--     Instruction <= "0000000010000000"; -- NoOp
--     wait for clk_period; -- Wait for the operation to complete
     
--     Instruction <= "0000000011000000"; -- NoOp
--     wait for clk_period; -- Wait for the operation to complete


--    Instruction <= "0000001110101000"; -- Assuming an add immediate operation for register

--    wait for clk_period; -- Wait for the operation to complete

    WAIT; -- Wait forever; the simulation will stop here

    END PROCESS;
END behavior;