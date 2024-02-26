--purpose of this file is to control the flow of data for each of the five stages


--Stage 1: Instruction Fetch, use new PC value to go to memory and get next instruction, put in IR
variables required:
Clk - to control flow of stages
PC - program counter to store current instruction location
IR - holds current instruction

--Stage 2: Decode/Register Fetch, Using decoded instruction, grab necessary operands from register file or put immediate next latch
variables required:
3 register locations RA, RB, RC --feed into reg file to obtain RD1 and RD2
Opcode
RD1 and RD2 for alu operations
feed output register address to ID/EX latch, EX/MEM latch, MEMWB latch


--Stage 3: Execute, Run ALU operation if necessary, or load immediate into a register
variables required:
2 inputs  RD1 and RD2
1 output 32 bit sign extended RC
condition code variable for Zero and Negative

--Stage 4: Memory Access, write to memory if necessary.



--Stage 5: Writeback, write into register file is necessary
variables required:
Take RC and write into register file

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Controller is
--  Port ( );
end Controller;

architecture Behavioral of Controller is

begin


end Behavioral;
