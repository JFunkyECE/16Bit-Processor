library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Fetch_Latch is
  Port ( 
      clk : in STD_LOGIC;
      
      --inputs
      OpcodeIn : in STD_LOGIC_VECTOR(6 downto 0);
      R_in1_address_IN : in STD_LOGIC_VECTOR(15 downto 0);
      R_in2_address_IN : in STD_LOGIC_VECTOR(15 downto 0);
      R_out_address_IN : in STD_LOGIC_VECTOR(2 downto 0);
      shift_IN : in STD_LOGIC_VECTOR(3 downto 0);
      
      --outputs
      OpcodeOut : out STD_LOGIC_VECTOR(6 downto 0);
      R_in1_address_OUT : out STD_LOGIC_VECTOR(15 downto 0);
      R_in2_address_OUT : out STD_LOGIC_VECTOR(15 downto 0);
      R_out_address_OUT : out STD_LOGIC_VECTOR(2 downto 0);
      shift_OUT : out STD_LOGIC_VECTOR(3 downto 0)
  );
end Fetch_Latch;

architecture Behavioral of Fetch_Latch is


begin
    process(clk)
        begin
            if rising_edge(clk) then --Data is always set on the rising edge of the clock
               OpcodeOut <= OpcodeIn;
                R_in1_address_OUT <= R_in1_address_IN;
                R_in2_address_OUT <= R_in2_address_IN;
                R_out_address_OUT <= R_out_address_IN;
                shift_OUT <= shift_IN;            
            end if;
            end process;


end Behavioral;
