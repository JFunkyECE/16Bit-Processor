library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_tb is
    -- Testbench doesn't have ports
end entity ALU_tb;

architecture sim of ALU_tb is
    -- Signal declarations
    signal A, B, C : STD_LOGIC_VECTOR(15 downto 0);
    signal OpCode : STD_LOGIC_VECTOR(6 downto 0);
    signal Shift_value : STD_LOGIC_VECTOR(3 downto 0); 
    -- Instantiate the Unit Under Test (UUT)
    begin
        uut: entity work.ALU
        port map (
            A => A,
            B => B,
            OpCode => OpCode,
            C => C,
            Shift_value => Shift_value
        );

        -- Test process
        process
        begin
            -- Test 1: Add 5 + 4
            A <= std_logic_vector(to_signed(5, 16));
            B <= std_logic_vector(to_signed(4, 16)); 
            OpCode <= "0000001"; 
            wait for 10 ns; 

            -- Test 2: subtract 2 - 2
            A <= std_logic_vector(to_signed(2, 16)); 
            B <= std_logic_vector(to_signed(2, 16)); 
            OpCode <= "0000010";
            wait for 10 ns; 
            
            -- Test 3: add 10 + 340
            A <= std_logic_vector(to_signed(10, 16)); 
            B <= std_logic_vector(to_signed(340, 16)); 
            OpCode <= "0000001";
            wait for 10 ns; 
            -- Test 4: add 10 + -340
            A <= std_logic_vector(to_signed(10, 16)); 
            B <= std_logic_vector(to_signed(-340, 16)); 
            OpCode <= "0000001";
            wait for 10 ns; 
            
            --LEFT SHIFTING TESTS
            
            A <= X"0001"; -- Example value
            B <= X"0000";
            Shift_value <= "0001"; -- Shift by 1 positions
            OpCode <= "0000101"; -- Assuming this is the opcode for shift
            wait for 10 ns;
            
            A <= X"0008"; -- Example value
            B <= X"0000";
            Shift_value <= "1000"; -- Shift by 1 positions
            OpCode <= "0000101"; -- Assuming this is the opcode for shift
            wait for 10 ns;
            
            A <= X"0008"; -- Example value
            B <= X"0000";
            Shift_value <= "0000"; -- Shift by 1 positions
            OpCode <= "0000101"; -- Assuming this is the opcode for shift
            wait for 10 ns;
            
            --RIGHT SHIFTING TESTS
            A <= X"0008"; -- Example value
            B <= X"0000";
            Shift_value <= "0001"; -- Shift by 1 positions
            OpCode <= "0000110"; -- Assuming this is the opcode for shift
            wait for 10 ns;
            
            A <= X"0006"; -- Example value
            B <= X"0000";
            Shift_value <= "0001"; -- Shift by 1 positions
            OpCode <= "0000110"; -- Assuming this is the opcode for shift
            wait for 10 ns;
            
            --NAND TESTS
--            -- Test 6: NAND should output 7
            A <= X"FFFF"; -- Example value
            B <= X"FFF8"; 
            OpCode <= "0000100";
            wait for 10 ns; 
            
            
            
            
            wait; -- Hold simulation here indefinitely
        end process;
end architecture sim;
