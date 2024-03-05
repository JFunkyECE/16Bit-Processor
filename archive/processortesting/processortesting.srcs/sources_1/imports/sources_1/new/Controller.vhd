library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Controller is
    port ( 
    
        reset : in std_logic; --for testing new instructions 
        rst: in std_logic; --to reset register file
        clk: in std_logic;
        
        --register file signals    
        rd_index_1: in std_logic_vector(2 downto 0); 
        rd_index_2: in std_logic_vector(2 downto 0); 
        rd_data_1: out std_logic_vector(15 downto 0); 
        rd_data_2: out std_logic_vector(15 downto 0);

        --
        inport_sig : in std_logic_vector(15 downto 0);
        instruction: in std_logic_vector(15 downto 0);
        zero_negative: out std_logic_vector(1 downto 0)
    );
end Controller;
architecture Behavioral of Controller is
    
    --for state machine
    type State_Type is (I_F, DC, EX, MEM, WB, IDLE);
    signal Current_State, Next_State: State_Type;
    --signals for stage 1 to be used by stage 2
    signal OpCode_IF : std_logic_vector(6 downto 0);
    signal Rout_addr_IF: std_logic_vector(2 downto 0);
    --signals for stage 2 to be used by stage 3
    signal OpCode_DC :  std_logic_vector(6 downto 0);
    signal Rout_addr_DC:  std_logic_vector(2 downto 0);
    --signals from stage 3 to be used by stage 4
    signal OpCode_EX :  std_logic_vector(6 downto 0);
    signal Rout_addr_EX:  std_logic_vector(2 downto 0);
    --signals from stage 4 to be used by stage 5 etc.
    signal OpCode_MM :  std_logic_vector(6 downto 0);
    signal Rout_data_MM:  std_logic_vector(15 downto 0);
    signal Rout_addr_MM:  std_logic_vector(2 downto 0);--

    -- Register File component declaration
    component register_file
        port (
            rst : in std_logic; 
            clk: in std_logic;
            rd_index1: in std_logic_vector(2 downto 0); 
            rd_index2: in std_logic_vector(2 downto 0); 
            rd_data1: out std_logic_vector(15 downto 0); 
            rd_data2: out std_logic_vector(15 downto 0);
            wr_index: in std_logic_vector(2 downto 0); 
            wr_data: in std_logic_vector(15 downto 0); 
            wr_enable: in std_logic
        );
    end component;
    --
    -- Instance of the Register File
    signal wr_enable_WB: std_logic;
    signal wr_index_WB: std_logic_vector(2 downto 0);
    signal wr_data_WB: std_logic_vector(15 downto 0);
    
begin
    
    reg_file_inst: register_file
        port map (
            rst => rst, 
            clk => clk,
            rd_index1 => rd_index_1, 
            rd_index2 => rd_index_2, 
            rd_data1 => rd_data_1, 
            rd_data2 => rd_data_2,
            wr_index => wr_index_WB, 
            wr_data => wr_data_WB, 
            wr_enable => wr_enable_WB
        );

    
    process(clk)
    begin
        if reset = '1' then
            
            Current_State <= I_F; -- Reset to initial state
            Next_State <= I_F; -- Initialize next state to a known value
            
            -- Initialize all other signals to 0s
            OpCode_IF <= (others => '0');            
            Rout_addr_IF <= (others => '0');            
            OpCode_DC <= (others => '0');
            Rout_addr_DC <= (others => '0');            
            OpCode_EX <= (others => '0');
            Rout_addr_EX <= (others => '0');
            
            OpCode_MM <= (others => '0');
            Rout_data_MM <= (others => '0');
            Rout_addr_MM <= (others => '0');
            wr_enable_WB <= '0'; -- Assuming '0' is the inactive state for write enable
            wr_data_WB <= (others => '0');
            wr_index_WB <= (others => '0');
            -- Initialize all other signals to be 0s
            
        elsif falling_edge(clk) then
            
            case Current_State is
            
                when I_F =>
                
                    Next_State <= DC; -- Proceed to Decode After this stage is done
                    OpCode_IF <= instruction(15 downto 9);
                    wr_enable_WB <= '0';
                    case OpCode_IF is
                                              
                        when "0100000" | "0100001" => --IN/OUT
                            Rout_addr_IF <= instruction(8 downto 6);
                        when others => 
                    end case;
                when DC =>
                    Next_State <= EX; -- Proceed to Execute
                    OpCode_DC <= OpCode_IF;
                    -- Decode instruction and setup for execution
                    case OpCode_DC is
                                             
                        when "0100001" => --IN
                            Rout_addr_DC <= Rout_addr_IF;
                        when "0100000" => --OUT
                            --read value to signal that can be read by testbench
                        when others => 
                    end case; 
                when EX =>
                    Next_State <= MEM; -- Proceed to memory execute
                    OpCode_EX <= OpCode_DC;
                    -- Decode instruction and setup for execution
                    case OpCode_EX is
                    
                        when "0100000" | "0100001" => --IN/OUT
                            Rout_addr_EX <= Rout_addr_DC;
                        when others => 
                    end case;    
                when MEM =>
                    Next_State <= WB; -- Proceed to Write Back
                    -- Memory access logic here
                    --do nothing here until branching takes place
                    OpCode_MM <= OpCode_EX;
                    --Rout_data_MM <= Rout_data_EX;
                    Rout_addr_MM <= Rout_addr_EX;                    
                when WB =>
                    Next_State <= IDLE; 
                    
                    --any instructions that have to write back into memory exectute a write request to register files
                    case OpCode_MM is
                        when "0100001" => --IN, write to register immediate value from signal in testbench
                            wr_data_WB <= inport_sig;
                            wr_index_WB <= Rout_addr_MM;--
                            wr_enable_WB <= '1';  --ss

                        when others => 
                    end case;
                when others =>
                    Next_State <= IDLE; -- Default state                                                         
                    
            end case;
            Current_State <= Next_State; -- Update state at the end of each clock cycle
        end if;
    end process;
end Behavioral;
