library IEEE;

use IEEE.STD_LOGIC_1164.ALL;


entity Control is
  Port (
  clk : in STD_LOGIC;
  rst : in STD_LOGIC;

  --inputs
  INPUT_SIGNAL : in STD_LOGIC_VECTOR(15 downto 0);

  --outputs
  data : out STD_LOGIC_VECTOR(15 downto 0);
  ALU_DATA_OUT : out STD_LOGIC_VECTOR(15 downto 0);
  read_data1 : out STD_LOGIC_VECTOR(15 downto 0); --for debug
  read_data2 : out STD_LOGIC_VECTOR(15 downto 0); --for debug
  read_index1 : out STD_LOGIC_VECTOR(2 downto 0); --for debug
  read_index2 : out STD_LOGIC_VECTOR(2 downto 0); --for debug
  data_addr_Out : out STD_LOGIC_VECTOR(2 downto 0); --for debug
  data_Out : out STD_LOGIC_VECTOR(15 downto 0); --For debug
  wb_select : out STD_LOGIC;

  f_pc : out STD_LOGIC_VECTOR(15 downto 0); 
  f_opcode : out STD_LOGIC_VECTOR(6 downto 0);
  
  dc_pc : out STD_LOGIC_VECTOR(15 downto 0);
  dc_displacement : out STD_LOGIC_VECTOR(15 downto 0);
  
  ex_branchsel : out STD_LOGIC;
  ex_data_out : out STD_LOGIC_VECTOR(15 downto 0);
  
  writeback_data : out STD_LOGIC_VECTOR(15 downto 0);
  writeback_addr : out STD_LOGIC_VECTOR(2 downto 0);
  writeback_enable : out STD_LOGIC;
  writeback_PC2 : out STD_LOGIC_VECTOR(15 downto 0);
  writeback_opcode : out STD_LOGIC_VECTOR(6 downto 0)
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
    
    --signals for Hazard Unit
    signal STALL_OUT : STD_LOGIC;
    signal PC_WRITE_OUT : STD_LOGIC;
    signal WR_ENABLE_OUT : STD_LOGIC;
    signal HU_WB_LOAD_COMPLETE_OUT : STD_LOGIC;
    

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
    signal MEM_READ_DC : STD_LOGIC;
    signal DC_EX_Load_Complete_OUT : STD_LOGIC;
 
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
    signal EX_WB_Load_Complete_OUT : STD_LOGIC;
 
    --signals for wb
    signal WB_EN_OUT : STD_LOGIC;
    signal WB_R_outdata_OUT : STD_LOGIC_VECTOR(15 downto 0);
    signal WB_R_outaddress_OUT : STD_LOGIC_VECTOR(2 downto 0);
    signal WB_HU_LOAD_COMPLETE_OUT : STD_LOGIC;
   
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
    
    --signals for branching operations
    
    --from fetch latch to decode stage
    signal displacementL : STD_LOGIC_VECTOR(8 downto 0);
    signal displacementS : STD_LOGIC_VECTOR(5 downto 0);
    signal Fetch_PC : STD_LOGIC_VECTOR(15 downto 0);
    
    --decode stage to decode latch
    signal F_Displacement : STD_LOGIC_VECTOR(15 downto 0);
    signal R_Select : STD_LOGIC_VECTOR(2 downto 0);
    
    --decode latch to ex
    signal Displacement_DC_EX : STD_LOGIC_VECTOR(15 downto 0);
    signal PC_DC_EX : STD_LOGIC_VECTOR(15 downto 0);
    --from ex latch to fetch
    signal branch_sel : STD_LOGIC;
    signal B_PC : STD_LOGIC_VECTOR(15 downto 0);
    -- from ex to ex latch
    signal branch_Sel_EX : STD_LOGIC;
    
    signal EX_WB_PC : STD_LOGIC_VECTOR(15 downto 0);
    signal WB_OP_OUT : STD_LOGIC_VECTOR(6 downto 0);
    
    
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
 
            WB_PC2 : in STD_LOGIC_VECTOR(15 downto 0);
            WB_Opcode_IN : in STD_LOGIC_VECTOR(6 downto 0);
            WB_Opcode_OUT : out STD_LOGIC_VECTOR(6 downto 0);
            
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
            EX_R_out_address_OUT : out  STD_LOGIC_VECTOR(2 downto 0);
            
            --new signals for branch
            EX_Branch_Select_IN : in STD_LOGIC;
            EX_Branch_Select_OUT : out STD_LOGIC;
            EX_PC_IN : in STD_LOGIC_VECTOR(15 downto 0);
            EX_PC_OUT : out STD_LOGIC_VECTOR(15 downto 0)
            --will use data out as the branch address to go to.
            );
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
            STALL_IN : in STD_LOGIC;
              
              --outputs
            DC_R_data1_OUT : out STD_LOGIC_VECTOR(15 downto 0);
            DC_R_data2_OUT : out STD_LOGIC_VECTOR(15 downto 0);
            DC_EX_addr1_OUT : out STD_LOGIC_VECTOR(2 downto 0);
            DC_EX_addr2_OUT : out STD_LOGIC_VECTOR(2 downto 0);
            DC_R_out_address_OUT : out STD_LOGIC_VECTOR(2 downto 0);
            DC_Write_Enable_OUT : out STD_LOGIC;
            DC_WB_Select : out STD_LOGIC;
            DC_MEM_READ_OUT : out STD_LOGIC; --new output for mem read
            DC_Opcode_OUT : out STD_LOGIC_VECTOR(6 downto 0);
            DC_Shift_OUT : out STD_LOGIC_VECTOR(3 downto 0);
            
            --new signals for branching
            DC_Displacement_IN : in STD_LOGIC_VECTOR(15 downto 0);
            DC_PC_IN : in STD_LOGIC_VECTOR(15 downto 0);
            DC_Displacement_OUT : out STD_LOGIC_VECTOR(15 downto 0);
            DC_PC_OUT : out STD_LOGIC_VECTOR(15 downto 0)
            
            );
    end COMPONENT;
    
    COMPONENT Displacement_Calculation
        port(
            rst : in std_logic;
            Displacement_L : in std_logic_vector(8 downto 0);
            Displacement_S : in std_logic_vector(5 downto 0);
            Opcode : in std_logic_vector(6 downto 0);
            Displacement_Final : out std_logic_vector(15 downto 0)
        );
    end COMPONENT;
    
    COMPONENT Branch_Select
        port(
            rst : in std_logic;
            Opcode : in std_logic_vector(6 downto 0);
            ZN_Flags : in std_logic_vector(1 downto 0);
            BR_Select: out std_logic
        );
    end COMPONENT;

    COMPONENT Register_Select
        port(
            rst : in std_logic;
            R_IN_1 : in std_logic_vector(2 downto 0);
            R_IN_2_branch: in std_logic_vector(2 downto 0);
            Opcode : in std_logic_vector(6 downto 0);            
            R1_OUT : out std_logic_vector(2 downto 0)
        );
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
            data_B_OUT : out STD_LOGIC_VECTOR(15 downto 0);
            
            --new signals for branching
            Opcode : in STD_LOGIC_VECTOR(6 downto 0);
            PC : in STD_LOGIC_VECTOR(15 downto 0);
            Displacement : in STD_LOGIC_VECTOR(15 downto 0)   
        );

    end COMPONENT;

   COMPONENT Hazard_Unit is
        Port (
            rst : in STD_LOGIC; 
            DC_EX_R2_addr_IN : in STD_LOGIC_VECTOR(2 downto 0);
            DC_EX_MEM_READ_EN_IN : in STD_LOGIC := '0';
            F_DC_R1_addr_IN : in STD_LOGIC_VECTOR(2 downto 0);
            F_DC_R2_addr_IN : in STD_LOGIC_VECTOR(2 downto 0);
            F_DC_OPCODE_IN : in STD_LOGIC_VECTOR(6 downto 0);
            DC_EX_OPCODE_IN : in STD_LOGIC_VECTOR(6 downto 0);
            
            --outputs
            STALL_OUT : out STD_LOGIC;
            PC_WRITE_OUT : out STD_LOGIC 
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
            F_shift_OUT : out STD_LOGIC_VECTOR(3 downto 0);
            
            PC_IN : IN STD_LOGIC_VECTOR(15 downto 0);
            F_displacementl: out STD_LOGIC_VECTOR(8 downto 0);
            F_displacements : out STD_LOGIC_VECTOR(5 downto 0);
            F_PC : out STD_LOGIC_VECTOR(15 downto 0)
        );

    end COMPONENT;

    COMPONENT Fetch
        port(    
            clk : IN std_logic; 
            reset : IN std_logic;           
            PC : IN std_logic_vector(15 downto 0); 
            PC_Updated : OUT std_logic_vector(15 downto 0);             
            Data_OUT : IN std_logic_vector(15 downto 0);
            Instruction_Register : OUT std_logic_vector(15 downto 0);
            PC_STALL : IN std_logic; --stalls the program counter
            
            --new signals for branching
            branch_select : IN std_logic;
            branch_PC : IN std_logic_vector(15 downto 0)     
        );
    end COMPONENT;
    
    COMPONENT Program_Counter
        port(
            clk : IN std_logic;   
            reset : IN std_logic;
            PC_IN : IN std_logic_vector(15 downto 0);
            PC_OUT : OUT std_logic_vector(15 downto 0);
            DC_Opcode : IN std_logic_vector(6 downto 0);
            DC_R7 : IN std_logic_vector(15 downto 0)
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
                                       F_R_out_address_OUT => R_out_address_F, F_shift_OUT => shift_F,
                                       PC_IN => PC_OUT, F_displacementl => displacementL, F_displacements => displacementS , F_PC => Fetch_PC); 
                                       
   Hazard_Unit_INST : Hazard_Unit port map(rst => rst, DC_EX_R2_addr_IN => R_in2_address_DC_EX, DC_EX_MEM_READ_EN_IN => MEM_READ_DC, F_DC_R1_addr_IN => R_in1_address_F, 
                                            F_DC_R2_addr_IN => R_in2_address_F, F_DC_OPCODE_IN => Opcode_F, DC_EX_OPCODE_IN => Opcode_DC,
                                            STALL_OUT => STALL_OUT, PC_WRITE_OUT => PC_WRITE_OUT);
                                        

    DC_Latch_INST : Decode_Latch port map (clk=>clk, DC_R_data1_IN => r1_data, DC_R_data2_IN => r2_data,
                                            DC_R_addr1_IN =>R_Select, DC_R_addr2_IN => R_in2_address_F,
                                            DC_R_out_address_IN => R_out_address_F,
                                            DC_Opcode_IN => Opcode_F , DC_Shift_IN => shift_F, STALL_IN => STALL_OUT,
                                            DC_R_data1_OUT => R_data1_DC, DC_R_data2_OUT => R_data2_DC,
                                            DC_EX_addr1_OUT => R_in1_address_DC_EX, DC_EX_addr2_OUT => R_in2_address_DC_EX,
                                            DC_R_out_address_OUT => R_out_address_DC_EX,
                                            DC_Write_Enable_OUT => WR_Enable_DC, DC_Opcode_OUT => Opcode_DC, DC_Shift_OUT  => Shift_DC,
                                            DC_WB_Select => Select_DC, DC_MEM_READ_OUT => MEM_READ_DC, DC_Displacement_IN => F_Displacement, DC_Displacement_OUT => Displacement_DC_EX, 
                                            DC_PC_IN => Fetch_PC, DC_PC_OUT =>PC_DC_EX);
                                            

    Forwarding_Unit_INST : Forwarding_Unit port map(Forward_EX_IN => Data_EX_WB, Forward_WB_IN => WB_R_outdata_OUT, Forward_DC_data1_IN => R_data1_DC,
                                                    Forward_DC_data2_IN => R_data2_DC, Forward_DC_Rin1_IN => R_in1_address_DC_EX,
                                                    Forward_DC_Rin2_IN => R_in2_address_DC_EX, Forward_EX_Rout_IN => Data_Addr_EX_WB,
                                                    Forward_WB_Rout_IN => WB_R_outaddress_OUT, Forward_DC_Write_Enable_IN => WR_Enable_DC,
                                                    Forward_EX_Write_Enable_IN => Write_Enable_EX_WB, Forward_WB_Enable_IN => WB_EN_OUT,
                                                    data_A_OUT => Forward_ALU_data1, data_B_OUT => Forward_ALU_data2, Opcode => Opcode_DC,
                                                    PC => PC_DC_EX, Displacement =>Displacement_DC_EX);

    EX_Latch_INST : Execute_Latch port map(clk=>clk, EX_write_enable_IN => WR_Enable_DC, EX_NegativeZero_IN => Zero_Negative,
                                           EX_opcodeIn => Opcode_DC, EX_ALU_data_IN => R_data_ALU_OUT,
                                           EX_R_out_address_IN => R_out_address_DC_EX,
                                           EX_write_enable_OUT => Write_Enable_EX_WB , EX_NegativeZero_OUT => NZ, EX_opcodeOut=> Opcode_EX_WB,
                                           EX_R_out_data_OUT => Data_EX_WB, EX_R_out_address_OUT => Data_Addr_EX_WB,
                                           EX_select_IN =>Select_DC,EX_select_OUT => Select_EX, 
                                           EX_Branch_Select_IN => Branch_Sel_EX , EX_Branch_Select_OUT => branch_sel,
                                           EX_PC_IN => PC_DC_EX , EX_PC_OUT => EX_WB_PC);    

    WB_Latch_INST : Writeback_Latch port map(clk=>clk, WB_R_out_data_IN => Data_EX_WB, WB_Select_IN => Select_EX,
                                            WB_R_out_address_IN => Data_Addr_EX_WB, WB_Enable_IN => Write_Enable_EX_WB,
                                           
                                            WB_R_out_data_OUT => WB_R_outdata_OUT, WB_R_out_address_OUT => WB_R_outaddress_OUT,
                                            WB_Enable_OUT => WB_EN_OUT, INPORT => INPUT_SIGNAL,
                                            WB_PC2 => EX_WB_PC, WB_Opcode_IN => Opcode_EX_WB, WB_Opcode_OUT => WB_OP_OUT
                                           );

    ALU_INST : ALU port map(A => Forward_ALU_data1, B => Forward_ALU_data2, OpCode => OpCode_DC, Shift_value => Shift_DC,
                            C => R_data_ALU_OUT, Zero_Negative_flags => Zero_Negative);
   
    RF8_16_INST: RF8_16 port map( clk => clk, rst => rst, rd_index1 => R_Select , rd_index2 => R_in2_address_F ,
                                  rd_data1 => r1_data , rd_data2 => r2_data , wr_index => WB_R_outaddress_OUT,
                                  wr_data => WB_R_outdata_OUT, wr_enable => WB_EN_OUT);

    Fetch_INST : Fetch port map(clk  => clk, reset => rst, PC => PC_OUT, PC_Updated => PC_Updated, PC_STALL => PC_WRITE_OUT,Data_OUT => Instruction_OUT, Instruction_Register => IR,
                                branch_select => branch_sel, branch_PC => Data_EX_WB );
    
    PC_INST : Program_Counter port map(clk => clk, reset => rst, PC_IN => PC_Updated, PC_OUT => PC_OUT, DC_Opcode => Opcode_DC, DC_R7 => R_data1_DC);
    
    ROM_INST : ROM port map(clka_ROM => clk, rsta_ROM => rst, addra_ROM => PC_OUT(9 downto 1) , douta_ROM => Instruction_OUT);
    
    RAM_INST : RAM port map(clka_RAM => clk, wea_RAM => wea_RAM , addra_RAM => addra_RAM,
                            dina_RAM => dina_RAM, douta_RAM => douta_RAM, rstb_RAM => rst, addrb_RAM => addrb_RAM,
                            doutb_RAM => doutb_RAM, rsta_RAM => rst);
    
    DISP_INST : Displacement_Calculation port map(rst => rst,Displacement_L => displacementL , Displacement_S => displacementS,
                                                  Opcode => Opcode_F, Displacement_Final => F_Displacement  );

    REG_SEL_INST : Register_Select port map(rst => rst, R_IN_1 => R_in1_address_F , R_IN_2_branch => R_out_address_F, Opcode => Opcode_F ,R1_OUT =>R_Select);
    
    BR_SEL_INST : Branch_Select port map(rst => rst, Opcode => OpCode_DC, ZN_Flags => Zero_Negative, BR_Select => Branch_Sel_EX ); 

        data <= Instruction_OUT;
        ALU_DATA_OUT <= Data_EX_WB;
        read_data1 <= r1_data;
        read_data2 <= r2_data;
        read_index1 <= R_in1_address_F;
        read_index2 <= R_in2_address_F;
        data_addr_Out <= WB_R_outaddress_OUT;
        data_Out <= WB_R_outdata_OUT;
        wb_select <= Select_EX;
        
        f_pc <= Fetch_PC;
        f_opcode <=  Opcode_F;
        dc_pc <= PC_DC_EX;
        dc_displacement <= Displacement_DC_EX;
        ex_branchsel <= branch_sel;
        ex_data_out <= Data_EX_WB;
        
        writeback_data <= WB_R_outdata_OUT;
        writeback_addr <= WB_R_outaddress_OUT;
        writeback_enable <= WB_EN_OUT;
        writeback_PC2 <= EX_WB_PC;
        writeback_opcode <= WB_OP_OUT;
        
end Behavioral;