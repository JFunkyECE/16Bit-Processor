library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- For signed arithmetic
use work.AddSubNand.all; -- Include your package


entity ALU is
    port(
        A : in STD_LOGIC_VECTOR(15 downto 0); --always a register value
        B : in STD_LOGIC_VECTOR(15 downto 0); --could be a register value or an immediate
        OpCode : in STD_LOGIC_VECTOR(6 downto 0); --used to determine which operation is occuring
        C : out STD_LOGIC_VECTOR(15 downto 0); --stores output, CHANGE TO 32 bits
        Shift_value : in STD_LOGIC_VECTOR(3 downto 0); --Stores immediate for shifting
        
        --take in output register location and send to next stage after completion
        --Zero and Negative Flag should be added here aswell
        Zero_Negative_flags : out STD_LOGIC_VECTOR(1 downto 0) -- lsb is negative, msb is zero
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
    signal Shift_Result_Left: STD_LOGIC_VECTOR(15 downto 0);
    
    component Right_Shift
        Port (
            Data_in : in STD_LOGIC_VECTOR(15 downto 0);
            Shift_amount : in STD_LOGIC_VECTOR(3 downto 0);
            Data_out : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;
    signal Shift_Result_Right: STD_LOGIC_VECTOR(15 downto 0);

begin

    shift_left_operation: Left_Shift
        port map (
            Data_in => A,
            Shift_amount => Shift_value,
            Data_out => Shift_Result_Left
        );
    shift_right_operation: Right_Shift
        port map (
            Data_in => A,
            Shift_amount => Shift_value,
            Data_out => Shift_Result_Right
        );
        
    -- ALU operation process
    alu_operation: process(A, B, OpCode, Shift_value, Shift_Result_Left, Shift_Result_Right) --any changes to A, B, or Opcode will cause code to execute
    
        variable a_signed, b_signed: signed(15 downto 0); --two input operands
        variable result_signed: signed(15 downto 0);     --output of alu operation
        variable mux_out: STD_LOGIC_VECTOR(15 downto 0); --the output of this is assigned to output register of ALU
    begin
        -- Convert inputs to 'signed' type
        a_signed := signed(A);
        b_signed := signed(B);
        result_signed := (others => '0');
        
        -- Determine operation based on OpCode
        case OpCode is
            when "0000000" =>  -- OpCode = 0 for NOP
                --do nothing here, this is opcode for NOP
                
            when "0000001" =>  -- OpCode = 1 for addition
                result_signed := add1(a_signed, b_signed);
                mux_out := std_logic_vector(result_signed);
                
            when "0000010" =>  -- OpCode for subtraction
                result_signed := subtract1(a_signed, b_signed);
                mux_out := std_logic_vector(result_signed);
            
            --unfinished    
            when "0000011" =>  -- OpCode for multiplication
                result_signed := subtract1(a_signed, b_signed);
                mux_out := std_logic_vector(result_signed);
                
            when "0000100" =>  -- OpCode for NAND
                result_signed := nand1(a_signed, b_signed);
                mux_out := std_logic_vector(result_signed);
            
            when "0000101" =>  -- OpCode for Shifting Left
                mux_out := Shift_Result_Left; 
            
            when "0000110" =>  -- OpCode for shifting Right
                mux_out := Shift_Result_Right; -- Directly take the shift result
            
            when "0000111" =>  -- OpCode for checking Z or N for register A
                if A(15) = '1' then
                    Zero_Negative_flags(0) <= '1';
                else
                    Zero_Negative_flags(0) <= '0';
                end if;
                if A = X"0000" then
                    Zero_Negative_flags(1) <= '1';
                else
                    Zero_Negative_flags(1) <= '0';
                end if;
            when others => 
                mux_out := (others => '0'); -- Default case
         end case;

    -- Map the result to output
    C <= mux_out;
    end process;
end Behavioral;
