LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- USE ieee.std_logic_arith.ALL; -- These two libraries are deprecated
-- USE ieee.std_logic_unsigned.ALL;

ENTITY WB_tb IS
END WB_tb;

ARCHITECTURE behavior OF WB_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT Control_Read_and_Write
    PORT(
          clk : in STD_LOGIC;
          rst : in STD_LOGIC;
        
          --inputs
          R_out_data_IN : in STD_LOGIC_VECTOR(15 downto 0);
          R_out_address_IN : in STD_LOGIC_VECTOR(2 downto 0);
          WB_Enable_IN : in STD_LOGIC;

          --register file
          rd_index1: in std_logic_vector(2 downto 0); 
          rd_index2: in std_logic_vector(2 downto 0); 
          rd_data1: out std_logic_vector(15 downto 0); 
          rd_data2: out std_logic_vector(15 downto 0)
         );
    END COMPONENT;
   
   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal R_out_data_IN : std_logic_vector(15 downto 0) := (others => '0');
   signal R_out_address_IN : std_logic_vector(2 downto 0) := (others => '0');
   signal WB_Enable_IN : STD_LOGIC := '0'; -- Corrected here


   signal rd_index1 : std_logic_vector(2 downto 0) := (others => '0');
   signal rd_index2 : std_logic_vector(2 downto 0) := "001";
   signal rd_data1 : std_logic_vector(15 downto 0);
   signal rd_data2 : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 1 ns;

BEGIN
   -- Instantiate the Unit Under Test (UUT)
   uut: Control_Read_and_Write PORT MAP (
          clk => clk,
          rst => rst,
        
          --inputs
          R_out_data_IN => R_out_data_IN,
          R_out_address_IN => R_out_address_IN,
          WB_Enable_IN => WB_Enable_IN,
          --register file
          rd_index1 => rd_index1,
          rd_index2 => rd_index2,
          rd_data1 => rd_data1,
          rd_data2 => rd_data2
        );

   -- Clock process definitions
   clk_process :process
   begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin        

      -- Initialize inputs and apply test stimulus here
      rst <= '1'; -- Reset the system initially
      wait for clk_period * 2; -- Wait for a clock period after reset
      rst <= '0';
      R_out_data_IN <= X"0001";
      R_out_address_IN <= "000";
      WB_Enable_IN <= '1'; -- Corrected signal name
      wait for clk_period;
      R_out_data_IN <= X"0002";
      R_out_address_IN <= "000";
      WB_Enable_IN <= '1'; -- Corrected signal name
      wait for clk_period;
      R_out_data_IN <= X"0003";
      R_out_address_IN <= "000";
      WB_Enable_IN <= '1'; -- Corrected signal name
      wait for clk_period;
      R_out_data_IN <= X"0004";
      R_out_address_IN <= "000";
      WB_Enable_IN <= '1'; -- Corrected signal name
      wait for clk_period;
      R_out_data_IN <= X"0005";
      R_out_address_IN <= "000";
      WB_Enable_IN <= '1'; -- Corrected signal name
      wait for clk_period;
     
      -- Additional stimulus as per your design's requirement

      -- Wait for the end of simulation
      wait;
    end process;
END behavior;