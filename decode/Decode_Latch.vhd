library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Decode_Latch is
  Port (
    clk : in STD_LOGIC;
    branch_taken : in STD_LOGIC;
    stage_clear : in STD_LOGIC;
    --inputs
    DC_R_data1_IN : in STD_LOGIC_VECTOR(15 downto 0);
    DC_R_data2_IN : in STD_LOGIC_VECTOR(15 downto 0);
    DC_R_addr1_IN : in STD_LOGIC_VECTOR(2 downto 0);
    DC_R_addr2_IN : in STD_LOGIC_VECTOR(2 downto 0);
    DC_R_out_address_IN : in STD_LOGIC_VECTOR(2 downto 0);
    DC_Opcode_IN : in STD_LOGIC_VECTOR(6 downto 0);
    DC_Shift_IN : in STD_LOGIC_VECTOR(3 downto 0);
    
    --new signals
    DC_Displacement_IN : in STD_LOGIC_VECTOR(15 downto 0);
    DC_PC_IN : in STD_LOGIC_VECTOR(15 downto 0);
    DC_Displacement_OUT : out STD_LOGIC_VECTOR(15 downto 0);
    DC_PC_OUT : out STD_LOGIC_VECTOR(15 downto 0);
    
    --loadimm signals
    D_M1 : in STD_LOGIC;
    D_IMM : in STD_LOGIC_VECTOR(7 downto 0);
    D_EX_M1 : out STD_LOGIC;
    D_EX_IMM : out STD_LOGIC_VECTOR(7 downto 0);
    
    --outputs
    DC_R_data1_OUT : out STD_LOGIC_VECTOR(15 downto 0);
    DC_R_data2_OUT : out STD_LOGIC_VECTOR(15 downto 0);
    DC_EX_addr1_OUT : out STD_LOGIC_VECTOR(2 downto 0);
    DC_EX_addr2_OUT : out STD_LOGIC_VECTOR(2 downto 0);
    DC_R_out_address_OUT : out STD_LOGIC_VECTOR(2 downto 0);
    DC_Write_Enable_OUT : out STD_LOGIC;
    DC_WB_Select : out STD_LOGIC;
    DC_Opcode_OUT : out STD_LOGIC_VECTOR(6 downto 0);
    DC_Shift_OUT : out STD_LOGIC_VECTOR(3 downto 0)
  );

end Decode_Latch;

 

architecture Behavioral of Decode_Latch is

begin
    
    process(clk)
    begin
        if rising_edge(clk) or branch_taken = '1'  then
            if branch_taken = '1' or stage_clear = '1' then
                DC_Opcode_OUT <= DC_Opcode_IN;
                DC_Write_Enable_OUT <= '0';
                DC_WB_Select <= '0';
                DC_R_data1_OUT <= DC_R_data1_IN;
                DC_R_data2_OUT <= DC_R_data2_IN;
                DC_EX_addr1_OUT <= DC_R_addr1_IN;
                DC_EX_addr2_OUT <= DC_R_addr2_IN;
                DC_R_out_address_OUT <= DC_R_out_address_IN;   
                DC_Shift_OUT <= DC_Shift_IN;
                
                DC_Displacement_OUT <= DC_Displacement_IN;
                DC_PC_OUT <= DC_PC_IN;
                
                D_EX_IMM <= D_IMM;
                D_EX_M1 <= D_M1;
            else
                DC_R_data1_OUT <= DC_R_data1_IN;
                DC_R_data2_OUT <= DC_R_data2_IN;
                DC_EX_addr1_OUT <= DC_R_addr1_IN;
                DC_EX_addr2_OUT <= DC_R_addr2_IN;
--                DC_R_out_address_OUT <= DC_R_out_address_IN;   
                DC_Opcode_OUT <= DC_Opcode_IN;
                DC_Shift_OUT <= DC_Shift_IN;
                
                DC_Displacement_OUT <= DC_Displacement_IN;
                DC_PC_OUT <= DC_PC_IN;
                
                D_EX_IMM <= D_IMM;
                D_EX_M1 <= D_M1;
                
                if DC_Opcode_IN = "0010010" or DC_Opcode_IN = "1000110" then
                    DC_R_out_address_OUT <= "111";
                else
                    DC_R_out_address_OUT <= DC_R_out_address_IN;
                end if;
                
                -- will have to get opcode = 70 added for br.sub since r7 is written to
                if DC_Opcode_IN = "0000001" or DC_Opcode_IN = "0000010" or DC_Opcode_IN = "0000011" or DC_Opcode_IN = "0000100" or DC_Opcode_IN = "0000101" or DC_Opcode_IN = "0000110" or DC_Opcode_IN = "0010010" or DC_Opcode_IN = "0010011" then
                    DC_Write_Enable_OUT <= '1';
                    DC_WB_Select <= '0';
                elsif DC_Opcode_IN = "0100001" then
                    DC_WB_Select <= '1';
                    DC_Write_Enable_OUT <= '1';
                else
                    DC_Write_Enable_OUT <= '0';
                    DC_WB_Select <= '0';
                end if;
            end if;
        end if;
        end process;

end Behavioral;