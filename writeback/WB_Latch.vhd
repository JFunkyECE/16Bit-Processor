
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Writeback_latch is
  Port ( 
  clk : in STD_LOGIC;
  
  --inputs
  WB_R_out_data_IN : in STD_LOGIC_VECTOR(15 downto 0);
  WB_R_out_address_IN : in STD_LOGIC_VECTOR(2 downto 0);
  WB_Enable_IN : in STD_LOGIC;  
  -- for branching
  WB_PC2 : in STD_LOGIC_VECTOR(15 downto 0);
  WB_Opcode_IN : in STD_LOGIC_VECTOR(6 downto 0);
  WB_Opcode_OUT : out STD_LOGIC_VECTOR(6 downto 0);
  
  -- for load
  WB_LOAD_DATA : in STD_LOGIC_VECTOR(15 downto 0);
  
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
            WB_Opcode_OUT <= WB_Opcode_IN;
            if WB_Opcode_IN = "1000110" then --br.sub, writes pc+2 into r7
                        WB_R_out_data_OUT <= WB_PC2;
                        WB_R_out_address_OUT <= "111";
                        WB_Enable_OUT <= '1';
            elsif WB_Opcode_IN = "0010000" then --load instruction
                        WB_R_out_data_OUT <= WB_LOAD_DATA;
                        WB_R_out_address_OUT <= WB_R_out_address_IN;
                        WB_Enable_OUT <= '1';
            else
                WB_R_out_data_OUT <= WB_R_out_data_IN;
                WB_R_out_address_OUT <= WB_R_out_address_IN;
                WB_Enable_OUT <= WB_Enable_IN;          
            end if;
        end if;
        end process;


end Behavioral;
