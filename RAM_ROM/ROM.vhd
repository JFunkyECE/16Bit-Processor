library xpm;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use xpm.vcomponents.all;


-- Define the ROM entity with its interface
entity rom is
    Port (
        clka_ROM : in STD_LOGIC;
        rsta_ROM : in STD_LOGIC;
        addra_ROM : in STD_LOGIC_VECTOR(8 downto 0);
        douta_ROM : out STD_LOGIC_VECTOR(15 downto 0));
end rom;

-- Implementation of the ROM using an architecture
architecture Behavioral of rom is
begin


xpm_memory_sprom_inst : xpm_memory_sprom
  generic map (

    -- Common module generics
    MEMORY_SIZE             => 8192,            --positive integer
    MEMORY_PRIMITIVE        => "auto",          --string; "auto", "distributed", or "block";
    MEMORY_INIT_FILE        => "instructions.mem",          --string; "none" or "<filename>.mem" 
    MEMORY_INIT_PARAM       => "0",              --string;
    USE_MEM_INIT            => 1,               --integer; 0,1
    WAKEUP_TIME             => "disable_sleep", --string; "disable_sleep" or "use_sleep_pin" 
    MESSAGE_CONTROL         => 0,               --integer; 0,1
    ECC_MODE                => "no_ecc",        --string; "no_ecc", "encode_only", "decode_only" or "both_encode_and_decode" 
    AUTO_SLEEP_TIME         => 0,               --Do not Change
    MEMORY_OPTIMIZATION     => "true",          --string; "true", "false" 

    -- Port A module generics
    READ_DATA_WIDTH_A       => 16,              --positive integer
    ADDR_WIDTH_A            => 9,               --positive integer
    READ_RESET_VALUE_A      => "EAAA",           --string
    READ_LATENCY_A          => 0                --non-negative integer
  )
  port map (

    -- Common module ports
    sleep                   => '0',
    -- Port A module ports
    clka                    => clka_ROM,
    rsta                    => rsta_ROM,
    ena                     => '1',
    regcea                  => '1',
    addra                   => addra_ROM,
    injectsbiterra          => '0',   --do not change
    injectdbiterra          => '0',   --do not change
    douta                   => douta_ROM,
    sbiterra                => open,  --do not change
    dbiterra                => open   --do not change
  );

end Behavioral;