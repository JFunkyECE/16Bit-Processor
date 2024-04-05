library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- this file is used to toggle branch select bit for branch instructions
-- depending on the condition code for the branch instruction the select
-- bit will be set to either 0 or 1

entity Branch_Select is
  Port ( 
        rst : in std_logic;
        Opcode : in std_logic_vector(6 downto 0);
        ZN_Flags : in std_logic_vector(1 downto 0);
  
        BR_Select: out std_logic;
        BR_Return_Clear : out std_logic
  );
end Branch_Select;

architecture Behavioral of Branch_Select is

begin

    process(Opcode, ZN_flags, rst)
    begin
        if rst = '1' then
            BR_Select <= '0';
        elsif Opcode = "1000000" or Opcode = "1000011" or Opcode = "1000110" then
            BR_Select <= '1';
        elsif Opcode  = "1000001" or Opcode = "1000100" then
            --enable if negative
            if ZN_Flags(0) = '1' then
                BR_Select <= '1';
            else
                BR_Select <= '0';
            end if;
        elsif Opcode  = "1000010" or Opcode = "1000101" then
            --enable if zero 
            if ZN_Flags(1) = '1' then
                BR_Select <= '1';
            else
                BR_Select <= '0';
            end if;
        else
            BR_Select <= '0';
        end if;
        if Opcode = "1000111" then -- if subrountine return call, clear decode only
            BR_Return_Clear <= '1';
        else
            BR_Return_Clear <= '0';
        end if;
    end process;

end Behavioral;
