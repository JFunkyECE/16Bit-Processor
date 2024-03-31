library IEEE;

use IEEE.STD_LOGIC_1164.ALL;


entity Control is
  Port (
  clk : in STD_LOGIC;
  rst : in STD_LOGIC;

  --inputs
  INPUT_SIGNAL : in STD_LOGIC_VECTOR(15 downto 0);

  --outputs
  PC : out STD_LOGIC_VECTOR(15 downto 0);
  data : out STD_LOGIC_VECTOR(15 downto 0);
  ALU_DATA_OUT : out STD_LOGIC_VECTOR(15 downto 0);
  read_data1 : out STD_LOGIC_VECTOR(15 downto 0); --for debug
  read_data2 : out STD_LOGIC_VECTOR(15 downto 0); --for debug
  read_index1 : out STD_LOGIC_VECTOR(2 downto 0); --for debug
  read_index2 : out STD_LOGIC_VECTOR(2 downto 0); --for debug
  data_addr_Out : out STD_LOGIC_VECTOR(2 downto 0); --for debug
  data_Out : out STD_LOGIC_VECTOR(15 downto 0); --For debug
  wb_select : out STD_LOGIC;
  
  forwardedoutA : out STD_LOGIC_VECTOR(15 downto 0);
  forwardedoutB : out STD_LOGIC_VECTOR(15 downto 0);
  Decode_to_forward_A : out STD_LOGIC_VECTOR(15 downto 0);
  Decode_to_forward_B : out STD_LOGIC_VECTOR(15 downto 0)
  
  );

end Control;

 

