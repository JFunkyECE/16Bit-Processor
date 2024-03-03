
--purpose of this file is to control the flow of data for each of the five stages

--Stage 1: Instruction Fetch, use new PC value to go to memory and get next instruction, put in IR
--Stage 2: Decode/Register Fetch, Using decoded instruction, grab necessary operands from register file or put immediate next latch
--Stage 3: Execute, Run ALU operation if necessary, or load immediate into a register
--Stage 4: Memory Access, write to memory if necessary
--Stage 5: Writeback, write into register file is necessary

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Controller is
    port ( 
    
        rst : in std_logic; 
        clk: in std_logic;
        --register file signals    
        --read signals
        rd_index1: in std_logic_vector(2 downto 0); 
        rd_index2: in std_logic_vector(2 downto 0); 
        rd_data1: out std_logic_vector(15 downto 0); 
        rd_data2: out std_logic_vector(15 downto 0);
        --write signals
        wr_index: in std_logic_vector(2 downto 0); 
        wr_data: in std_logic_vector(15 downto 0); 
        wr_enable: in std_logic;
        
        instruction: in std_logic_vector(15 downto 0);
        zero_negative: out std_logic_vector(1 downto 0)
    );
end Controller;

architecture Behavioral of Controller is
    
    --for state machine
    type State_Type is (I_F, DC, EX, MEM, WB);
    signal Current_State, Next_State: State_Type;

    -- Register File component declaration
    component RF8_16
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

    -- Instance of the Register File
    signal rf_rd_data1: std_logic_vector(15 downto 0);
    signal rf_rd_data2: std_logic_vector(15 downto 0);
    
    component ALU
        port(
            A : in STD_LOGIC_VECTOR(15 downto 0);
            B : in STD_LOGIC_VECTOR(15 downto 0);
            OpCode : in STD_LOGIC_VECTOR(6 downto 0);
            C : out STD_LOGIC_VECTOR(15 downto 0);
            Shift_value : in STD_LOGIC_VECTOR(3 downto 0);
            Zero_Negative_flags : out STD_LOGIC_VECTOR(1 downto 0)
        );
    end component;
    
    signal alu_A, alu_B, alu_C: std_logic_vector(15 downto 0);
    signal alu_Shift_value: std_logic_vector(3 downto 0);
    
begin
    
    reg_file_inst: RF8_16
        port map (
            rst => rst, 
            clk => clk,
            rd_index1 => rd_index1, 
            rd_index2 => rd_index2, 
            rd_data1 => rf_rd_data1, 
            rd_data2 => rf_rd_data2,
            wr_index => wr_index, 
            wr_data => wr_data, 
            wr_enable => wr_enable
        );

    -- ALU instantiation
    alu_inst: ALU
        port map (
            A => alu_A,
            B => alu_B,
            OpCode => instruction(15 downto 9),
            C => alu_C,
            Shift_value => alu_Shift_value,
            Zero_Negative_flags => zero_negative
        );
        
    rd_data1 <= rf_rd_data1;
    rd_data2 <= rf_rd_data2;
    Current_State <= I_F;
    Next_State <= I_F;
    process(clk, rst)
    begin
        if rst = '1' then
            Current_State <= I_F; -- Reset to initial state
            -- Initialize other signals as needed
        elsif falling_edge(clk) then
            case Current_State is
                when I_F =>
                    Next_State <= DC; -- Proceed to Decode
                    -- Fetch instruction logic here
                when DC =>
                    Next_State <= EX; -- Proceed to Execute
                    -- Decode instruction and setup for execution
                when EX =>
                    Next_State <= MEM; -- Proceed to Memory Access
                    -- Execute instruction logic here
                when MEM =>
                    Next_State <= WB; -- Proceed to Write Back
                    -- Memory access logic here
                when WB =>
                    Next_State <= I_F; -- Loop back to Fetch
                    -- Write back logic here
                when others =>
                    Next_State <= I_F; -- Default state
            end case;
            Current_State <= Next_State; -- Update state at the end of each clock cycle
        end if;
    end process;
end Behavioral;
