----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2024 10:42:06 AM
-- Design Name: 
-- Module Name: ClockGenerator - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ClockGenerator is
  Port (
  clk : out STD_LOGIC 
  );
end ClockGenerator;

architecture Behavioral of ClockGenerator is

begin
    process 
    begin
        clk <= '0'; --Start clock at 0
        wait for 10ns;
        clk <= '1'; --Rising edge of clock
        wait for 10ns;
    end process;
           
end Behavioral;
