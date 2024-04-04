library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- in the case of opcodes 67 to 70 the branch needs to calcluate the new address 
-- with Ra, so need to read that data in from the register file

-- this connects between the fetch latch and the register file input address port

entity Register_Select is
  Port ( 
        rst : in std_logic;
        R_IN_1 : in std_logic_vector(2 downto 0);
        R_IN_2_branch: in std_logic_vector(2 downto 0);
        Opcode : in std_logic_vector(6 downto 0);
        
        R1_OUT : out std_logic_vector(2 downto 0)
  
  );
end Register_Select;

architecture Behavioral of Register_Select is

begin

    process(R_IN_1, R_IN_2_branch, Opcode, rst)
    begin
        if rst = '1' then
            R1_OUT <= R_IN_1;
        elsif Opcode = "1000011" or Opcode = "1000100" or Opcode = "1000101" or Opcode = "1000110" then
            R1_OUT <= R_IN_2_branch;
        elsif Opcode = "1000111" then
            R1_OUT <= "111";
        else
            R1_OUT <= R_IN_1;
        end if;
    end process;
end Behavioral;
