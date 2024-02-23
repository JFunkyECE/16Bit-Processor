----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/19/2024 12:25:23 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- For signed arithmetic
use work.AddSub.all; -- Include your package


entity ALU is
    port(
        A : in STD_LOGIC_VECTOR(15 downto 0);
        B : in STD_LOGIC_VECTOR(15 downto 0);
        OpCode : in STD_LOGIC_VECTOR(6 downto 0);
        C : out STD_LOGIC_VECTOR(15 downto 0);
        Shift : in STD_LOGIC_VECTOR(3 downto 0)
    );
end ALU;

architecture Behavioral of ALU is
    
    component Left_Shift
        Port (
            Data_in : in STD_LOGIC_VECTOR(15 downto 0);
            Shift_amount : in STD_LOGIC_VECTOR(3 downto 0);
            Data_out : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;
    signal Shift_Result: STD_LOGIC_VECTOR(15 downto 0);

begin

    shift_operation: Left_Shift
        port map (
            Data_in => A,
            Shift_amount => Shift,
            Data_out => Shift_Result
        );
        
    -- ALU operation process
    alu_operation: process(A, B, OpCode, Shift) --any changes to A, B, or Opcode will cause code to execute
        variable a_signed, b_signed: signed(15 downto 0);
        variable result_signed: signed(15 downto 0);
        variable mux_out: STD_LOGIC_VECTOR(15 downto 0);
    begin
        -- Convert inputs to 'signed' type
        a_signed := signed(A);
        b_signed := signed(B);
        result_signed := (others => '0');
        
        -- Determine operation based on OpCode
        case OpCode is
            when "0000001" =>  -- OpCode for addition
                result_signed := add1(a_signed, b_signed);
                mux_out := std_logic_vector(result_signed);
            when "0000010" =>  -- OpCode for subtraction
                result_signed := subtract1(a_signed, b_signed);
                mux_out := std_logic_vector(result_signed);
            when "0000101" =>  -- OpCode for shifting
                mux_out := Shift_Result; -- Directly take the shift result
            when others => 
                mux_out := (others => '0'); -- Default case
         end case;

    -- Map the result to output
    C <= mux_out;
    end process;
end Behavioral;
