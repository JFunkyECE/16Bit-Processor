library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Forwarding_Unit is
  Port ( 
    --inputs
    Forward_EX_IN : in STD_LOGIC_VECTOR(15 downto 0);
    Forward_WB_IN : in STD_LOGIC_VECTOR(15 downto 0);
    Forward_DC_data1_IN : in STD_LOGIC_VECTOR(15 downto 0);
    Forward_DC_data2_IN : in STD_LOGIC_VECTOR(15 downto 0);
    Forward_DC_Rin1_IN : in STD_LOGIC_VECTOR(2 downto 0);
    Forward_DC_Rin2_IN : in STD_LOGIC_VECTOR(2 downto 0);
    Forward_EX_Rout_IN : in STD_LOGIC_VECTOR(2 downto 0);
    Forward_WB_Rout_IN : in STD_LOGIC_VECTOR(2 downto 0);
    Forward_DC_Write_Enable_IN : in STD_LOGIC;
    Forward_EX_Write_Enable_IN : in STD_LOGIC;
    Forward_WB_Enable_IN : in STD_LOGIC;
    --outputs
    data_A_OUT : out STD_LOGIC_VECTOR(15 downto 0);
    data_B_OUT : out STD_LOGIC_VECTOR(15 downto 0)    
  );
end Forwarding_Unit;

architecture Behavioral of Forwarding_Unit is
begin
    -- Forwarding logic
    process(Forward_DC_Write_Enable_IN, Forward_EX_Write_Enable_IN, Forward_WB_Enable_IN, Forward_EX_Rout_IN, Forward_DC_Rin1_IN, Forward_DC_Rin2_IN, Forward_EX_IN, Forward_DC_data1_IN, Forward_DC_data2_IN, Forward_WB_Rout_IN, Forward_WB_IN)
    begin
        -- Check forwarding condition for Data1
        if (Forward_EX_Rout_IN = Forward_DC_Rin1_IN and Forward_EX_Write_Enable_IN = '1') then
            data_A_OUT <= Forward_EX_IN;
        elsif (Forward_WB_Rout_IN = Forward_DC_Rin1_IN and Forward_WB_Enable_IN = '1') then
            data_A_OUT <= Forward_WB_IN;
        else
            data_A_OUT <= Forward_DC_data1_IN;
        end if;
        
        -- Check forwarding condition for Data2
        if (Forward_EX_Rout_IN = Forward_DC_Rin2_IN and Forward_EX_Write_Enable_IN = '1') then
            data_B_OUT <= Forward_EX_IN;
        elsif (Forward_WB_Rout_IN = Forward_DC_Rin2_IN and Forward_WB_Enable_IN = '1') then
            data_B_OUT <= Forward_WB_IN;
        else
            data_B_OUT <= Forward_DC_data2_IN;
        end if;          
    end process;
end Behavioral;

