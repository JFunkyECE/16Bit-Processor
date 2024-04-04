library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- For signed arithmetic
use work.AddSubNand.all; -- Include your package



entity ALU is
    port(
        --clk : in STD_LOGIC;
        A : in STD_LOGIC_VECTOR(15 downto 0); --always a register value
        B : in STD_LOGIC_VECTOR(15 downto 0); --could be a register value or an immediate
        OpCode : in STD_LOGIC_VECTOR(6 downto 0); --used to determine which operation is occuring
        Shift_value : in STD_LOGIC_VECTOR(3 downto 0); --Stores immediate for shifting
        C : out STD_LOGIC_VECTOR(15 downto 0); --stores output, CHANGE TO 32 bits

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

    component Wallace_16x16_Multiplier
        Port (
            A : in STD_LOGIC_VECTOR(15 downto 0);
            B : in STD_LOGIC_VECTOR(15 downto 0);
            prod : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
    signal wallace_prod: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
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

     Multiplier_Instance : Wallace_16x16_Multiplier port map(
        A => A,
        B => B,
        prod => wallace_prod
    );
       
    -- ALU operation process
    alu_operation: process(A, B, OpCode, Shift_value, Shift_Result_Left, Shift_Result_Right, wallace_prod) --any changes to A, B, or Opcode will cause code to execute
   
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
                  
                when "0000011" =>  -- OpCode for multiplication
                    mux_out := std_logic_vector(wallace_prod(15 downto 0));
                   
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
                when "1000000" =>  -- OpCode = 64 for branch
                    result_signed := add1(a_signed, b_signed);
                    mux_out := std_logic_vector(result_signed);
                when "1000001" =>  -- OpCode = 65 for branch
                    result_signed := add1(a_signed, b_signed);
                    mux_out := std_logic_vector(result_signed);
                when "1000010" =>  -- OpCode = 66 for branch
                    result_signed := add1(a_signed, b_signed);
                    mux_out := std_logic_vector(result_signed);
                when "1000011" =>  -- OpCode = 67 for branch
                    result_signed := add1(a_signed, b_signed);
                    mux_out := std_logic_vector(result_signed);
                when "1000100" =>  -- OpCode = 68 for branch
                    result_signed := add1(a_signed, b_signed);
                    mux_out := std_logic_vector(result_signed);
                when "1000101" =>  -- OpCode = 69 for branch
                    result_signed := add1(a_signed, b_signed);
                    mux_out := std_logic_vector(result_signed);
                when "1000110" =>  -- OpCode = 70 for subroutine branch
                    result_signed := add1(a_signed, b_signed);
                    mux_out := std_logic_vector(result_signed);    
                when others =>
                    mux_out := (others => '0'); -- Default case
             end case;
    
             -- Map the result to output
             C <= mux_out;
    end process;
end Behavioral;