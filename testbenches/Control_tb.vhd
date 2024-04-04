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
    SIGNAL data : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL dataOUT : STD_LOGIC_VECTOR(15 downto 0);   
    SIGNAL read_index1 : STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL read_index2 : STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL data_addr_Out : STD_LOGIC_VECTOR(2 downto 0);  
    SIGNAL wb_select : STD_LOGIC;
    SIGNAL f_pc :  STD_LOGIC_VECTOR(15 downto 0); 
    SIGNAL f_opcode : STD_LOGIC_VECTOR(6 downto 0);
          
    SIGNAL dc_pc : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL dc_displacement : STD_LOGIC_VECTOR(15 downto 0);
          
    SIGNAL ex_branchsel : STD_LOGIC;
    SIGNAL ex_data_out : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL writeback_data : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL writeback_addr : STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL writeback_enable : STD_LOGIC;
    SIGNAL writeback_PC2 : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL   writeback_opcode :  STD_LOGIC_VECTOR(6 downto 0);
    
--    SIGNAL forwardedoutA : STD_LOGIC_VECTOR(15 downto 0);
--    SIGNAL forwardedoutB : STD_LOGIC_VECTOR(15 downto 0);
--    SIGNAL Decode_to_forward_A : STD_LOGIC_VECTOR(15 downto 0);
--    SIGNAL Decode_to_forward_B : STD_LOGIC_VECTOR(15 downto 0);
    COMPONENT Control
    PORT(
      clk : in STD_LOGIC;
      rst : in STD_LOGIC;
    
      --inputs
      INPUT_SIGNAL : in STD_LOGIC_VECTOR(15 downto 0);
    
      --outputs
      data : out STD_LOGIC_VECTOR(15 downto 0);
      ALU_DATA_OUT : out STD_LOGIC_VECTOR(15 downto 0);
      read_data1 : out STD_LOGIC_VECTOR(15 downto 0); --for debug
      read_data2 : out STD_LOGIC_VECTOR(15 downto 0); --for debug
      read_index1 : out STD_LOGIC_VECTOR(2 downto 0); --for debug
      read_index2 : out STD_LOGIC_VECTOR(2 downto 0); --for debug
      data_addr_Out : out STD_LOGIC_VECTOR(2 downto 0); --for debug
      data_Out : out STD_LOGIC_VECTOR(15 downto 0); --For debug
      wb_select : out STD_LOGIC;
    
      f_pc : out STD_LOGIC_VECTOR(15 downto 0); 
      f_opcode : out STD_LOGIC_VECTOR(6 downto 0);
      
      dc_pc : out STD_LOGIC_VECTOR(15 downto 0);
      dc_displacement : out STD_LOGIC_VECTOR(15 downto 0);
      
      ex_branchsel : out STD_LOGIC;
      ex_data_out : out STD_LOGIC_VECTOR(15 downto 0);
      writeback_data : out STD_LOGIC_VECTOR(15 downto 0);
      writeback_addr : out STD_LOGIC_VECTOR(2 downto 0);
      writeback_enable : out STD_LOGIC;
      writeback_PC2 : out STD_LOGIC_VECTOR(15 downto 0);
      writeback_opcode : out STD_LOGIC_VECTOR(6 downto 0)

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
          f_pc => f_pc,
          f_opcode => f_opcode,
          dc_pc => dc_pc,
          dc_displacement => dc_displacement,
          ex_branchsel => ex_branchsel,
          ex_data_out => ex_data_out,
          writeback_data => writeback_data,
          writeback_addr => writeback_addr,
          writeback_enable => writeback_enable,
          writeback_PC2 => writeback_PC2,
          writeback_opcode => writeback_opcode
        );
 
    -- Test process
   stim_proc: PROCESS
   BEGIN       
    -- Initialize Inputs
    wait for clk_period*2; 
    rst <= '0';  -- Release reset
    wait for clk_period;  -- Wait for reset to propagate
 
    INPUT_SIGNAL <= X"0002";
    WAIT; -- Wait forever; the simulation will stop here

    END PROCESS;
END behavior;