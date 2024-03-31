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
    
    SIGNAL INPUT_SIGNAL : STD_LOGIC_VECTOR(15 downto 0) := X"0000";   
    SIGNAL read_data1 : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL read_data2 : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL ALU_DATA_OUT : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL PC : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL data : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL dataOUT : STD_LOGIC_VECTOR(15 downto 0);   
    SIGNAL read_index1 : STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL read_index2 : STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL data_addr_Out : STD_LOGIC_VECTOR(2 downto 0);  
    SIGNAL wb_select : STD_LOGIC;
    
    SIGNAL forwardedoutA : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL forwardedoutB : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL Decode_to_forward_A : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL Decode_to_forward_B : STD_LOGIC_VECTOR(15 downto 0);
    COMPONENT Control
    PORT(
         clk : IN STD_LOGIC;
         rst : IN STD_LOGIC;
         INPUT_SIGNAL : IN STD_LOGIC_VECTOR(15 downto 0);
         PC : out STD_LOGIC_VECTOR(15 downto 0);
         data : out STD_LOGIC_VECTOR(15 downto 0);
         ALU_DATA_OUT : out STD_LOGIC_VECTOR(15 downto 0);
         read_data1 : out STD_LOGIC_VECTOR(15 downto 0);
         read_data2 : out STD_LOGIC_VECTOR(15 downto 0);
         read_index1 : out STD_LOGIC_VECTOR(2 downto 0);
         read_index2 : out STD_LOGIC_VECTOR(2 downto 0);
         data_addr_Out : out STD_LOGIC_VECTOR(2 downto 0);
         data_Out : out STD_LOGIC_VECTOR(15 downto 0);
         wb_select : out STD_LOGIC;
         forwardedoutA : out STD_LOGIC_VECTOR(15 downto 0);
         forwardedoutB : out STD_LOGIC_VECTOR(15 downto 0);
         Decode_to_forward_A : out STD_LOGIC_VECTOR(15 downto 0);
         Decode_to_forward_B : out STD_LOGIC_VECTOR(15 downto 0)
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
          PC => PC,
          data => data,
          ALU_DATA_OUT => ALU_DATA_OUT,
          INPUT_SIGNAL => INPUT_SIGNAL,
          read_data1 => read_data1,
          read_data2 => read_data2,
          read_index1 => read_index1,
          read_index2 => read_index2,
          data_addr_Out => data_addr_Out,
          data_Out =>dataOUT,
          wb_select => wb_select,
          forwardedoutA => forwardedoutA,
          forwardedoutB => forwardedoutB,
          Decode_to_forward_A => Decode_to_forward_A,
          Decode_to_forward_B => Decode_to_forward_B
        );
 
    -- Test process
   stim_proc: PROCESS
   BEGIN       
    -- Initialize Inputs
    wait for clk_period*2; 
    rst <= '0';  -- Release reset
    wait for clk_period;  -- Wait for reset to propagate
 
    INPUT_SIGNAL <= X"0001";

    WAIT; -- Wait forever; the simulation will stop here

    END PROCESS;
END behavior;