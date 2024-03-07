
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity WB_latch is
  Port ( 
  clk : in STD_LOGIC;
  
  --inputs
  R_out_data_IN : in STD_LOGIC_VECTOR(15 downto 0);
  R_out_address_IN : in STD_LOGIC_VECTOR(2 downto 0);
  WB_Enable_IN : in STD_LOGIC;
  --outputs
  R_out_data_OUT : out STD_LOGIC_VECTOR(15 downto 0);
  R_out_address_OUT : out STD_LOGIC_VECTOR(2 downto 0);
  WB_Enable_OUT : out STD_LOGIC);
  
end WB_latch;

architecture Behavioral of WB_latch is

begin
    process(clk)
    begin
        if rising_edge(clk) then --Data is always set on the rising edge of the clock
            R_out_data_OUT <= R_out_data_IN;
            R_out_address_OUT <= R_out_address_IN;
            WB_Enable_OUT <= WB_Enable_IN;            
        end if;
        end process;


end Behavioral;
