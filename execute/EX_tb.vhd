library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EX_tb is
end EX_tb;

architecture Behavioral of EX_tb is
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT Control_Execute
    PORT(
     clk : in STD_LOGIC;
    
    --Inputs from Decode Stage
    EX_ENABLE_IN : in STD_LOGIC;
    opcode_IN : in STD_LOGIC_VECTOR(6 downto 0);
    R_in1_DATA_IN : in STD_LOGIC_VECTOR(15 downto 0);
    R_in2_DATA_IN : in STD_LOGIC_VECTOR(15 downto 0);
    R_out_address_IN : in STD_LOGIC_VECTOR(2 downto 0);
    shift_IN : in STD_LOGIC_VECTOR(3 downto 0);
    --outputs
    ALU_OP : out STD_LOGIC_VECTOR(15 downto 0);
    ZeroNegative : out STD_LOGIC_VECTOR(1 downto 0)
    );
    END COMPONENT;
   
   --Inputs
   signal clk : std_logic := '0';
   signal EX_ENABLE_IN : std_logic := '0';
   signal opCode_IN : std_logic_vector(6 downto 0) := (others => '0');
   signal R_in1_DATA_IN : std_logic_vector(15 downto 0) := (others => '0');
   signal R_in2_DATA_IN : std_logic_vector(15 downto 0) := (others => '0');
   signal R_out_address_IN : std_logic_vector(2 downto 0) := (others => '0');
   signal shift_IN : std_logic_vector(3 downto 0) := (others => '0');
   signal NegativeZero_IN : std_logic_vector(1 downto 0) := (others => '0'); 
   
   --outputs
   signal ALU : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
   
   

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut: Control_Execute PORT MAP (
        clk => clk,
        EX_ENABLE_IN => EX_ENABLE_IN,
        opcode_IN => opCode_IN,
        R_in1_DATA_IN => R_in1_DATA_IN,
        R_in2_DATA_IN => R_in2_DATA_IN,
        R_out_address_IN => R_out_address_IN,
        shift_IN => shift_IN,
        ALU_OP=>ALU
    );


    -- Clock process definitions
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
   
    -- Stimulus process
    stim_proc: process
    begin
        -- Initial reset state
        wait for 100 ns; 

      -- Test Case 1: Opcode 0000000
    EX_ENABLE_IN <= '1';
    opCode_IN <= "0000000"; -- Example opcode
    R_in1_DATA_IN <= "0000000000000001";
    R_in2_DATA_IN <= "0000000000000010";
    R_out_address_IN <= "011";
    shift_IN <= "0000";
    wait for 50 ns; -- Wait time to observe behavior

    -- Test Case 2: Opcode 0000001
    opCode_IN <= "0000001"; -- Another example opcode
    R_in1_DATA_IN <= "0000000000010001";
    R_in2_DATA_IN <= "0000000000010010";
    R_out_address_IN <= "011";
    shift_IN <= "0000";
    wait for 50 ns; -- Wait time to observe behavior

    -- Test Case 3: Opcode 0000010
    opCode_IN <= "0000010"; -- Another example opcode
    R_in1_DATA_IN <= "0000000000100001";
    R_in2_DATA_IN <= "0000000000100010";
    R_out_address_IN <= "011";
    shift_IN <= "0000";
    wait for 50 ns; -- Wait time to observe behavior
    
    -- Test Case 4: Opcode 0000011
    opCode_IN <= "0000011"; -- Another example opcode
    R_in1_DATA_IN <= "0000000000100001";
    R_in2_DATA_IN <= "0000000000100010";
    R_out_address_IN <= "011";
    shift_IN <= "0000";
    wait for 50 ns; -- Wait time to observe behavior
    
        -- Test Case 5: Opcode 0000100
    opCode_IN <= "0000100"; -- Another example opcode
    R_in1_DATA_IN <= "0000000000100001";
    R_in2_DATA_IN <= "0000000000100010";
    R_out_address_IN <= "011";
    shift_IN <= "0000";
    wait for 50 ns; -- Wait time to observe behavior
    
            -- Test Case 6: Opcode 0000101
    opCode_IN <= "0000101"; -- Another example opcode
    R_in1_DATA_IN <= "0000000000100001";
    R_in2_DATA_IN <= "0000000000100010";
    R_out_address_IN <= "011";
    shift_IN <= "0110";
    wait for 50 ns; -- Wait time to observe behavior
    
    -- Test Case 7: Opcode 0000110
    opCode_IN <= "0000110"; -- Another example opcode
    R_in1_DATA_IN <= "0000000000100001";
    R_in2_DATA_IN <= "0000000000100010";
    R_out_address_IN <= "011";
    shift_IN <= "0110";
    wait for 50 ns; -- Wait time to observe behavior
    
    -- Test Case 8: Opcode 0000111
    opCode_IN <= "0000111"; -- Another example opcode
    R_in1_DATA_IN <= "0000000000100001";
    R_in2_DATA_IN <= "0000000000100010";
    R_out_address_IN <= "011";
    shift_IN <= "0000";
    wait for 50 ns; -- Wait time to observe behavior

        wait;
    end process;

end Behavioral;
