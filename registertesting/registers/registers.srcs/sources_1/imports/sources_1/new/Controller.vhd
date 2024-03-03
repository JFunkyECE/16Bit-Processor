
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
end Controller;

architecture Behavioral of Controller is

    -- Register File component declaration
    component register_file
        port(
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

begin

    -- Register File instantiation
    reg_file_inst: register_file
        port map (
            rst => rst, 
            clk => clk,
            rd_index1 => rd_index1, 
            rd_index2 => rd_index2, 
            rd_data1 => rf_rd_data1, -- Connect to internal signals if needed
            rd_data2 => rf_rd_data2, -- Connect to internal signals if needed
            wr_index => wr_index, 
            wr_data => wr_data, 
            wr_enable => wr_enable
        );

    -- Connecting internal signals to output ports, if direct connection needed
    rd_data1 <= rf_rd_data1;
    rd_data2 <= rf_rd_data2;

end Behavioral;
