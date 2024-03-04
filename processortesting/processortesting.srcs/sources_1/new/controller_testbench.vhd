LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Controller_tb IS
END Controller_tb;

ARCHITECTURE behavior OF Controller_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT Controller
    PORT(
        reset : IN std_logic;
        rst: IN std_logic;
        clk : IN std_logic;
        rd_index_1 : IN std_logic_vector(2 downto 0);
        rd_index_2 : IN std_logic_vector(2 downto 0);
        rd_data_1 : OUT std_logic_vector(15 downto 0);
        rd_data_2 : OUT std_logic_vector(15 downto 0);
        --wr_index : IN std_logic_vector(2 downto 0);
        --wr_data : INOUT std_logic_vector(15 downto 0);
        --wr_enable_1 : INOUT std_logic;
        inport_sig : IN std_logic_vector(15 downto 0);
        instruction : IN std_logic_vector(15 downto 0);
        zero_negative : OUT std_logic_vector(1 downto 0)
    );
    END COMPONENT;

   --Inputs
   signal rst : std_logic := '0';
   signal reset : std_logic := '0';
   signal clk : std_logic := '0';
   --signal wr_index : std_logic_vector(2 downto 0) := (others => '0');
   --signal wr_data : std_logic_vector(15 downto 0) := (others => '0');
  -- signal wr_enable_1 : std_logic := '0';
   signal inport_sig : std_logic_vector(15 downto 0) := (others => '0');
   signal instruction : std_logic_vector(15 downto 0) := (others => '0');
    
   --Outputs
   signal rd_data_1 : std_logic_vector(15 downto 0);
   signal rd_data_2 : std_logic_vector(15 downto 0);
   signal zero_negative : std_logic_vector(1 downto 0);
   constant clk_period : time := 20 ns;
   
   signal rd_index_1 : std_logic_vector(2 downto 0) := (others => '0');
   signal rd_index_2 : std_logic_vector(2 downto 0) := (others => '0');
   
   
BEGIN

    -- Instantiate the Unit Under Test (UUT)
   uut: Controller PORT MAP (
          reset => reset,
          rst => rst,
          clk => clk,
          rd_index_1 => rd_index_1,
          rd_index_2 => rd_index_2,
          rd_data_1 => rd_data_1,
          rd_data_2 => rd_data_2,
         -- wr_index => wr_index,
         -- wr_data => wr_data,
         -- wr_enable_1 => wr_enable_1,
          inport_sig => inport_sig,
          instruction => instruction,
          zero_negative => zero_negative
        );

   -- Clock process definitions
   clk_process :process
   begin
        clk <= '0';
        wait for clk_period/2; -- Slow clock period
        clk <= '1';
        wait for clk_period/2;
   end process;

   -- Test process
   stim_proc: process
   begin        
        -- Reset registers
        rd_index_1 <= "001";
        rd_index_2 <= "010";
        
        rst <= '1';
        wait for clk_period *3;
        rst <= '0';
--        wait for clk_period *2;
--        -- Reset FSM
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        
        
        inport_sig <= X"0003";
        instruction <= "0100001001000000";
        wait for clk_period * 9;
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        inport_sig <= X"0005";
        instruction <= "0100001010000000";


        wait;
   end process;

END;