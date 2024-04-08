library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Register_Select is
  Port ( 
        rst : in std_logic;
        R_IN_1 : in std_logic_vector(2 downto 0);
        R_IN_2 : in std_logic_vector(2 downto 0);
        R_dest: in std_logic_vector(2 downto 0);
        Opcode : in std_logic_vector(6 downto 0);
        
        R1_OUT : out std_logic_vector(2 downto 0);
        R2_OUT : out std_logic_vector(2 downto 0)
  );
end Register_Select;

architecture Behavioral of Register_Select is

begin

   process(R_IN_1, R_dest, Opcode, rst)
    begin
        if rst = '1' then
            R1_OUT <= R_IN_1;
            R2_OUT <= R_IN_2;
        elsif Opcode = "1000011" or Opcode = "1000100" or Opcode = "1000101" or Opcode = "1000110" then --branch instructions for RA
            R1_OUT <= R_dest;
            R2_OUT <= R_IN_1;
        elsif Opcode = "1000111" then --return from branch subroutine
            R1_OUT <= "111";
            R2_OUT <= R_IN_2;
        elsif Opcode = "0010000" then --LOAD operation
            R1_OUT <= R_dest;
            R2_OUT <= R_IN_1;
        elsif Opcode = "0010001" then --STORE operation
            R1_OUT <= R_dest;
            R2_OUT <= R_IN_1;
        elsif Opcode = "0010010" then -- LOADIMM operation
            R1_OUT <= "111";
            R2_OUT <= "000";
        elsif Opcode = "0000111" then --TEST operation
            R1_OUT <= R_dest;
            R2_OUT <= R_IN_2;
        elsif Opcode = "0100000" then
            R1_OUT <= R_dest;
            R2_OUT <= R_IN_2;
        else
            R1_OUT <= R_IN_1;
            R2_OUT <= R_IN_2;
        end if;
    end process;
end Behavioral;
