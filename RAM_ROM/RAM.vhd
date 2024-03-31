library IEEE;
Library xpm;
use xpm.vcomponents.all;
use IEEE.STD_LOGIC_1164.ALL;



entity RAM is
  Port ( 
    clka : IN STD_LOGIC;
    rsta : IN STD_LOGIC;
    ena  : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 downto 0);      
    addra : IN STD_LOGIC_VECTOR(9 downto 0);
    dina  : IN STD_LOGIC_VECTOR(15 downto 0);
    douta : OUT STD_LOGIC_VECTOR(15 downto 0);
      -- Port B module ports
    rstb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(9 downto 0);
    doutb : OUT STD_LOGIC_VECTOR(15 downto 0)
  
  
  );
end RAM;

architecture Behavioral of RAM is
begin

xpm_memory_dpdistram_inst : xpm_memory_dpdistram
  generic map (

    -- Common module generics
    MEMORY_SIZE             => 16384,           --positive integer
    CLOCKING_MODE           => "common_clock", --string; "common_clock", "independent_clock" 
    MEMORY_INIT_FILE        => "mem.mem",         --string; "none" or "<filename>.mem" 
    MEMORY_INIT_PARAM       => "",             --string;
    USE_MEM_INIT            => 1,              --integer; 0,1
    MESSAGE_CONTROL         => 0,              --integer; 0,1
    USE_EMBEDDED_CONSTRAINT => 0,              --integer: 0,1
    MEMORY_OPTIMIZATION     => "true",          --string; "true", "false" 

    -- Port A module generics
    WRITE_DATA_WIDTH_A      => 16,             --positive integer
    READ_DATA_WIDTH_A       => 16,             --positive integer
    BYTE_WRITE_WIDTH_A      => 16,             --integer; 8, 9, or WRITE_DATA_WIDTH_A value
    ADDR_WIDTH_A            => 10,              --positive integer
    READ_RESET_VALUE_A      => "0",            --string
    READ_LATENCY_A          => 0,              --non-negative integer

    -- Port B module generics
    READ_DATA_WIDTH_B       => 16,             --positive integer
    ADDR_WIDTH_B            => 10,              --positive integer
    READ_RESET_VALUE_B      => "0",            --string
    READ_LATENCY_B          => 0               --non-negative integer
  )
  port map (

    -- Port A module ports
    clka                    => clka,
    rsta                    => rsta,
    ena                     => ena,
    regcea                  => '1',   --do not change
    wea                     => wea,
    addra                   => addra,
    dina                    => dina,
    douta                   => douta,

    -- Port B module ports
    clkb                    => clka,
    rstb                    => rstb,
    enb                     => enb,
    regceb                  => '1',   --do not change
    addrb                   => addrb,
    doutb                   => doutb
  );
	
				


end Behavioral;
