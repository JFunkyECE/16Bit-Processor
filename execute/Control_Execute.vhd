library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_Execute is
  Port ( 
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
end Control_Execute;

architecture Behavioral of Control_Execute is

component Execute_Latch
    port (
        clk : in STD_LOGIC;
        
        --inputs
        EX_enable_IN : in STD_LOGIC;
        NegativeZero_IN : in STD_LOGIC_VECTOR(1 downto 0);
        opcodeIn : in STD_LOGIC_VECTOR(6 downto 0);
        ALU_data_IN : in STD_LOGIC_VECTOR(15 downto 0);
        R_out_address_IN : in STD_LOGIC_VECTOR(2 downto 0);
        --outputs
        ex_enable_OUT : out STD_LOGIC;
        opcodeOut : out STD_LOGIC_VECTOR(6 downto 0);
        R_out_data_OUT : out STD_LOGIC_VECTOR(15 downto 0);
        R_out_address_OUT : out STD_LOGIC_VECTOR(2 downto 0)
    );
end component;

component ALU
    port(
        A : in STD_LOGIC_VECTOR(15 downto 0); --always a register value
        B : in STD_LOGIC_VECTOR(15 downto 0); --could be a register value or an immediate
        OpCode : in STD_LOGIC_VECTOR(6 downto 0); --used to determine which operation is occuring
        Shift_value : in STD_LOGIC_VECTOR(3 downto 0); --Stores immediate for shifting
        C : out STD_LOGIC_VECTOR(15 downto 0); --stores output, CHANGE TO 32 bits
        
        --take in output register location and send to next stage after completion
        --Zero and Negative Flag should be added here aswell
        Zero_Negative_flags : out STD_LOGIC_VECTOR(1 downto 0) -- lsb is negative, msb is zero
    );
end component;

signal NegativeZero_OUT : STD_LOGIC_VECTOR(1 downto 0);
signal opcodeOut : STD_LOGIC_VECTOR(6 downto 0);
signal Negative_Zero_OUT : STD_LOGIC_VECTOR(1 downto 0);
signal R_outaddress_OUT : STD_LOGIC_VECTOR(2 downto 0);
signal EX_ALU_OP : STD_LOGIC_VECTOR(15 downto 0);
signal R_outdata_OUT : STD_LOGIC_VECTOR(15 downto 0);
signal EX_enable_OUT : STD_LOGIC;

begin

ALU_INST : ALU port map(
    R_in1_data_IN,
    R_in2_data_IN,
    opcode_IN,
    shift_IN,
    EX_ALU_OP,
    Negative_Zero_OUT
);

Control_Latch_INST : Execute_Latch port map(
    clk => clk,
    EX_enable_IN => EX_ENABLE_IN,
    opcodeIn => opCode_IN,
    R_out_address_IN => R_out_address_IN,
    ALU_data_IN => EX_ALU_OP,
    NegativeZero_IN => Negative_Zero_OUT,
    ex_enable_OUT => EX_enable_OUT,
    opcodeOut => opcodeOut,
    R_out_address_OUT =>R_outaddress_OUT,
    R_out_data_OUT =>R_outdata_OUT
);

ALU_OP <= EX_ALU_OP;


end Behavioral;