architecture Behavioral of Control is   

    --signals for fetch
    signal Opcode_F : STD_LOGIC_VECTOR(6 downto 0);
    signal R_in1_address_F : STD_LOGIC_VECTOR(2 downto 0);
    signal R_in2_address_F : STD_LOGIC_VECTOR(2 downto 0);
    signal R_out_address_F : STD_LOGIC_VECTOR(2 downto 0);
    signal shift_F : STD_LOGIC_VECTOR(3 downto 0); 

    --signals for Forwarding_Unit
    signal Forward_ALU_data1 : STD_LOGIC_VECTOR (15 downto 0);
    signal Forward_ALU_data2 : STD_LOGIC_VECTOR (15 downto 0);

    --signals for dc
    signal WR_Enable_DC : STD_LOGIC;
    signal R_data1_DC : STD_LOGIC_VECTOR (15 downto 0);
    signal R_data2_DC : STD_LOGIC_VECTOR (15 downto 0);
    signal R_in1_address_DC_EX : STD_LOGIC_VECTOR(2 downto 0);
    signal R_in2_address_DC_EX : STD_LOGIC_VECTOR(2 downto 0);
    signal R_out_address_DC_EX : STD_LOGIC_VECTOR (2 downto 0);
    signal Opcode_DC : STD_LOGIC_VECTOR (6 downto 0);
    signal Shift_DC : STD_LOGIC_VECTOR (3 downto 0);
    signal Select_DC : STD_LOGIC;
 
    --signals for ALU
    signal R_data_ALU_OUT : STD_LOGIC_VECTOR (15 downto 0);
    signal Zero_Negative : STD_LOGIC_VECTOR (1 downto 0);
 
    --signals for ex
    signal Opcode_EX_WB : STD_LOGIC_VECTOR (6 downto 0);
    signal Write_Enable_EX_WB : STD_LOGIC;
    signal Data_EX_WB : STD_LOGIC_VECTOR (15 downto 0);
    signal Data_Addr_EX_WB : STD_LOGIC_VECTOR (2 downto 0);
    signal NZ : STD_LOGIC_VECTOR(1 downto 0);
    signal Select_EX : STD_LOGIC;
 
    --signals for wb
    signal WB_EN_OUT : STD_LOGIC;
    signal WB_R_outdata_OUT : STD_LOGIC_VECTOR(15 downto 0);
    signal WB_R_outaddress_OUT : STD_LOGIC_VECTOR(2 downto 0);
   
    --signals for register file
    signal r1_data : STD_LOGIC_VECTOR(15 downto 0);
    signal r2_data : STD_LOGIC_VECTOR(15 downto 0);
    
    -- Forwarding control signals
    signal Use_Forwarded_Data_EX_IN : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal Use_Forwarded_Data_WB_IN : STD_LOGIC_VECTOR(1 downto 0) := "00";
    
    --signals for fetch stage
    signal PC_OUT : STD_LOGIC_VECTOR(15 downto 0);
    signal Instruction_OUT : STD_LOGIC_VECTOR(15 downto 0);
    signal PC_Updated : STD_LOGIC_VECTOR(15 downto 0);
    signal IR : STD_LOGIC_VECTOR(15 downto 0);
    
    --RAM signals
    signal wea_RAM : STD_LOGIC_VECTOR(0 downto 0);
    signal addra_RAM : STD_LOGIC_VECTOR(8 downto 0);
    signal dina_RAM : STD_LOGIC_VECTOR(15 downto 0);
    signal douta_RAM : STD_LOGIC_VECTOR(15 downto 0);
    signal addrb_RAM : STD_LOGIC_VECTOR(8 downto 0);
    signal doutb_RAM : STD_LOGIC_VECTOR(15 downto 0);
    
    
    COMPONENT ALU
        port(
            --clk : in STD_LOGIC;
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
            WB_Select_IN : in STD_LOGIC;
            INPORT : IN STD_LOGIC_VECTOR(15 downto 0);
 
            --outputs
            WB_R_out_data_OUT : out STD_LOGIC_VECTOR(15 downto 0);
            WB_R_out_address_OUT : out STD_LOGIC_VECTOR(2 downto 0);
            WB_Enable_OUT : out STD_LOGIC
        );
    end COMPONENT;
   
    
    COMPONENT Execute_Latch
        port(
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
            EX_select_OUT : out STD_LOGIC;
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
            DC_R_addr1_IN : in STD_LOGIC_VECTOR(2 downto 0);
            DC_R_addr2_IN : in STD_LOGIC_VECTOR(2 downto 0);
            DC_R_out_address_IN : in STD_LOGIC_VECTOR(2 downto 0);
            DC_Opcode_IN : in STD_LOGIC_VECTOR(6 downto 0);
            DC_Shift_IN : in STD_LOGIC_VECTOR(3 downto 0);
              
              --outputs
            DC_R_data1_OUT : out STD_LOGIC_VECTOR(15 downto 0);
            DC_R_data2_OUT : out STD_LOGIC_VECTOR(15 downto 0);
            DC_EX_addr1_OUT : out STD_LOGIC_VECTOR(2 downto 0);
            DC_EX_addr2_OUT : out STD_LOGIC_VECTOR(2 downto 0);
            DC_R_out_address_OUT : out STD_LOGIC_VECTOR(2 downto 0);
            DC_Write_Enable_OUT : out STD_LOGIC;
            DC_WB_Select : out STD_LOGIC;
            DC_Opcode_OUT : out STD_LOGIC_VECTOR(6 downto 0);
            DC_Shift_OUT : out STD_LOGIC_VECTOR(3 downto 0));
    end COMPONENT;

    COMPONENT Forwarding_Unit
        port(           
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

    end COMPONENT;

   

    COMPONENT Fetch_Latch
        port(
            clk : in STD_LOGIC;           
            --inputs
            Instruction : IN STD_LOGIC_VECTOR(15 downto 0);      

            --outputs
            F_OpcodeOut : out STD_LOGIC_VECTOR(6 downto 0);
            F_R_in1_address_OUT : out STD_LOGIC_VECTOR(2 downto 0);
            F_R_in2_address_OUT : out STD_LOGIC_VECTOR(2 downto 0);
            F_R_out_address_OUT : out STD_LOGIC_VECTOR(2 downto 0);
            F_shift_OUT : out STD_LOGIC_VECTOR(3 downto 0)  
        );

    end COMPONENT;

    COMPONENT Fetch
        port(
            clk : IN std_logic; 
            reset : IN std_logic;           
            PC : IN std_logic_vector(15 downto 0); 
            PC_Updated : OUT std_logic_vector(15 downto 0);             
            Data_OUT : IN std_logic_vector(15 downto 0);
            Instruction_Register : OUT std_logic_vector(15 downto 0)        
        );
    end COMPONENT;
    
    COMPONENT Program_Counter
        port(
            clk : IN std_logic;   
            reset : IN std_logic;
            PC_IN : IN std_logic_vector(15 downto 0);
            PC_OUT : OUT std_logic_vector(15 downto 0)
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
            wr_enable: in std_logic);
    end COMPONENT;

   COMPONENT ROM
        port(
            clka_ROM : in STD_LOGIC;
            rsta_ROM : in STD_LOGIC;
            addra_ROM : in STD_LOGIC_VECTOR(8 downto 0);
            douta_ROM : out STD_LOGIC_VECTOR(15 downto 0)
    );
   end COMPONENT;
   
   COMPONENT RAM
           port(
               clka_RAM : IN STD_LOGIC;
               rsta_RAM : IN STD_LOGIC;
               wea_RAM : IN STD_LOGIC_VECTOR(0 downto 0);      
               addra_RAM : IN STD_LOGIC_VECTOR(8 downto 0);
               dina_RAM  : IN STD_LOGIC_VECTOR(15 downto 0);
               douta_RAM : OUT STD_LOGIC_VECTOR(15 downto 0);
                 -- Port B module ports
               rstb_RAM : IN STD_LOGIC;
               addrb_RAM : IN STD_LOGIC_VECTOR(8 downto 0);
               doutb_RAM : OUT STD_LOGIC_VECTOR(15 downto 0)
           
    );
    end COMPONENT;
   


begin    

    F_Latch_INST: Fetch_Latch port map(clk=>clk, Instruction => IR, F_OpcodeOut => Opcode_F,
                                       F_R_in1_address_OUT => R_in1_address_F, F_R_in2_address_OUT => R_in2_address_F,
                                       F_R_out_address_OUT => R_out_address_F, F_shift_OUT => shift_F ); 
                                        

    DC_Latch_INST : Decode_Latch port map (clk=>clk, DC_R_data1_IN => r1_data, DC_R_data2_IN => r2_data,
                                            DC_R_addr1_IN =>R_in1_address_F, DC_R_addr2_IN => R_in2_address_F,
                                            DC_R_out_address_IN => R_out_address_F,
                                            DC_Opcode_IN => Opcode_F , DC_Shift_IN => shift_F, 
                                            DC_R_data1_OUT => R_data1_DC, DC_R_data2_OUT => R_data2_DC,
                                            DC_EX_addr1_OUT => R_in1_address_DC_EX, DC_EX_addr2_OUT => R_in2_address_DC_EX,
                                            DC_R_out_address_OUT => R_out_address_DC_EX,
                                            DC_Write_Enable_OUT => WR_Enable_DC, DC_Opcode_OUT => Opcode_DC, DC_Shift_OUT  => Shift_DC,
                                            DC_WB_Select => Select_DC);
                                            

    Forwarding_Unit_INST : Forwarding_Unit port map(Forward_EX_IN => Data_EX_WB, Forward_WB_IN => WB_R_outdata_OUT, Forward_DC_data1_IN => R_data1_DC,
                                                    Forward_DC_data2_IN => R_data2_DC, Forward_DC_Rin1_IN => R_in1_address_DC_EX,
                                                    Forward_DC_Rin2_IN => R_in2_address_DC_EX, Forward_EX_Rout_IN => Data_Addr_EX_WB,
                                                    Forward_WB_Rout_IN => WB_R_outaddress_OUT, Forward_DC_Write_Enable_IN => WR_Enable_DC,
                                                    Forward_EX_Write_Enable_IN => Write_Enable_EX_WB, Forward_WB_Enable_IN => WB_EN_OUT,
                                                    data_A_OUT => Forward_ALU_data1, data_B_OUT => Forward_ALU_data2);

    EX_Latch_INST : Execute_Latch port map(clk=>clk, EX_write_enable_IN => WR_Enable_DC, EX_NegativeZero_IN => Zero_Negative,
                                           EX_opcodeIn => Opcode_DC, EX_ALU_data_IN => R_data_ALU_OUT,
                                           EX_R_out_address_IN => R_out_address_DC_EX,
                                           EX_write_enable_OUT => Write_Enable_EX_WB , EX_NegativeZero_OUT => NZ, EX_opcodeOut=> Opcode_EX_WB,
                                           EX_R_out_data_OUT => Data_EX_WB, EX_R_out_address_OUT => Data_Addr_EX_WB,
                                           EX_select_IN =>Select_DC,EX_select_OUT => Select_EX  );    

    WB_Latch_INST : Writeback_Latch port map(clk=>clk, WB_R_out_data_IN => Data_EX_WB, WB_Select_IN => Select_EX,
                                            WB_R_out_address_IN => Data_Addr_EX_WB, WB_Enable_IN => Write_Enable_EX_WB,
                                            WB_R_out_data_OUT => WB_R_outdata_OUT, WB_R_out_address_OUT => WB_R_outaddress_OUT,
                                            WB_Enable_OUT => WB_EN_OUT, INPORT => INPUT_SIGNAL);

    ALU_INST : ALU port map(A => Forward_ALU_data1, B => Forward_ALU_data2, OpCode => OpCode_DC, Shift_value => Shift_DC,
                            C => R_data_ALU_OUT, Zero_Negative_flags => Zero_Negative);
   
    RF8_16_INST: RF8_16 port map( clk => clk, rst => rst, rd_index1 => R_in1_address_F , rd_index2 => R_in2_address_F ,
                                  rd_data1 => r1_data , rd_data2 => r2_data , wr_index => WB_R_outaddress_OUT,
                                  wr_data => WB_R_outdata_OUT, wr_enable => WB_EN_OUT);

    Fetch_INST : Fetch port map(clk  => clk, reset => rst, PC => PC_OUT, PC_Updated => PC_Updated, Data_OUT => Instruction_OUT, Instruction_Register => IR);
    
    PC_INST : Program_Counter port map(clk => clk, reset => rst, PC_IN => PC_Updated, PC_OUT => PC_OUT);
    
    ROM_INST : ROM port map(clka_ROM => clk, rsta_ROM => rst, addra_ROM => PC_OUT(9 downto 1) , douta_ROM => Instruction_OUT);
    
    RAM_INST : RAM port map(clka_RAM => clk, wea_RAM => wea_RAM , addra_RAM => addra_RAM,
                            dina_RAM => dina_RAM, douta_RAM => douta_RAM, rstb_RAM => rst, addrb_RAM => addrb_RAM,
                            doutb_RAM => doutb_RAM, rsta_RAM => rst);

        data <= Instruction_OUT;
        pc <= PC_OUT;
        ALU_DATA_OUT <= Data_EX_WB;
        read_data1 <= r1_data;
        read_data2 <= r2_data;
        read_index1 <= R_in1_address_DC_EX;
        read_index2 <= R_in2_address_DC_EX;
        data_addr_Out <= WB_R_outaddress_OUT;
        data_Out <= WB_R_outdata_OUT;
        wb_select <= Select_EX;
        
        --checking for data issues
        forwardedoutA <= Forward_ALU_data1;
        forwardedoutB <= Forward_ALU_data2;
        Decode_to_forward_A <= R_data1_DC;
        Decode_to_forward_B <= R_data2_DC;
        
        
end Behavioral;