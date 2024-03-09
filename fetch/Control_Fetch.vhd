library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_Fetch is
  Port ( 
    clk : in STD_LOGIC;
    opcodeINSTRUCTION : in STD_LOGIC_VECTOR(6 downto 0);
    R_in1_address_INSTRUCTION : in STD_LOGIC_VECTOR(15 downto 0);
    R_in2_address_INSTRUCTION : in STD_LOGIC_VECTOR(15 downto 0);
    R_out_address_INSTRUCTION : in STD_LOGIC_VECTOR(2 downto 0);
    shift_INSTRUCTION : in STD_LOGIC_VECTOR(3 downto 0)
  );
end Control_Fetch;

architecture Behavioral of Control_Fetch is

component Fetch_Latch
    port(
      clk : in STD_LOGIC;
      
      --inputs
      OpcodeIn : in STD_LOGIC_VECTOR(6 downto 0);
      R_in1_address_IN : in STD_LOGIC_VECTOR(15 downto 0);
      R_in2_address_IN : in STD_LOGIC_VECTOR(15 downto 0);
      R_out_address_IN : in STD_LOGIC_VECTOR(2 downto 0);
      shift_IN : in STD_LOGIC_VECTOR(3 downto 0);
      
      --outputs
      OpcodeOUT : out STD_LOGIC_VECTOR(6 downto 0);
      R_in1_address_OUT : out STD_LOGIC_VECTOR(15 downto 0);
      R_in2_address_OUT : out STD_LOGIC_VECTOR(15 downto 0);
      R_out_address_OUT : out STD_LOGIC_VECTOR(2 downto 0);
      shift_OUT : out STD_LOGIC_VECTOR(3 downto 0)
    );
end component;

signal OpcodeOUT : STD_LOGIC_VECTOR(6 downto 0);
signal R_in1_address_OUT : STD_LOGIC_VECTOR(15 downto 0);
signal R_in2_address_OUT : STD_LOGIC_VECTOR(15 downto 0);
signal R_out_address_OUT : STD_LOGIC_VECTOR(2 downto 0);
signal shift_OUT : STD_LOGIC_VECTOR(3 downto 0);


begin

Fetch_Latch_Inst : Fetch_Latch port map(
    clk=>clk, 
    opcodeIn=>opcodeINSTRUCTION, 
    R_in1_address_IN=>R_in1_address_INSTRUCTION,
    R_in2_address_IN=>R_in2_address_INSTRUCTION,
    R_out_address_IN=>R_out_address_INSTRUCTION,
    shift_IN=>shift_INSTRUCTION,OpcodeOUT=>OpcodeOUT,
    R_in1_address_OUT=>R_in1_address_OUT,
    R_in2_address_OUT=>R_in2_address_OUT,
    R_out_address_OUT=>R_out_address_OUT,
    shift_OUT=>shift_OUT
);

end Behavioral;
