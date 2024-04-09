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
    
    --new signals for branch instructions
    Opcode : in STD_LOGIC_VECTOR(6 downto 0);
    PC : in STD_LOGIC_VECTOR(15 downto 0);
    Displacement : in STD_LOGIC_VECTOR(15 downto 0);
    --outputs
    data_A_OUT : out STD_LOGIC_VECTOR(15 downto 0);
    data_B_OUT : out STD_LOGIC_VECTOR(15 downto 0)    
  );
end Forwarding_Unit;

architecture Behavioral of Forwarding_Unit is 
begin
    -- Forwarding logic
    process(Opcode, PC, Displacement, Forward_DC_Write_Enable_IN, Forward_EX_Write_Enable_IN, Forward_WB_Enable_IN, Forward_EX_Rout_IN, Forward_DC_Rin1_IN, Forward_DC_Rin2_IN, Forward_EX_IN, Forward_DC_data1_IN, Forward_DC_data2_IN, Forward_WB_Rout_IN, Forward_WB_IN)
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
        
        --for the start or branching only inlcudings 64,65,66 for displacement L
        if Opcode = "1000000" or Opcode = "1000001" or Opcode = "1000010" then
            data_A_OUT <= PC;
            data_B_OUT <= Displacement;
        end if;
        -- branching for 67,68,69,70
        if Opcode = "1000011" or Opcode = "1000100" or Opcode = "1000101" or Opcode = "1000110" then
            data_B_OUT <= Displacement;
        end if;
                  
    end process;
end Behavioral;

