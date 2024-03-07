library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity Control_Read_and_Write is
  Port ( 
  clk : in STD_LOGIC;
  rst : in STD_LOGIC;

  --inputs
  R_out_data_IN : in STD_LOGIC_VECTOR(15 downto 0);
  R_out_address_IN : in STD_LOGIC_VECTOR(2 downto 0);
  WB_Enable_IN : in STD_LOGIC;
  --register file
  rd_index1: in std_logic_vector(2 downto 0); 
  rd_index2: in std_logic_vector(2 downto 0); 
  rd_data1: out std_logic_vector(15 downto 0); 
  rd_data2: out std_logic_vector(15 downto 0)
  
  );
end Control_Read_and_Write;

architecture Behavioral of Control_Read_and_Write is

    signal WB_EN_OUT : STD_LOGIC;
    signal R_outdata_OUT : STD_LOGIC_VECTOR(15 downto 0);
    signal R_outaddress_OUT : STD_LOGIC_VECTOR(2 downto 0);
    
    COMPONENT WB_Latch
        port(
            clk : in STD_LOGIC;
            --inputs
            R_out_data_IN : in STD_LOGIC_VECTOR(15 downto 0);
            R_out_address_IN : in STD_LOGIC_VECTOR(2 downto 0);
            WB_Enable_IN : in STD_LOGIC;
            --outputs
            R_out_data_OUT : out STD_LOGIC_VECTOR(15 downto 0);
            R_out_address_OUT : out STD_LOGIC_VECTOR(2 downto 0);
            WB_Enable_OUT : out STD_LOGIC         
        );
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
            wr_enable: in std_logic
        );
    end COMPONENT;
    
begin

    WB_Latch_INST : WB_Latch port map(clk=>clk, R_out_data_IN => R_out_data_IN,
                                      R_out_address_IN => R_out_address_IN, WB_Enable_IN => WB_Enable_IN,
                                      R_out_data_OUT => R_outdata_OUT, R_out_address_OUT => R_outaddress_OUT,
                                      WB_Enable_OUT => WB_EN_OUT);
    
    RF8_16_INST: RF8_16 port map( clk => clk, rst => rst, rd_index1 => rd_index1, rd_index2 => rd_index2,
                                  rd_data1 => rd_data1, rd_data2 => rd_data2, wr_index => R_outaddress_OUT,
                                  wr_data => R_outdata_OUT, wr_enable => WB_EN_OUT    );
    



end Behavioral;
