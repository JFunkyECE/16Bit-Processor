library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Fetch_Latch is
  Port ( 
      clk : in STD_LOGIC;
      
      --inputs
      Instruction : IN STD_LOGIC_VECTOR(15 downto 0);
      
      --outputs
      F_OpcodeOut : out STD_LOGIC_VECTOR(6 downto 0);
      F_R_in1_address_OUT : out STD_LOGIC_VECTOR(2 downto 0);
      F_R_in2_address_OUT : out STD_LOGIC_VECTOR(2 downto 0);
      F_R_out_address_OUT : out STD_LOGIC_VECTOR(2 downto 0);
      F_shift_OUT : out STD_LOGIC_VECTOR(3 downto 0)
  );
end Fetch_Latch;

architecture Behavioral of Fetch_Latch is


begin
    process(clk)
        begin
            if rising_edge(clk) then --Data is always set on the rising edge of the clock
                F_OpcodeOut <= Instruction(15 downto 9);
                F_R_in1_address_OUT <= Instruction(5 downto 3);
                F_R_in2_address_OUT <= Instruction(2 downto 0);
                F_R_out_address_OUT <= Instruction(8 downto 6);
                F_shift_OUT <= Instruction(3 downto 0);            
            end if;
            end process;


end Behavioral;
