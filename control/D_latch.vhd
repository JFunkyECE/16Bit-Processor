----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2024 10:33:20 AM
-- Design Name: 
-- Module Name: D_latch - Behavioral
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

entity D_latch is
  Port ( 
  clk : in STD_LOGIC;
  D : in STD_LOGIC_VECTOR(15 downto 0);
  D1 : in STD_LOGIC_VECTOR(15 downto 0);
  Q : out STD_LOGIC_VECTOR(15 downto 0);
  Q1 : out STD_LOGIC_VECTOR(15 downto 0)
  );
end D_latch;

architecture Behavioral of D_latch is

begin
    process(clk,D)
    begin
        if rising_edge(clk) then
            Q <= D;
            Q1 <= D1;
        end if;
        end process;


end Behavioral;
