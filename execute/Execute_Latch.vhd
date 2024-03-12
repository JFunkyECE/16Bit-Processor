library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Execute_Latch is
  Port ( 
    clk : in STD_LOGIC;
    --inputs
    EX_write_enable_IN : in STD_LOGIC;
    EX_select_IN : in STD_LOGIC; 
    EX_NegativeZero_IN : in STD_LOGIC_VECTOR(1 downto 0);
    EX_opcodeIn : in STD_LOGIC_VECTOR(6 downto 0);
    EX_ALU_data_IN : in STD_LOGIC_VECTOR(15 downto 0);
    EX_R_out_address_IN : in STD_LOGIC_VECTOR(2 downto 0); 
    --outputs
    EX_write_enable_OUT : out STD_LOGIC;
    EX_select_OUT :out STD_LOGIC;
    EX_NegativeZero_OUT : out STD_LOGIC_VECTOR(1 downto 0);
    EX_opcodeOut : out STD_LOGIC_VECTOR(6 downto 0);
    EX_R_out_data_OUT : out STD_LOGIC_VECTOR(15 downto 0);
    EX_R_out_address_OUT : out  STD_LOGIC_VECTOR(2 downto 0)  
  );
end Execute_Latch;

architecture Behavioral of Execute_Latch is


begin
    process(clk)
        begin
            if rising_edge(clk) then --Data is always set on the rising edge of the clock
                EX_R_out_data_OUT <= EX_ALU_data_IN;
                EX_write_enable_OUT <= EX_write_enable_IN;
                EX_select_OUT <= EX_select_IN;
                EX_R_out_address_OUT <= EX_R_out_address_IN;
                EX_NegativeZero_OUT <= EX_NegativeZero_IN;
                EX_opcodeOut <= EX_opcodeIn;     
            end if;
    end process;


end Behavioral;
