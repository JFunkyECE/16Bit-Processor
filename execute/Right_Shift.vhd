library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Right_Shift is
    Port (
        Data_in : in STD_LOGIC_VECTOR(15 downto 0); -- Input data to be shifted
        Shift_amount : in STD_LOGIC_VECTOR(3 downto 0); -- Amount to shift the data
        Data_out : out STD_LOGIC_VECTOR(15 downto 0) -- Result of the shift operation
    );
end Right_Shift;

architecture Behavioral of Right_Shift is
    -- Intermediate signals for each stage of the shifting process
    signal stage1, stage2, stage3, stage4: STD_LOGIC_VECTOR(15 downto 0);
    
    -- 2-to-1 Multiplexor function
    function mux2to1(input1, input2: STD_LOGIC; select1: STD_LOGIC) return STD_LOGIC is 
    begin
        if select1 = '1' then
            return input2; -- If select is 1, choose input2
        else
            return input1; -- Otherwise, choose input1
        end if;
    end function;
    
begin

    --stage 1 for 8-bit shifting
    stage1(0) <= mux2to1(Data_in(0),Data_in(8),Shift_amount(3));
    stage1(1) <= mux2to1(Data_in(1),Data_in(9),Shift_amount(3));
    stage1(2) <= mux2to1(Data_in(2),Data_in(10),Shift_amount(3));
    stage1(3) <= mux2to1(Data_in(3),Data_in(11),Shift_amount(3));
    stage1(4) <= mux2to1(Data_in(4),Data_in(12),Shift_amount(3));
    stage1(5) <= mux2to1(Data_in(5),Data_in(13),Shift_amount(3));
    stage1(6) <= mux2to1(Data_in(6),Data_in(14),Shift_amount(3));
    stage1(7) <= mux2to1(Data_in(7),Data_in(15),Shift_amount(3));
    stage1(8) <= mux2to1(Data_in(8),'0',Shift_amount(3));
    stage1(9) <= mux2to1(Data_in(9),'0',Shift_amount(3));
    stage1(10) <= mux2to1(Data_in(10),'0',Shift_amount(3));
    stage1(11) <= mux2to1(Data_in(11),'0',Shift_amount(3));
    stage1(12) <= mux2to1(Data_in(12),'0',Shift_amount(3));
    stage1(13) <= mux2to1(Data_in(13),'0',Shift_amount(3));
    stage1(14) <= mux2to1(Data_in(14),'0',Shift_amount(3));
    stage1(15) <= mux2to1(Data_in(15),'0',Shift_amount(3));
    
    --stage 2 for 4-bit shifting
    stage2(0) <= mux2to1(stage1(0),stage1(4),Shift_amount(2));
    stage2(1) <= mux2to1(stage1(1),stage1(5),Shift_amount(2));
    stage2(2) <= mux2to1(stage1(2),stage1(6),Shift_amount(2));
    stage2(3) <= mux2to1(stage1(3),stage1(7),Shift_amount(2));
    stage2(4) <= mux2to1(stage1(4),stage1(8),Shift_amount(2));
    stage2(5) <= mux2to1(stage1(5),stage1(9),Shift_amount(2));
    stage2(6) <= mux2to1(stage1(6),stage1(10),Shift_amount(2));
    stage2(7) <= mux2to1(stage1(7),stage1(11),Shift_amount(2));
    stage2(8) <= mux2to1(stage1(8),stage1(12),Shift_amount(2));
    stage2(9) <= mux2to1(stage1(9),stage1(13),Shift_amount(2));
    stage2(10) <= mux2to1(stage1(10),stage1(14),Shift_amount(2));
    stage2(11) <= mux2to1(stage1(11),stage1(15),Shift_amount(2));
    stage2(12) <= mux2to1(stage1(12),'0',Shift_amount(2));
    stage2(13) <= mux2to1(stage1(13),'0',Shift_amount(2));
    stage2(14) <= mux2to1(stage1(14),'0',Shift_amount(2));
    stage2(15) <= mux2to1(stage1(15),'0',Shift_amount(2));
    
    --stage 3 for 2-bit shifting
    stage3(0) <= mux2to1(stage2(0),stage2(2),Shift_amount(1));
    stage3(1) <= mux2to1(stage2(1),stage2(3),Shift_amount(1));
    stage3(2) <= mux2to1(stage2(2),stage2(4),Shift_amount(1));
    stage3(3) <= mux2to1(stage2(3),stage2(5),Shift_amount(1));
    stage3(4) <= mux2to1(stage2(4),stage2(6),Shift_amount(1));
    stage3(5) <= mux2to1(stage2(5),stage2(7),Shift_amount(1));
    stage3(6) <= mux2to1(stage2(6),stage2(8),Shift_amount(1));
    stage3(7) <= mux2to1(stage2(7),stage2(9),Shift_amount(1));
    stage3(8) <= mux2to1(stage2(8),stage2(10),Shift_amount(1));
    stage3(9) <= mux2to1(stage2(9),stage2(11),Shift_amount(1));
    stage3(10) <= mux2to1(stage2(10),stage2(12),Shift_amount(1));
    stage3(11) <= mux2to1(stage2(11),stage2(13),Shift_amount(1));
    stage3(12) <= mux2to1(stage2(12),stage2(14),Shift_amount(1));
    stage3(13) <= mux2to1(stage2(13),stage2(15),Shift_amount(1));
    stage3(14) <= mux2to1(stage2(14),'0',Shift_amount(1));
    stage3(15) <= mux2to1(stage2(15),'0',Shift_amount(1));
    
    
    --stage 4 for 1-bit shifting
    stage4(0) <= mux2to1(stage3(0), stage3(1), Shift_amount(0));
    stage4(1) <= mux2to1(stage3(1), stage3(2), Shift_amount(0));
    stage4(2) <= mux2to1(stage3(2), stage3(3), Shift_amount(0));
    stage4(3) <= mux2to1(stage3(3), stage3(4), Shift_amount(0));
    stage4(4) <= mux2to1(stage3(4), stage3(5), Shift_amount(0));
    stage4(5) <= mux2to1(stage3(5), stage3(6), Shift_amount(0));
    stage4(6) <= mux2to1(stage3(6), stage3(7), Shift_amount(0));
    stage4(7) <= mux2to1(stage3(7), stage3(8), Shift_amount(0));
    stage4(8) <= mux2to1(stage3(8), stage3(9), Shift_amount(0));
    stage4(9) <= mux2to1(stage3(9), stage3(10), Shift_amount(0));
    stage4(10) <= mux2to1(stage3(10), stage3(11), Shift_amount(0));
    stage4(11) <= mux2to1(stage3(11), stage3(12), Shift_amount(0));
    stage4(12) <= mux2to1(stage3(12), stage3(13), Shift_amount(0));
    stage4(13) <= mux2to1(stage3(13), stage3(14), Shift_amount(0));
    stage4(14) <= mux2to1(stage3(14), stage3(15), Shift_amount(0));
    stage4(15) <= mux2to1(stage3(15), '0', Shift_amount(0));
    
    -- Output assignment
    Data_out <= stage4;
        
end Behavioral;