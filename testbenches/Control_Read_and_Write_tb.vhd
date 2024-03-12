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

    SIGNAL Instruction : STD_LOGIC_VECTOR(15 downto 0) := X"0000";
    SIGNAL INPUT_SIGNAL : STD_LOGIC_VECTOR(15 downto 0) := X"0000";
    
    SIGNAL read_data1 : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL read_data2 : STD_LOGIC_VECTOR(15 downto 0);
    
    COMPONENT Control_Read_and_Write
    PORT(
         clk : IN STD_LOGIC;
         rst : IN STD_LOGIC;
         Instruction : IN STD_LOGIC_VECTOR(15 downto 0);
         INPUT_SIGNAL : IN STD_LOGIC_VECTOR(15 downto 0);
         read_data1 : out STD_LOGIC_VECTOR(15 downto 0);
         read_data2 : out STD_LOGIC_VECTOR(15 downto 0)
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
          Instruction => Instruction,
          INPUT_SIGNAL => INPUT_SIGNAL,
          read_data1 => read_data1,
          read_data2 => read_data2
        );

    -- Test process
    stim_proc: PROCESS
    BEGIN        
        -- Initialize Inputs
        wait for clk_period*2;  
        rst <= '0';  -- Release reset
        -- Add stimulus here
        
--        for i in 0 to 6 loop
--            DC_R_data1_IN <= X"1001";
--            DC_R_data2_IN <= X"0002";
--            DC_R_out_address_IN <= "000";
--            DC_Write_Enable_IN <= '1';
--            DC_Opcode_IN <= std_logic_vector(to_unsigned(i, DC_Opcode_IN'length));
--            DC_Shift_IN <= "1001";
--            wait for clk_period;
--        end loop;
        INPUT_SIGNAL <= X"0001";
        Instruction <= "0100001000000000";
        wait for clk_period;
        Instruction <= "0000000000000000";
        wait for clk_period;
--        INPUT_SIGNAL <= X"0002";
--        Instruction <= "0100001001000000";
--        wait for clk_period;
--        Instruction <= X"0000";
--        wait for clk_period * 3;
--        Instruction <= "0000001010000001";
--        wait for clk_period;

        WAIT; -- Wait forever; the simulation will stop here
    END PROCESS;

END behavior;