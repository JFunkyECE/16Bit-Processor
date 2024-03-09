library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY Control_Read_and_Write_tb  IS
END Control_Read_and_Write_tb ;

ARCHITECTURE behavior OF Control_Read_and_Write_tb  IS 

    -- Signal Declarations
    SIGNAL clk : STD_LOGIC := '0';
    constant clk_period : time := 20 ns;

    SIGNAL rst : STD_LOGIC := '1';

    SIGNAL EX_write_enable_IN : STD_LOGIC := '0';
    SIGNAL EX_NegativeZero_IN : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
    SIGNAL EX_opcodeIn : STD_LOGIC_VECTOR(6 downto 0) := (others => '0');
    SIGNAL EX_ALU_data_IN : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    SIGNAL EX_R_out_address_IN : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');

    SIGNAL rd_index1: STD_LOGIC_VECTOR(2 downto 0) := (others => '0'); 
    SIGNAL rd_index2: STD_LOGIC_VECTOR(2 downto 0) := (others => '0'); 
    SIGNAL rd_data1: STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL rd_data2: STD_LOGIC_VECTOR(15 downto 0);

    COMPONENT Control_Read_and_Write
    PORT(
         clk : IN STD_LOGIC;
         rst : IN STD_LOGIC;
         EX_write_enable_IN : IN STD_LOGIC;
         EX_NegativeZero_IN : IN STD_LOGIC_VECTOR(1 downto 0);
         EX_opcodeIn : IN STD_LOGIC_VECTOR(6 downto 0);
         EX_ALU_data_IN : IN STD_LOGIC_VECTOR(15 downto 0);
         EX_R_out_address_IN : IN STD_LOGIC_VECTOR(2 downto 0);
         rd_index1 : IN STD_LOGIC_VECTOR(2 downto 0); 
         rd_index2 : IN STD_LOGIC_VECTOR(2 downto 0); 
         rd_data1 : OUT STD_LOGIC_VECTOR(15 downto 0); 
         rd_data2 : OUT STD_LOGIC_VECTOR(15 downto 0)
        );
    END COMPONENT;
    --
BEGIN
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;


    -- Instantiate the Unit Under Test (UUT)
   uut: Control_Read_and_Write PORT MAP (
          clk => clk,
          rst => rst,
          EX_write_enable_IN => EX_write_enable_IN,
          EX_NegativeZero_IN => EX_NegativeZero_IN,
          EX_opcodeIn => EX_opcodeIn,
          EX_ALU_data_IN => EX_ALU_data_IN,
          EX_R_out_address_IN => EX_R_out_address_IN,
          rd_index1 => rd_index1,
          rd_index2 => rd_index2,
          rd_data1 => rd_data1,
          rd_data2 => rd_data2
        );

    -- Test process
    stim_proc: PROCESS
    BEGIN        
        -- Initialize Inputs
        wait for clk_period*2;  
        rst <= '0';  -- Release reset
        -- Add stimulus here
        rd_index1 <= "000";
        rd_index2 <= "001";
        
        EX_write_enable_IN <= '1';
        EX_NegativeZero_IN <= "00";
        EX_opcodeIn <= "0000000";
        EX_ALU_data_IN <= X"8008"; 
        EX_R_out_address_IN <= "000";
        wait for clk_period;
        EX_ALU_data_IN <= X"1010"; 
        EX_R_out_address_IN <= "001";
        wait for clk_period;
        EX_ALU_data_IN <= X"1111"; 
        EX_R_out_address_IN <= "000";
        wait for clk_period;
        EX_ALU_data_IN <= X"9999"; 
        EX_R_out_address_IN <= "001";
        wait for clk_period;
        EX_write_enable_IN <= '0';


        WAIT; -- Wait forever; the simulation will stop here
    END PROCESS;

END behavior;