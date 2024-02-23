
--purpose of this file is to control the flow of data for each of the five stages

--Stage 1: Instruction Fetch, use new PC value to go to memory and get next instruction, put in IR
--Stage 2: Decode/Register Fetch, Using decoded instruction, grab necessary operands from register file or put immediate next latch
--Stage 3: Execute, Run ALU operation if necessary, or load immediate into a register
--Stage 4: Memory Access, write to memory if necessary
--Stage 5: Writeback, write into register file is necessary


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Controller is
--  Port ( );
end Controller;

architecture Behavioral of Controller is

begin


end Behavioral;
