library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Depending on a load or store instructions uses proper source for addressing and data ports of the RAM

entity RAM_Control is 
  Port ( 
    rst : IN std_logic;
    Opcode : IN std_logic_vector(6 downto 0);
    source_in : IN std_logic_vector(15 downto 0);
    destination_in : IN std_logic_vector(15 downto 0);
    
    write_enable_ram : OUT std_logic_vector(0 downto 0);
    addr_in_ram : OUT std_logic_vector(8 downto 0);
    data_in_ram : OUT std_logic_vector(15 downto 0);
    
    dipswitch : out std_logic
  );
end RAM_Control;

architecture Behavioral of RAM_Control is

begin

    process(rst, Opcode, source_in, destination_in)
    begin 
        if rst = '1' then
            write_enable_ram <= "0";
            addr_in_ram <= "000000000";
            data_in_ram <= X"0000";
            dipswitch <= '0';
        elsif Opcode = "0010000" then --LOAD 
        
            if source_in = x"FFF0" then
                dipswitch <= '1';
                write_enable_ram <= "0";
                addr_in_ram <= source_in(9 downto 1); -- ignore lsb
            else
                  write_enable_ram <= "0";
                  addr_in_ram <= source_in(9 downto 1); -- ignore lsb
                  dipswitch <= '0';
            end if;
        elsif Opcode = "0010001" then --STORE
            write_enable_ram <= "1";
            addr_in_ram <= destination_in(9 downto 1);   --ignore lsb
            data_in_ram <= source_in;
            dipswitch <= '0';
        else
            write_enable_ram <= "0"; 
            dipswitch <= '0';
            
        end if;
    end process;

end Behavioral;
