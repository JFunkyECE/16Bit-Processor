library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Hazard_Unit is
 Port ( 
    rst : in STD_LOGIC;
    DC_EX_R2_addr_IN : in STD_LOGIC_VECTOR(2 downto 0);
    DC_EX_MEM_READ_EN_IN : in STD_LOGIC;
    F_DC_R1_addr_IN : in STD_LOGIC_VECTOR(2 downto 0);
    F_DC_R2_addr_IN : in STD_LOGIC_VECTOR(2 downto 0);
    F_DC_OPCODE_IN : in STD_LOGIC_VECTOR(6 downto 0);
    DC_EX_OPCODE_IN : in STD_LOGIC_VECTOR(6 downto 0);
    
    --outputs
    STALL_OUT : out STD_LOGIC;
    PC_WRITE_OUT : out STD_LOGIC
 );
end Hazard_Unit;

architecture Behavioral of Hazard_Unit is

begin
process(rst, DC_EX_R2_addr_IN, DC_EX_MEM_READ_EN_IN, F_DC_R1_addr_IN, F_DC_R2_addr_IN, F_DC_OPCODE_IN, DC_EX_OPCODE_IN)
begin
    if rst = '1' or F_DC_OPCODE_IN = DC_EX_OPCODE_IN then
        STALL_OUT <= '0';
        PC_WRITE_OUT <= '0';
    elsif DC_EX_MEM_READ_EN_IN = '1' and (DC_EX_R2_addr_IN = F_DC_R1_addr_IN or DC_EX_R2_addr_IN = F_DC_R2_addr_IN) then --Stall the pipeline if true
        STALL_OUT <= '1';
        PC_WRITE_OUT <= '1';
    else 
        STALL_OUT <= '0';
        PC_WRITE_OUT <= '0';
    end if;
end process;

end Behavioral;
