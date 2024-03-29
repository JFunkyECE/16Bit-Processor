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
        Shift : in STD_LOGIC_VECTOR(3 downto 0) --Stores immediate for shifting
        
        --take in output register location and send to next stage after completion
        --Zero and Negative Flag should be added here aswell
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
                
            --testing   
            when "0000100" =>  -- OpCode for NAND
                result_signed := nand1(a_signed, b_signed);
                mux_out := std_logic_vector(result_signed);
            
            --unfinished    
            --when "0000101" =>  -- OpCode for Shifting Left
             
            
            --unfinished      
            when "0000110" =>  -- OpCode for shifting Right
                mux_out := Shift_Result; -- Directly take the shift result
            
            --unfinished
            --when "0000111" =>  -- OpCode for checking Z or N
                
               
            
            when others => 
                mux_out := (others => '0'); -- Default case
         end case;

    -- Map the result to output
    C <= mux_out;
    end process;
end Behavioral;
