library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity Control_Read_and_Write is
  Port ( 
  clk : in STD_LOGIC;
  rst : in STD_LOGIC;

  --inputs
  DC_R_data1_IN : in STD_LOGIC_VECTOR(15 downto 0);
  DC_R_data2_IN : in STD_LOGIC_VECTOR(15 downto 0);
  DC_R_out_address_IN : in STD_LOGIC_VECTOR(2 downto 0);
  DC_Write_Enable_IN : in STD_LOGIC;
  DC_Opcode_IN : in STD_LOGIC_VECTOR(6 downto 0);
  DC_Shift_IN : in STD_LOGIC_VECTOR(3 downto 0);

  --register file
  rd_index1: in std_logic_vector(2 downto 0); 
  rd_index2: in std_logic_vector(2 downto 0); 
  rd_data1: out std_logic_vector(15 downto 0); 
  rd_data2: out std_logic_vector(15 downto 0)
  
  );
end Control_Read_and_Write;

architecture Behavioral of Control_Read_and_Write is

    --signals for dc
    signal WR_Enable_DC : STD_LOGIC;
    signal R_data1_DC : STD_LOGIC_VECTOR (15 downto 0);
    signal R_data2_DC : STD_LOGIC_VECTOR (15 downto 0);
    signal R_out_address_DC_EX : STD_LOGIC_VECTOR (2 downto 0);
    signal Opcode_DC : STD_LOGIC_VECTOR (6 downto 0);
    signal Shift_DC : STD_LOGIC_VECTOR (3 downto 0);

    --signals for ALU
    signal R_data_ALU_OUT : STD_LOGIC_VECTOR (15 downto 0);
    signal Zero_Negative : STD_LOGIC_VECTOR (1 downto 0);

    --signals for ex
    signal Opcode_EX_WB : STD_LOGIC_VECTOR (6 downto 0);
    signal Write_Enable_EX_WB : STD_LOGIC;
    signal Data_EX_WB : STD_LOGIC_VECTOR (15 downto 0);
    signal Data_Addr_EX_WB : STD_LOGIC_VECTOR (2 downto 0);
    signal NZ : STD_LOGIC_VECTOR(1 downto 0);

    --signals for wb
    signal WB_EN_OUT : STD_LOGIC;
    signal WB_R_outdata_OUT : STD_LOGIC_VECTOR(15 downto 0);
    signal WB_R_outaddress_OUT : STD_LOGIC_VECTOR(2 downto 0);
    
    COMPONENT ALU
        port(
            A : in STD_LOGIC_VECTOR(15 downto 0); 
            B : in STD_LOGIC_VECTOR(15 downto 0);
            OpCode : in STD_LOGIC_VECTOR(6 downto 0); 
            Shift_value : in STD_LOGIC_VECTOR(3 downto 0); 
            C : out STD_LOGIC_VECTOR(15 downto 0); 
            Zero_Negative_flags : out STD_LOGIC_VECTOR(1 downto 0)
        );
    end COMPONENT;
    
    
    COMPONENT Writeback_Latch
        port(
            clk : in STD_LOGIC;
            --inputs
            WB_R_out_data_IN : in STD_LOGIC_VECTOR(15 downto 0);
            WB_R_out_address_IN : in STD_LOGIC_VECTOR(2 downto 0);
            WB_Enable_IN : in STD_LOGIC;
            --outputs
            WB_R_out_data_OUT : out STD_LOGIC_VECTOR(15 downto 0);
            WB_R_out_address_OUT : out STD_LOGIC_VECTOR(2 downto 0);
            WB_Enable_OUT : out STD_LOGIC);
    end COMPONENT;
    
    
    COMPONENT Execute_Latch
        port(
            clk : in STD_LOGIC;
            --inputs
            EX_write_enable_IN : in STD_LOGIC;
            EX_NegativeZero_IN : in STD_LOGIC_VECTOR(1 downto 0);
            EX_opcodeIn : in STD_LOGIC_VECTOR(6 downto 0);
            EX_ALU_data_IN : in STD_LOGIC_VECTOR(15 downto 0);
            EX_R_out_address_IN : in STD_LOGIC_VECTOR(2 downto 0); 
            --outputs
            EX_write_enable_OUT : out STD_LOGIC;
            EX_NegativeZero_OUT : out STD_LOGIC_VECTOR(1 downto 0);
            EX_opcodeOut : out STD_LOGIC_VECTOR(6 downto 0);
            EX_R_out_data_OUT : out STD_LOGIC_VECTOR(15 downto 0);
            EX_R_out_address_OUT : out  STD_LOGIC_VECTOR(2 downto 0));
    end COMPONENT;
    
    COMPONENT Decode_Latch
        port(
            clk : in STD_LOGIC;
            --inputs
            DC_R_data1_IN : in STD_LOGIC_VECTOR(15 downto 0);
            DC_R_data2_IN : in STD_LOGIC_VECTOR(15 downto 0);
            DC_R_out_address_IN : in STD_LOGIC_VECTOR(2 downto 0);
            DC_Write_Enable_IN : in STD_LOGIC;
            DC_Opcode_IN : in STD_LOGIC_VECTOR(6 downto 0);
            DC_Shift_IN : in STD_LOGIC_VECTOR(3 downto 0);
              
              --outputs
            DC_R_data1_OUT : out STD_LOGIC_VECTOR(15 downto 0);
            DC_R_data2_OUT : out STD_LOGIC_VECTOR(15 downto 0);
            DC_R_out_address_OUT : out STD_LOGIC_VECTOR(2 downto 0);
            DC_Write_Enable_OUT : out STD_LOGIC;
            DC_Opcode_OUT : out STD_LOGIC_VECTOR(6 downto 0);
            DC_Shift_OUT : out STD_LOGIC_VECTOR(3 downto 0));
    end COMPONENT;

    COMPONENT RF8_16
        port(
            rst : in std_logic; 
            clk: in std_logic;
            --read signals
            rd_index1: in std_logic_vector(2 downto 0); 
            rd_index2: in std_logic_vector(2 downto 0); 
            rd_data1: out std_logic_vector(15 downto 0); 
            rd_data2: out std_logic_vector(15 downto 0);
            --write signals
            wr_index: in std_logic_vector(2 downto 0); 
            wr_data: in std_logic_vector(15 downto 0); 
            wr_enable: in std_logic);
    end COMPONENT;
    
