LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_Wallace_16x16_Multiplier IS
END tb_Wallace_16x16_Multiplier;

ARCHITECTURE behavior OF tb_Wallace_16x16_Multiplier IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT Wallace_16x16_Multiplier
    PORT(
         A : IN  std_logic_vector(15 downto 0);
         B : IN  std_logic_vector(15 downto 0);
         prod : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
   
    --Inputs
    signal A_tb : std_logic_vector(15 downto 0) := (others => '0');
    signal B_tb : std_logic_vector(15 downto 0) := (others => '0');

    --Outputs
    signal prod_tb : std_logic_vector(31 downto 0);

BEGIN 

    -- Instantiate the Unit Under Test (UUT)
   uut: Wallace_16x16_Multiplier PORT MAP (
          A => A_tb,
          B => B_tb,
          prod => prod_tb
        );

    -- Stimulus process
    stim_proc: process
    begin       
        -- Initialize Inputs
        A_tb <= "1111111111111111"; 
        B_tb <= "1111111111111111"; 
        wait for 100 ns;

        A_tb <= "0000111111111101"; 
        B_tb <= "0000111111111101"; 
        wait for 100 ns;

        -- Add more test cases as needed

        -- Wait for the simulation to finish
        wait;
    end process;

END;