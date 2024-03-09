library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY Control_Read_and_Write_tb  IS
END Control_Read_and_Write_tb ;

ARCHITECTURE behavior OF Control_Read_and_Write_tb  IS 

    -- Signal Declarations
    SIGNAL clk : STD_LOGIC := '0';
    constant clk_period : time := 20 ns;

    SIGNAL rst : STD_LOGIC := '1';

    SIGNAL DC_R_data1_IN : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    SIGNAL DC_R_data2_IN : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    SIGNAL DC_R_out_address_IN :  STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    SIGNAL DC_Write_Enable_IN : STD_LOGIC := '0';
    SIGNAL DC_Opcode_IN : STD_LOGIC_VECTOR(6 downto 0) := (others => '0');
    SIGNAL DC_Shift_IN : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');

    SIGNAL rd_index1: STD_LOGIC_VECTOR(2 downto 0) := (others => '0'); 
    SIGNAL rd_index2: STD_LOGIC_VECTOR(2 downto 0) := (others => '0'); 
    SIGNAL rd_data1: STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL rd_data2: STD_LOGIC_VECTOR(15 downto 0);

    COMPONENT Control_Read_and_Write
    PORT(
         clk : IN STD_LOGIC;
         rst : IN STD_LOGIC;
         DC_R_data1_IN : IN STD_LOGIC_VECTOR(15 downto 0);
         DC_R_data2_IN : IN STD_LOGIC_VECTOR(15 downto 0);
         DC_R_out_address_IN : IN STD_LOGIC_VECTOR(2 downto 0);
         DC_Write_Enable_IN : IN STD_LOGIC;
         DC_Opcode_IN : STD_LOGIC_VECTOR(6 downto 0);
         DC_Shift_IN : STD_LOGIC_VECTOR(3 downto 0);
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
          DC_R_data1_IN => DC_R_data1_IN,
          DC_R_data2_IN => DC_R_data2_IN,
          DC_R_out_address_IN => DC_R_out_address_IN,
          DC_Write_Enable_IN => DC_Write_Enable_IN,
          DC_Opcode_IN => DC_Opcode_IN,
          DC_Shift_IN => DC_Shift_IN,
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
        
        
        for i in 0 to 6 loop
            DC_R_data1_IN <= X"1001";
            DC_R_data2_IN <= X"0002";
            DC_R_out_address_IN <= "000";
            DC_Write_Enable_IN <= '1';
            DC_Opcode_IN <= std_logic_vector(to_unsigned(i, DC_Opcode_IN'length));
            DC_Shift_IN <= "1001";
            wait for clk_period;
        end loop;
        
        wait for clk_period;

        wait for clk_period;

        wait for clk_period;



        WAIT; -- Wait forever; the simulation will stop here
    END PROCESS;

END behavior;