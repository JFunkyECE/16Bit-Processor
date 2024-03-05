LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Left_Shift_TB IS
END Left_Shift_TB;

ARCHITECTURE behavior OF Left_Shift_TB IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT Left_Shift
    PORT(
        Data_in : IN  std_logic_vector(15 downto 0);
        Shift_amount : IN  std_logic_vector(3 downto 0);
        Data_out : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
   
    --Inputs
    signal Data_in : std_logic_vector(15 downto 0) := (others => '0');
    signal Shift_amount : std_logic_vector(3 downto 0) := (others => '0');

    --Outputs
    signal Data_out : std_logic_vector(15 downto 0);

BEGIN 

    -- Instantiate the Unit Under Test (UUT)
    uut: Left_Shift PORT MAP (
          Data_in => Data_in,
          Shift_amount => Shift_amount,
          Data_out => Data_out
        );

    -- Stimulus process
    stim_proc: process
    begin       
        -- Apply Inputs
        Data_in <= x"0001"; -- Example input data
        Shift_amount <= "0001"; -- Shift by 1 bit
        wait for 100 ns;        
        
        Data_in <= x"0002"; -- Another example input data
        Shift_amount <= "0010"; -- Shift by 2 bits
        wait for 100 ns;

        Data_in <= x"0004"; -- Another example input data
        Shift_amount <= "0100"; -- Shift by 4 bits
        wait for 100 ns;

        Data_in <= x"0008"; -- Another example input data
        Shift_amount <= "1000"; -- Shift by 8 bits
        wait for 100 ns;

        -- Add more test cases as needed

        wait; -- will wait forever
    end process;

END;

