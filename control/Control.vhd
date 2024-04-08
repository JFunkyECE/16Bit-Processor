library IEEE;

use IEEE.STD_LOGIC_1164.ALL;


entity Control is
  Port (
  clk : in STD_LOGIC;
  rst : in STD_LOGIC;
  load : in STD_LOGIC;

  --inputs
  INPUT_SIGNAL : in STD_LOGIC_VECTOR(15 downto 6); --change to 15 downto 6;
  OUTPUT_SIGNAL : out STD_LOGIC;
  
  
  led_segments : out STD_LOGIC_VECTOR( 6 downto 0 );
  led_digits : out STD_LOGIC_VECTOR( 3 downto 0 );

  debug_console : in STD_LOGIC;
  board_clock: in std_logic;
 
  vga_red : out std_logic_vector( 3 downto 0 );
  vga_green : out std_logic_vector( 3 downto 0 );
  vga_blue : out std_logic_vector( 3 downto 0 );
 
  h_sync_signal : out std_logic;
  v_sync_signal : out std_logic
  
  
  );

end Control;

 

architecture Behavioral of Control is   

    --signals for fetch
    signal Opcode_F : STD_LOGIC_VECTOR(6 downto 0);
    signal R_in1_address_F : STD_LOGIC_VECTOR(2 downto 0);
    signal R_in2_address_F : STD_LOGIC_VECTOR(2 downto 0);
    signal R_out_address_F : STD_LOGIC_VECTOR(2 downto 0);
    signal shift_F : STD_LOGIC_VECTOR(3 downto 0); 
    signal F_DC_WR_ENABLE : STD_LOGIC;

    --signals for Hazard_Unit
    signal STALL_OUT : STD_LOGIC;
    signal PC_WRITE_OUT : STD_LOGIC;
    signal Hazard_F_WR_ENABLE_OUT : STD_LOGIC;

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
    signal LOAD_ENABLE_DC : STD_LOGIC;
    
    --signals for Forwarding_Unit
    signal Forward_ALU_data1 : STD_LOGIC_VECTOR (15 downto 0);
    signal Forward_ALU_data2 : STD_LOGIC_VECTOR (15 downto 0);
 
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
    signal Instruction_OUT_ROM : STD_LOGIC_VECTOR(15 downto 0);
    signal Instruction_OUT_RAM : STD_LOGIC_VECTOR(15 downto 0);
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
    signal R_Select1 : STD_LOGIC_VECTOR(2 downto 0);
    signal R_Select2 : STD_LOGIC_VECTOR(2 downto 0);
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
    
    --signals for ex latch to ram control
    signal destination_data_RAM : STD_LOGIC_VECTOR(15 downto 0);
    signal source_data_RAM : STD_LOGIC_VECTOR(15 downto 0);
    
    --signals for load immediate
    signal F_DC_IMM : STD_LOGIC_VECTOR(7 downto 0);
    signal F_DC_M1 : STD_LOGIC;
    signal DC_EX_IMM : STD_LOGIC_VECTOR(7 downto 0);
    signal DC_EX_M1 : STD_LOGIC;
    
    
    signal F_DC_INPORT : STD_LOGIC_VECTOR(15 downto 0);
    signal DC_ALU_INPORT : STD_LOGIC_VECTOR(15 downto 0);
    
    --instruction signals
    signal F_INST1 : STD_LOGIC_VECTOR(15 downto 0);
    signal DC_INST : STD_LOGIC_VECTOR(15 downto 0);
    signal EX_INST : STD_LOGIC_VECTOR(15 downto 0);
    signal WB_INST : STD_LOGIC_VECTOR(15 downto 0);
    
    --pc signals
    signal PC_FETCH : STD_LOGIC_VECTOR(15 downto 0);
    signal PC_DECODE : STD_LOGIC_VECTOR(15 downto 0);
    signal PC_EXECUTE : STD_LOGIC_VECTOR(15 downto 0);
    signal PC_WRITEBACK : STD_LOGIC_VECTOR(15 downto 0);

    --register file signals
    signal r0 : STD_LOGIC_VECTOR(15 downto 0);
    signal r1 : STD_LOGIC_VECTOR(15 downto 0);
    signal r2 : STD_LOGIC_VECTOR(15 downto 0);
    signal r3 : STD_LOGIC_VECTOR(15 downto 0);
    signal r4 : STD_LOGIC_VECTOR(15 downto 0);
    signal r5 : STD_LOGIC_VECTOR(15 downto 0);
    signal r6 : STD_LOGIC_VECTOR(15 downto 0);
    signal r7 : STD_LOGIC_VECTOR(15 downto 0);
    
    signal OP_signal_wb : STD_LOGIC_VECTOR(15 downto 0);

    COMPONENT ALU
        port(
            --clk : in STD_LOGIC;
            A : in STD_LOGIC_VECTOR(15 downto 0);
            B : in STD_LOGIC_VECTOR(15 downto 0);
            OpCode : in STD_LOGIC_VECTOR(6 downto 0);
            Shift_value : in STD_LOGIC_VECTOR(3 downto 0);
            C : out STD_LOGIC_VECTOR(15 downto 0);
            IN_PORT : in STD_LOGIC_VECTOR(15 downto 0);

            --for load immediate
            M_EX : in STD_LOGIC;
            IMM_EX : in STD_LOGIC_VECTOR(7 downto 0);
            
            
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
 
            WB_PC2 : in STD_LOGIC_VECTOR(15 downto 0);
            WB_Opcode_IN : in STD_LOGIC_VECTOR(6 downto 0);
            WB_Opcode_OUT : out STD_LOGIC_VECTOR(6 downto 0);
            
            WB_INST_IN : in STD_LOGIC_VECTOR(15 downto 0);
            WB_INST_OUT : out STD_LOGIC_VECTOR(15 downto 0);
            -- for load
            WB_LOAD_DATA : in STD_LOGIC_VECTOR(15 downto 0);
            output_port : out STD_LOGIC_VECTOR(15 downto 0);

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
            EX_NegativeZero_IN : in STD_LOGIC_VECTOR(1 downto 0);
            EX_opcodeIn : in STD_LOGIC_VECTOR(6 downto 0);
            EX_ALU_data_IN : in STD_LOGIC_VECTOR(15 downto 0);
            EX_R_out_address_IN : in STD_LOGIC_VECTOR(2 downto 0);

            --outputs
            EX_write_enable_OUT : out STD_LOGIC;
            EX_NegativeZero_OUT : out STD_LOGIC_VECTOR(1 downto 0);
            EX_opcodeOut : out STD_LOGIC_VECTOR(6 downto 0);
            EX_R_out_data_OUT : out STD_LOGIC_VECTOR(15 downto 0);
            EX_R_out_address_OUT : out  STD_LOGIC_VECTOR(2 downto 0);
            
            EX_INST_IN : in STD_LOGIC_VECTOR(15 downto 0);
            EX_INST_OUT : out STD_LOGIC_VECTOR(15 downto 0); 
            EX_PC : out STD_LOGIC_VECTOR(15 downto 0);
            
            --signals for load store
            EX_SOURCE_IN : in STD_LOGIC_VECTOR(15 downto 0);
            EX_DESTINATION_IN : in STD_LOGIC_VECTOR(15 downto 0);
            EX_SOURCE_OUT : out STD_LOGIC_VECTOR(15 downto 0);
            EX_DESTINATION_OUT : out STD_LOGIC_VECTOR(15 downto 0);
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
            branch_taken : in STD_LOGIC;
            branch_clear : in STD_LOGIC;
            --inputs
            DC_R_data1_IN : in STD_LOGIC_VECTOR(15 downto 0);
            DC_R_data2_IN : in STD_LOGIC_VECTOR(15 downto 0);
            DC_R_addr1_IN : in STD_LOGIC_VECTOR(2 downto 0);
            DC_R_addr2_IN : in STD_LOGIC_VECTOR(2 downto 0);
            DC_R_out_address_IN : in STD_LOGIC_VECTOR(2 downto 0);
            DC_Opcode_IN : in STD_LOGIC_VECTOR(6 downto 0);
            DC_Shift_IN : in STD_LOGIC_VECTOR(3 downto 0);
            STALL_IN : in STD_LOGIC; 
            
            DC_INST_IN : in STD_LOGIC_VECTOR(15 downto 0);
            DC_INST_OUT : out STD_LOGIC_VECTOR(15 downto 0);
              --outputs
            DC_R_data1_OUT : out STD_LOGIC_VECTOR(15 downto 0);
            DC_R_data2_OUT : out STD_LOGIC_VECTOR(15 downto 0);
            DC_EX_addr1_OUT : out STD_LOGIC_VECTOR(2 downto 0);
            DC_EX_addr2_OUT : out STD_LOGIC_VECTOR(2 downto 0);
            DC_R_out_address_OUT : out STD_LOGIC_VECTOR(2 downto 0);
            DC_Write_Enable_OUT : out STD_LOGIC;
            DC_LOAD_OUT : out STD_LOGIC;
            DC_Opcode_OUT : out STD_LOGIC_VECTOR(6 downto 0);
            DC_Shift_OUT : out STD_LOGIC_VECTOR(3 downto 0);
            
            --inport signals
            DC_INPORT_IN : in STD_LOGIC_VECTOR(15 downto 0);
            DC_INPORT_OUT : out STD_LOGIC_VECTOR(15 downto 0);
            
            --loadimm signals
            D_M1 : in STD_LOGIC;
            D_IMM : in STD_LOGIC_VECTOR(7 downto 0);
            D_EX_M1 : out STD_LOGIC;
            D_EX_IMM : out STD_LOGIC_VECTOR(7 downto 0);
            
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
            R_IN_2 : in std_logic_vector(2 downto 0);
            R_dest: in std_logic_vector(2 downto 0);
            Opcode : in std_logic_vector(6 downto 0);
            R1_OUT : out std_logic_vector(2 downto 0);
            R2_OUT : out std_logic_vector(2 downto 0)
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
            DC_EX_Rout_addr_IN : in STD_LOGIC_VECTOR(2 downto 0);
            DC_EX_LOAD_EN_IN : in STD_LOGIC := '0';
            REG_SELECT_DC_R1_addr_IN : in STD_LOGIC_VECTOR(2 downto 0);
            REG_SELECT_DC_R2_addr_IN : in STD_LOGIC_VECTOR(2 downto 0);
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
            rst : in STD_LOGIC;
            --inputs
            Instruction : IN STD_LOGIC_VECTOR(15 downto 0);     
            F_INST : OUT STD_LOGIC_VECTOR(15 downto 0);
            --outputs
            F_OpcodeOut : out STD_LOGIC_VECTOR(6 downto 0);
            F_R_in1_address_OUT : out STD_LOGIC_VECTOR(2 downto 0);
            F_R_in2_address_OUT : out STD_LOGIC_VECTOR(2 downto 0);
            F_R_out_address_OUT : out STD_LOGIC_VECTOR(2 downto 0);
            F_shift_OUT : out STD_LOGIC_VECTOR(3 downto 0);
            
            --new ports for inport testing
            F_INPORT_OUT : out STD_LOGIC_VECTOR(15 downto 0);      
            INPORT : IN STD_LOGIC_VECTOR(15 downto 0);
                
            --signals for load immediate
            F_IMM : out STD_LOGIC_VECTOR(7 downto 0);
            F_M1 : out STD_LOGIC; 
            
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
            Data_OUT_ROM : IN std_logic_vector(15 downto 0); 
            Data_OUT_RAM : IN std_logic_vector(15 downto 0);
            Instruction_Register : OUT std_logic_vector(15 downto 0);
            branch_select : IN std_logic;
            branch_PC : IN std_logic_vector(15 downto 0);
            PC_STALL : IN STD_LOGIC  
        );
    end COMPONENT;
    
    COMPONENT Program_Counter
        port(
            clk : IN std_logic;   
            reset : IN std_logic;
            load : IN std_logic;
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
            
            r0 : out std_logic_vector(15 downto 0); 
            r1 : out std_logic_vector(15 downto 0); 
            r2 : out std_logic_vector(15 downto 0); 
            r3 : out std_logic_vector(15 downto 0); 
            r4 : out std_logic_vector(15 downto 0); 
            r5 : out std_logic_vector(15 downto 0); 
            r6 : out std_logic_vector(15 downto 0); 
            r7 : out std_logic_vector(15 downto 0); 

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
    
    COMPONENT RAM_Control
        port(
            rst : IN std_logic;
            Opcode : IN std_logic_vector(6 downto 0);
            source_in : IN std_logic_vector(15 downto 0);
            destination_in : IN std_logic_vector(15 downto 0);
            
            write_enable_ram : OUT std_logic_vector(0 downto 0);
            addr_in_ram : OUT std_logic_vector(8 downto 0);
            data_in_ram : OUT std_logic_vector(15 downto 0)
        
        );
    end COMPONENT;
    
    
    component console is
        port (
    
    --
    -- Stage 1 Fetch
    --
            s1_pc : in STD_LOGIC_VECTOR ( 15 downto 0 );
            s1_inst : in STD_LOGIC_VECTOR ( 15 downto 0 );
    
    
    --
    -- Stage 2 Decode
    --
            s2_pc : in STD_LOGIC_VECTOR ( 15 downto 0 );
            s2_inst : in STD_LOGIC_VECTOR ( 15 downto 0 );
    
            s2_reg_a : in STD_LOGIC_VECTOR( 2 downto 0 );
            s2_reg_b : in STD_LOGIC_VECTOR( 2 downto 0 );
            s2_reg_c : in STD_LOGIC_VECTOR( 2 downto 0 );
    
            s2_reg_a_data : in STD_LOGIC_VECTOR( 15 downto 0 );
            s2_reg_b_data : in STD_LOGIC_VECTOR( 15 downto 0 );
            s2_reg_c_data : in STD_LOGIC_VECTOR( 15 downto 0 );
    
            s2_immediate : in STD_LOGIC_VECTOR( 15 downto 0 );
    
    
    --
    -- Stage 3 Execute
    --
            s3_pc : in STD_LOGIC_VECTOR ( 15 downto 0 );
            s3_inst : in STD_LOGIC_VECTOR ( 15 downto 0 );
    
            s3_reg_a : in STD_LOGIC_VECTOR( 2 downto 0 );
            s3_reg_b : in STD_LOGIC_VECTOR( 2 downto 0 );
            s3_reg_c : in STD_LOGIC_VECTOR( 2 downto 0 );
    
            s3_reg_a_data : in STD_LOGIC_VECTOR( 15 downto 0 );
            s3_reg_b_data : in STD_LOGIC_VECTOR( 15 downto 0 );
            s3_reg_c_data : in STD_LOGIC_VECTOR( 15 downto 0 );
    
            s3_immediate : in STD_LOGIC_VECTOR( 15 downto 0 );
    
    --
    -- Branch and memory operation
    --
            s3_r_wb : in STD_LOGIC;
            s3_r_wb_data : in STD_LOGIC_VECTOR( 15 downto 0 );
    
            s3_br_wb : in STD_LOGIC;
            s3_br_wb_address : in STD_LOGIC_VECTOR( 15 downto 0 );
    
            s3_mr_wr : in STD_LOGIC;
            s3_mr_wr_address : in STD_LOGIC_VECTOR( 15 downto 0 );
            s3_mr_wr_data : in STD_LOGIC_VECTOR( 15 downto 0 );
    
            s3_mr_rd : in STD_LOGIC;
            s3_mr_rd_address : in STD_LOGIC_VECTOR( 15 downto 0 );
    
    --
    -- Stage 4 Memory
    --
            s4_pc : in STD_LOGIC_VECTOR( 15 downto 0 );
            s4_inst : in STD_LOGIC_VECTOR( 15 downto 0 );
    
            s4_reg_a : in STD_LOGIC_VECTOR( 2 downto 0 );
    
            s4_r_wb : in STD_LOGIC;
            s4_r_wb_data : in STD_LOGIC_VECTOR( 15 downto 0 );
    
    --
    -- CPU registers
    --
    
            register_0 : in STD_LOGIC_VECTOR ( 15 downto 0 );
            register_1 : in STD_LOGIC_VECTOR ( 15 downto 0 );
            register_2 : in STD_LOGIC_VECTOR ( 15 downto 0 );
            register_3 : in STD_LOGIC_VECTOR ( 15 downto 0 );
            register_4 : in STD_LOGIC_VECTOR ( 15 downto 0 );
            register_5 : in STD_LOGIC_VECTOR ( 15 downto 0 );
            register_6 : in STD_LOGIC_VECTOR ( 15 downto 0 );
            register_7 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    
    --
    -- CPU registers overflow flags
    --
            register_0_of : in STD_LOGIC;
            register_1_of : in STD_LOGIC;
            register_2_of : in STD_LOGIC;
            register_3_of : in STD_LOGIC;
            register_4_of : in STD_LOGIC;
            register_5_of : in STD_LOGIC;
            register_6_of : in STD_LOGIC;
            register_7_of : in STD_LOGIC;
    
    --
    -- CPU Flags
    --
            zero_flag : in STD_LOGIC;
            negative_flag : in STD_LOGIC;
            overflow_flag : in STD_LOGIC;
    
    --
    -- Debug screen enable
    --
            debug : in STD_LOGIC;
    
    --
    -- Text console display memory access signals ( clk is the processor clock )
    --
            addr_write : in  STD_LOGIC_VECTOR (15 downto 0);
            clk : in  STD_LOGIC;
            data_in : in  STD_LOGIC_VECTOR (15 downto 0);
            en_write : in  STD_LOGIC;
    
    --
    -- Video related signals
    --
            board_clock : in STD_LOGIC;
            v_sync_signal : out STD_LOGIC;
            h_sync_signal : out STD_LOGIC;
            vga_red : out STD_LOGIC_VECTOR( 3 downto 0 );
            vga_green : out STD_LOGIC_VECTOR( 3 downto 0 );
            vga_blue : out STD_LOGIC_VECTOR( 3 downto 0 )
    
        );
    end component;
   
    component led_display is
        Port (
    
            addr_write : in  STD_LOGIC_VECTOR (15 downto 0);
            clk : in  STD_LOGIC;
            data_in : in  STD_LOGIC_VECTOR (15 downto 0);
            en_write : in  STD_LOGIC;
    
            board_clock : in STD_LOGIC;
            led_segments : out STD_LOGIC_VECTOR( 6 downto 0 );
            led_digits : out STD_LOGIC_VECTOR( 3 downto 0 )
        );
    end component;

begin    

    F_Latch_INST: Fetch_Latch port map(clk=>clk, rst => rst,Instruction => IR, F_OpcodeOut => Opcode_F,
                                       F_R_in1_address_OUT => R_in1_address_F, F_R_in2_address_OUT => R_in2_address_F,
                                       F_R_out_address_OUT => R_out_address_F, F_shift_OUT => shift_F,
                                       PC_IN => PC_OUT, F_displacementl => displacementL, F_displacements => displacementS , F_PC => Fetch_PC,
                                       F_IMM => F_DC_IMM, F_M1=> F_DC_M1, F_INPORT_OUT=> F_DC_INPORT,
                                       INPORT(15 downto 6) => INPUT_SIGNAL, 
                                       INPORT(5 downto 0) => "000000",
                                        F_INST => F_INST1 ); 
                                       
   Hazard_Unit_INST : Hazard_Unit port map(rst => rst, DC_EX_Rout_addr_IN => R_out_address_DC_EX, DC_EX_LOAD_EN_IN => LOAD_ENABLE_DC, REG_SELECT_DC_R1_addr_IN => R_Select1, 
                                           REG_SELECT_DC_R2_addr_IN => R_Select2, F_DC_OPCODE_IN => Opcode_F, DC_EX_OPCODE_IN => Opcode_DC,
                                           STALL_OUT => STALL_OUT, PC_WRITE_OUT => PC_WRITE_OUT);
                                        

    DC_Latch_INST : Decode_Latch port map (clk=>clk, DC_R_data1_IN  => r1_data, DC_R_data2_IN => r2_data,
                                            DC_R_addr1_IN =>R_Select1, DC_R_addr2_IN => R_Select2,
                                            DC_R_out_address_IN => R_out_address_F,
                                            DC_Opcode_IN => Opcode_F , DC_Shift_IN => shift_F,
                                            DC_R_data1_OUT => R_data1_DC, DC_R_data2_OUT => R_data2_DC,
                                            DC_EX_addr1_OUT => R_in1_address_DC_EX, DC_EX_addr2_OUT => R_in2_address_DC_EX,
                                            DC_R_out_address_OUT => R_out_address_DC_EX,
                                            DC_Write_Enable_OUT => WR_Enable_DC, DC_Opcode_OUT => Opcode_DC, DC_Shift_OUT  => Shift_DC,
                                            DC_LOAD_OUT => LOAD_ENABLE_DC, STALL_IN => STALL_OUT,
                                            DC_Displacement_IN => F_Displacement, DC_Displacement_OUT => Displacement_DC_EX, 
                                            DC_PC_IN => Fetch_PC, DC_PC_OUT =>PC_DC_EX, D_M1=> F_DC_M1,  D_IMM => F_DC_IMM, 
                                            D_EX_M1 => DC_EX_M1, D_EX_IMM =>DC_EX_IMM, branch_taken => branch_sel,
                                            DC_INPORT_IN => F_DC_INPORT, DC_INPORT_OUT => DC_ALU_INPORT,
                                            DC_INST_IN => F_INST1, DC_INST_OUT => DC_INST, branch_clear => Branch_Sel_EX);
                                            

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
                                           EX_Branch_Select_IN => Branch_Sel_EX , EX_Branch_Select_OUT => branch_sel,
                                           EX_PC_IN => PC_DC_EX , EX_PC_OUT => EX_WB_PC, EX_SOURCE_IN => Forward_ALU_data2,
                                           EX_DESTINATION_IN => Forward_ALU_data1, EX_SOURCE_OUT => source_data_RAM , EX_DESTINATION_OUT => destination_data_RAM,
                                           EX_INST_IN => DC_INST, EX_INST_OUT => EX_INST, EX_PC => PC_EXECUTE);    

    WB_Latch_INST : Writeback_Latch port map(clk=>clk, WB_R_out_data_IN => Data_EX_WB,
                                            WB_R_out_address_IN => Data_Addr_EX_WB, WB_Enable_IN => Write_Enable_EX_WB,
                                            WB_R_out_data_OUT => WB_R_outdata_OUT, WB_R_out_address_OUT => WB_R_outaddress_OUT,
                                            WB_Enable_OUT => WB_EN_OUT,
                                            WB_PC2 => EX_WB_PC, WB_Opcode_IN => Opcode_EX_WB, WB_Opcode_OUT => WB_OP_OUT,
                                            WB_LOAD_DATA => douta_RAM, WB_INST_IN => EX_INST , WB_INST_OUT => WB_INST,
                                            output_port => OP_signal_wb);

    ALU_INST : ALU port map(A => Forward_ALU_data1, B => Forward_ALU_data2, OpCode => OpCode_DC, Shift_value => Shift_DC,
                            C => R_data_ALU_OUT, Zero_Negative_flags => Zero_Negative, M_EX =>DC_EX_M1 ,IMM_EX=>DC_EX_IMM,
                            IN_PORT =>  DC_ALU_INPORT);
   
    RF8_16_INST: RF8_16 port map( clk => clk, rst => rst, rd_index1 => R_Select1 , rd_index2 => R_Select2,
                                  rd_data1 => r1_data , rd_data2 => r2_data , wr_index => WB_R_outaddress_OUT,
                                  wr_data => WB_R_outdata_OUT, wr_enable => WB_EN_OUT, r0 => r0, 
                                  r1 => r1, r2 => r2, r3 => r3, r4 => r4, r5 => r5, r6 => r6, r7 => r7);

    Fetch_INST : Fetch port map(clk  => clk, reset => rst, PC => PC_OUT, PC_Updated => PC_Updated, Data_OUT_ROM => Instruction_OUT_ROM, Instruction_Register => IR,
                                branch_select => branch_sel, branch_PC => Data_EX_WB, PC_STALL =>PC_WRITE_OUT, Data_OUT_RAM => Instruction_OUT_RAM);
    
    PC_INST : Program_Counter port map(clk => clk, reset => rst, PC_IN => PC_Updated, PC_OUT => PC_OUT, load => load);
    
    ROM_INST : ROM port map(clka_ROM => clk, rsta_ROM => rst, addra_ROM => PC_OUT(9 downto 1) , douta_ROM => Instruction_OUT_ROM);
    
    RAM_INST : RAM port map(clka_RAM => clk, wea_RAM => wea_RAM , addra_RAM => addra_RAM,
                            dina_RAM => dina_RAM, douta_RAM => douta_RAM, rstb_RAM => rst, addrb_RAM => PC_OUT(9 downto 1),
                            doutb_RAM => Instruction_OUT_RAM, rsta_RAM => rst);
    
    DISP_INST : Displacement_Calculation port map(rst => rst,Displacement_L => displacementL , Displacement_S => displacementS,
                                                  Opcode => Opcode_F, Displacement_Final => F_Displacement  );

    REG_SEL_INST : Register_Select port map(rst => rst, R_IN_1 => R_in1_address_F , R_IN_2 => R_in2_address_F ,R_dest => R_out_address_F, Opcode => Opcode_F ,R1_OUT =>R_Select1,
                                            R2_OUT => R_Select2);
    
    BR_SEL_INST : Branch_Select port map(rst => rst, Opcode => OpCode_DC, ZN_Flags => Zero_Negative, BR_Select => Branch_Sel_EX); 

    RAM_CTRL_INST : RAM_Control port map(rst => rst, Opcode => Opcode_EX_WB, source_in => source_data_RAM , destination_in => destination_data_RAM , write_enable_ram => wea_RAM, 
                                         addr_in_ram => addra_RAM,data_in_ram => dina_RAM );

 
         
        
     console_display : console port map(
        --
        --
        -- Stage 1 Fetch
        --
            s1_pc => PC_OUT,
            s1_inst => F_INST1 ,
        
        --
        -- Stage 2 Decode
        --
        
            s2_pc => PC_DC_EX,
            s2_inst => DC_INST,
        
            s2_reg_a => R_out_address_DC_EX,
            s2_reg_b => R_in1_address_DC_EX,
            s2_reg_c => R_in2_address_DC_EX,
        
            s2_reg_a_data => x"0000",
            s2_reg_b_data => R_data1_DC,
            s2_reg_c_data => R_data2_DC,
            s2_immediate => x"0000" ,
        
        --
        -- Stage 3 Execute
        --
        
            s3_pc => PC_EXECUTE,
            s3_inst => EX_INST,
        
            s3_reg_a => Data_Addr_EX_WB,
            s3_reg_b => "000",
            s3_reg_c => "000",
        
            s3_reg_a_data => Data_EX_WB,
            s3_reg_b_data => Forward_ALU_data1,
            s3_reg_c_data => Forward_ALU_data2,
            s3_immediate => x"0000",
        
            s3_r_wb => '0',
            s3_r_wb_data => x"0000",
        
            s3_br_wb => '0',
            s3_br_wb_address => x"0000",
        
            s3_mr_wr => '0',
            s3_mr_wr_address => x"0000",
            s3_mr_wr_data => x"0000",
        
            s3_mr_rd => '0',
            s3_mr_rd_address => x"0000",
        
        --
        -- Stage 4 Memory
        --
        
            s4_pc => x"0000",
            s4_inst => WB_INST,
            s4_reg_a => WB_R_outaddress_OUT,
            s4_r_wb => WB_EN_OUT,
            s4_r_wb_data => WB_R_outdata_OUT,
        
        --
        -- CPU registers
        --
        
            register_0 => r0,
            register_1 => r1,
            register_2 => r2,
            register_3 => r3,
            register_4 => r4,
            register_5 => r5,
            register_6 => r6,
            register_7 => r7,
        
            register_0_of => '0',
            register_1_of => '0',
            register_2_of => '0',
            register_3_of => '0',
            register_4_of => '0',
            register_5_of => '0',
            register_6_of => '0',
            register_7_of => '0',
        
        --
        -- CPU Flags
        --
            zero_flag => Zero_Negative(1),
            negative_flag => Zero_Negative(0),
            overflow_flag => '0',
        
        --
        -- Debug screen enable
        --
            debug => debug_console,
        
        --
        -- Text console display memory access signals ( clk is the processor clock )
        --
        
            clk => '0',
            addr_write => x"0000",
            data_in => x"0000",
            en_write => '0',
        
        --
        -- Video related signals
        --
        
            board_clock => board_clock,
            h_sync_signal => h_sync_signal,
            v_sync_signal => v_sync_signal,
            vga_red => vga_red,
            vga_green => vga_green,
            vga_blue => vga_blue
        );
        
        
     led_display_memory : led_display
     port map (
        
                addr_write => destination_data_RAM,
                clk => clk,
                data_in => douta_RAM ,
                en_write => wea_RAM(0), --connect to ram enable 
                board_clock => board_clock,
                led_segments => led_segments,
                led_digits => led_digits
            );
   
   
     OUTPUT_SIGNAL <= OP_signal_wb(0);
   
end Behavioral;