library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Execute_Latch is
  Port ( 
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
    R_out_address_OUT : out  STD_LOGIC_VECTOR(2 downto 0)  
  );
end Execute_Latch;

architecture Behavioral of Execute_Latch is


begin
    process(clk)
        begin
            if rising_edge(clk) then --Data is always set on the rising edge of the clock
                R_out_data_OUT <= ALU_data_IN;
                ex_enable_OUT <= ex_enable_IN;
                R_out_address_OUT <= R_out_address_IN;    
            end if;
    end process;


end Behavioral;
