library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY tb_register_file IS
END tb_register_file;

ARCHITECTURE behavior OF tb_register_file IS 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT register_file
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         rd_index1 : IN  std_logic_vector(2 downto 0);
         rd_index2 : IN  std_logic_vector(2 downto 0);
         rd_data1 : OUT  std_logic_vector(15 downto 0);
         rd_data2 : OUT  std_logic_vector(15 downto 0);
         wr_index : IN  std_logic_vector(2 downto 0);
         wr_data : IN  std_logic_vector(15 downto 0);
         wr_enable : IN  std_logic
        );
    END COMPONENT;

    -- Inputs
    signal rst : std_logic := '0';
    signal clk : std_logic := '0';
    signal rd_index1, rd_index2, wr_index : std_logic_vector(2 downto 0) := (others => '0');
    signal wr_data : std_logic_vector(15 downto 0) := (others => '0');
    signal wr_enable : std_logic := '0';

    -- Outputs
    signal rd_data1, rd_data2 : std_logic_vector(15 downto 0);

    -- Clock period definitions
    constant clk_period : time := 20 ns;

BEGIN 
    -- Instantiate the Unit Under Test (UUT)
    uut: register_file PORT MAP (
          rst => rst,
          clk => clk,
          rd_index1 => rd_index1,
          rd_index2 => rd_index2,
          rd_data1 => rd_data1,
          rd_data2 => rd_data2,
          wr_index => wr_index,
          wr_data => wr_data,
          wr_enable => wr_enable
        );

    -- Clock process definitions
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;  -- Clock low
        clk <= '1';
        wait for clk_period/2;  -- Clock high
    end process;

    -- Testbench statements
    stim_proc: process
    begin        
        -- Reset the UUT
        rst <= '1';
        wait for clk_period;  -- Ensure reset is held for at least one clock period
        rst <= '0'; 

        -- Wait for system to stabilize after reset
        wait for clk_period*2;

        --WRITE TO ALL REGISTERS
        -- Write to register 1
        wr_index <= "000";
        wr_data <= x"0001";
        wr_enable <= '1';
        wait for clk_period;  -- Wait for write operation
        wr_enable <= '0';

        -- Write to register 2
        wr_index <= "001";
        wr_data <= x"0002";
        wr_enable <= '1';
        wait for clk_period;  -- Wait for write operation
        wr_enable <= '0';
        
        wr_index <= "010";
        wr_data <= x"0003";
        wr_enable <= '1';
        wait for clk_period;  -- Wait for write operation
        wr_enable <= '0';
        
        wr_index <= "011";
        wr_data <= x"0004";
        wr_enable <= '1';
        wait for clk_period;  -- Wait for write operation
        wr_enable <= '0';
        
        wr_index <= "100";
        wr_data <= x"0005";
        wr_enable <= '1';
        wait for clk_period;  -- Wait for write operation
        wr_enable <= '0';
        
        wr_index <= "101";
        wr_data <= x"0006";
        wr_enable <= '1';
        wait for clk_period;  -- Wait for write operation
        wr_enable <= '0';
        
        wr_index <= "110";
        wr_data <= x"0007";
        wr_enable <= '1';
        wait for clk_period;  -- Wait for write operation
        wr_enable <= '0';
        
        wr_index <= "111";
        wr_data <= x"0008";
        wr_enable <= '1';
        wait for clk_period;  -- Wait for write operation
        wr_enable <= '0';

        -- Reading from registers after writes to ensure data stability
        rd_index1 <= "000";
        wait for clk_period;  -- Wait for read operation
        
        rd_index1 <= "001";
        wait for clk_period;  -- Wait for read operation
        
        rd_index1 <= "010";
        wait for clk_period;  -- Wait for read operation
        
        rd_index1 <= "011";
        wait for clk_period;  -- Wait for read operation
        
        rd_index1 <= "100";
        wait for clk_period;  -- Wait for read operation
        
        rd_index1 <= "101";
        wait for clk_period;  -- Wait for read operation
        
        rd_index1 <= "110";
        wait for clk_period;  -- Wait for read operation
        
        rd_index1 <= "111";
        wait for clk_period;  -- Wait for read operation

        
        

        -- Add additional tests as needed
        
        wait;  -- Hold simulation
    end process;

END behavior;
