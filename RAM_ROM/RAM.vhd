library IEEE;
Library xpm;
use xpm.vcomponents.all;
use IEEE.STD_LOGIC_1164.ALL;



entity RAM is
  Port ( 
    clka_RAM : IN STD_LOGIC;
    rsta_RAM : IN STD_LOGIC;
    wea_RAM : IN STD_LOGIC_VECTOR(0 downto 0);      
    addra_RAM : IN STD_LOGIC_VECTOR(8 downto 0);
    dina_RAM  : IN STD_LOGIC_VECTOR(15 downto 0);
    douta_RAM : OUT STD_LOGIC_VECTOR(15 downto 0);
      -- Port B module ports
    rstb_RAM : IN STD_LOGIC;
    addrb_RAM : IN STD_LOGIC_VECTOR(8 downto 0);
    doutb_RAM : OUT STD_LOGIC_VECTOR(15 downto 0)
  
  
  );
end RAM;

architecture Behavioral of RAM is
begin

xpm_memory_dpdistram_inst : xpm_memory_dpdistram
  generic map (

    -- Common module generics
    MEMORY_SIZE             => 8192,           --positive integer
    CLOCKING_MODE           => "common_clock", --string; "common_clock", "independent_clock" 
    MEMORY_INIT_FILE        => "data.mem",         --string; "none" or "<filename>.mem" 
    MEMORY_INIT_PARAM       => "",             --string;
    USE_MEM_INIT            => 1,              --integer; 0,1
    MESSAGE_CONTROL         => 0,              --integer; 0,1
    USE_EMBEDDED_CONSTRAINT => 0,              --integer: 0,1
    MEMORY_OPTIMIZATION     => "true",          --string; "true", "false" 

    -- Port A module generics
    WRITE_DATA_WIDTH_A      => 16,             --positive integer
    READ_DATA_WIDTH_A       => 16,             --positive integer
    BYTE_WRITE_WIDTH_A      => 16,             --integer; 8, 9, or WRITE_DATA_WIDTH_A value
    ADDR_WIDTH_A            => 9,              --positive integer
    READ_RESET_VALUE_A      => "0",            --string
    READ_LATENCY_A          => 0,              --non-negative integer

    -- Port B module generics
    READ_DATA_WIDTH_B       => 16,             --positive integer
    ADDR_WIDTH_B            => 9,              --positive integer
    READ_RESET_VALUE_B      => "0",            --string
    READ_LATENCY_B          => 0               --non-negative integer
  )
  port map (

    -- Port A module ports
    clka                    => clka_RAM,
    rsta                    => rsta_RAM,
    ena                     => '1',
    regcea                  => '1',   --do not change
    wea                     => wea_RAM,
    addra                   => addra_RAM,
    dina                    => dina_RAM,
    douta                   => douta_RAM,

    -- Port B module ports
    clkb                    => clka_RAM,
    rstb                    => rstb_RAM,
    enb                     => '1',
    regceb                  => '1',   --do not change
    addrb                   => addrb_RAM,
    doutb                   => doutb_RAM
  );
	
				


end Behavioral;
