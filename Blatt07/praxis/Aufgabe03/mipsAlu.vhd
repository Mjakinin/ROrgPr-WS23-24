library ieee;
use ieee.std_logic_1164.all;
library work;
use work.proc_config.all;

entity mipsAlu is
    generic(WIDTH : integer);
    port(
        ctrl     : in  std_logic_vector(3 downto 0);
        a        : in  std_logic_vector(WIDTH - 1 downto 0);
        b        : in  std_logic_vector(WIDTH - 1 downto 0);
        result   : out std_logic_vector(WIDTH - 1 downto 0);
        overflow : out std_logic;
        zero     : out std_logic
    );
end mipsAlu;

architecture behavioral of mipsAlu is
    signal carry : std_logic_vector(WIDTH downto 0);
    signal zero_check : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal set : std_logic;
begin
carry(0) <= '1' when ctrl(2) = '1' else '0';-- für Subtraktion
alu_gen_n: for i in 1 to WIDTH-2 generate
    alu_inst: entity work.alu_1bit 
    port map(
            a        => a(i),
            b        => b(i),
            aInvert  => ctrl(3),
            bInvert  => ctrl(2),
            operation=> ctrl(1 downto 0),
            result   => result(i),
            set      => open,
            less     => '0',
            carryIn  => carry(i),
            carryOut => carry(i+1)
            );
end generate;
alu_0_inst: entity work.alu_1bit 
port map( --MSB
        a        => a(WIDTH-1),
        b        => b(WIDTH-1),
        aInvert  => ctrl(3),
        bInvert  => ctrl(2),
        operation=> ctrl(1 downto 0),
        result   => result(WIDTH-1),
        set      => set,
        less     => '0',
        carryIn  => carry(WIDTH-1),
        carryOut => carry(WIDTH)
);
alu_1_inst: entity work.alu_1bit 
port map( --LSB
        a        => a(0),
        b        => b(0),
        aInvert  => ctrl(3),
        bInvert  => ctrl(2),
        operation=> ctrl(1 downto 0),
        result   => result(0),
        set      => open,
        less     => set,
        carryIn  => carry(0),
        carryOut => carry(1)
    );
        overflow <= '0' when carry(WIDTH) = carry(WIDTH-1) else '1'; 
        zero <= '1' when result = zero_check else '0';
end behavioral;