begin
    --
    
    DC_Latch_INST : Decode_Latch port map (clk=>clk, DC_R_data1_IN => DC_R_data1_IN, DC_R_data2_IN => DC_R_data2_IN, DC_R_out_address_IN => DC_R_out_address_IN,
                                            DC_Write_Enable_IN => DC_Write_Enable_IN, DC_Opcode_IN => DC_Opcode_IN, DC_Shift_IN => DC_Shift_IN,
                                            DC_R_data1_OUT => R_data1_DC, DC_R_data2_OUT => R_data2_DC, DC_R_out_address_OUT => R_out_address_DC_EX,
                                            DC_Write_Enable_OUT => WR_Enable_DC, DC_Opcode_OUT => Opcode_DC, DC_Shift_OUT  => Shift_DC);
    
    
    EX_Latch_INST : Execute_Latch port map(clk=>clk, EX_write_enable_IN => WR_Enable_DC, EX_NegativeZero_IN => Zero_Negative, 
                                           EX_opcodeIn => Opcode_DC, EX_ALU_data_IN => R_data_ALU_OUT, EX_R_out_address_IN => R_out_address_DC_EX,
                                           EX_write_enable_OUT => Write_Enable_EX_WB , EX_NegativeZero_OUT => NZ, EX_opcodeOut=> Opcode_EX_WB,
                                           EX_R_out_data_OUT => Data_EX_WB, EX_R_out_address_OUT => Data_Addr_EX_WB);
    
    
    WB_Latch_INST : Writeback_Latch port map(clk=>clk, WB_R_out_data_IN => Data_EX_WB,
                                            WB_R_out_address_IN => Data_Addr_EX_WB, WB_Enable_IN => Write_Enable_EX_WB,
                                            WB_R_out_data_OUT => WB_R_outdata_OUT, WB_R_out_address_OUT => WB_R_outaddress_OUT,
                                            WB_Enable_OUT => WB_EN_OUT);
    
    ALU_INST : ALU port map(A =>R_data1_DC, B =>R_data2_DC, OpCode =>Opcode_DC, Shift_value =>Shift_DC,
                             C=>R_data_ALU_OUT, Zero_Negative_flags=>Zero_Negative);
    
    RF8_16_INST: RF8_16 port map( clk => clk, rst => rst, rd_index1 => rd_index1, rd_index2 => rd_index2,
                                  rd_data1 => rd_data1, rd_data2 => rd_data2, wr_index => WB_R_outaddress_OUT,
                                  wr_data => WB_R_outdata_OUT, wr_enable => WB_EN_OUT    );
    
    


end Behavioral;
