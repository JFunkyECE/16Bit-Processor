library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- For signed arithmetic

package AddSub is
    -- Function for addition
    function add1(a, b: signed(15 downto 0)) return signed;
    -- Function for subtraction
    function subtract1(a, b: signed(15 downto 0)) return signed;
    -- Add more function declarations as needed
end package AddSub;

package body AddSub is
    function add1(a, b: signed(15 downto 0)) return signed is
    begin
        return a + b;
    end function add1;

    function subtract1(a, b: signed(15 downto 0)) return signed is
    begin
        return a - b;
    end function subtract1;

    -- Implement other functions here
end package body AddSub;