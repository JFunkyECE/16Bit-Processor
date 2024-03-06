LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY D_latch_tb IS
END D_latch_tb;

ARCHITECTURE behavior OF D_latch_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT D_latch
    PORT(
         clk : IN  std_logic;
         D : IN  std_logic_vector(15 downto 0);
         D1 : IN  std_logic_vector(15 downto 0);
         Q : OUT  std_logic_vector(15 downto 0);
         Q1 : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
   
   --Inputs
   signal clk : std_logic := '0';
   signal D : std_logic_vector(15 downto 0) := (others => '0');
   signal D1 : std_logic_vector(15 downto 0) := (others => '0');

   --Outputs
   signal Q : std_logic_vector(15 downto 0);
   signal Q1 : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;

BEGIN

   -- Instantiate the Unit Under Test (UUT)
   uut: D_latch PORT MAP (
          clk => clk,
          D => D,
          D1 => D1,
          Q => Q,
          Q1 => Q1
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
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      D <= "0000000000000001";
      D1 <= "0000000000000010";
      wait for clk_period;

      D <= "0000000000000011";
      D1 <= "0000000000000100";
      wait for clk_period;

      D <= "0000000000000101";
      D1 <= "0000000000000110";
      wait for clk_period;

      -- Add more test cases here

      -- Wait for the end of simulation
      wait;
    end process;

END;
