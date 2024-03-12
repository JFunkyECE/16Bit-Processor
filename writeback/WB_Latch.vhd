
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Writeback_latch is
  Port ( 
  clk : in STD_LOGIC;
  
  --inputs
  WB_R_out_data_IN : in STD_LOGIC_VECTOR(15 downto 0);
  WB_R_out_address_IN : in STD_LOGIC_VECTOR(2 downto 0);
  WB_Enable_IN : in STD_LOGIC;
  WB_Select_IN : in STD_LOGIC;
  
 --temporary ports
 INPORT : IN STD_LOGIC_VECTOR(15 downto 0);
  
  --outputs
  WB_R_out_data_OUT : out STD_LOGIC_VECTOR(15 downto 0);
  WB_R_out_address_OUT : out STD_LOGIC_VECTOR(2 downto 0);
  WB_Enable_OUT : out STD_LOGIC);
end Writeback_latch;

architecture Behavioral of Writeback_latch is

begin
    process(clk)
    begin
        if rising_edge(clk) then --Data is always set on the rising edge of the clock
            if   WB_Select_IN = '1' then
                WB_R_out_data_OUT <= INPORT;          
            else
                WB_R_out_data_OUT <= WB_R_out_data_IN;
            end if;
            WB_R_out_address_OUT <= WB_R_out_address_IN;
            WB_Enable_OUT <= WB_Enable_IN;            
        end if;
        end process;


end Behavioral;
