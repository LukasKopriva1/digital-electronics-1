
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all; -- Definition of "to_unsigned"

------------------------------------------------------------
-- Entity declaration for testbench
------------------------------------------------------------

entity tb_top is
-- Entity of testbench is always empty
end entity tb_top;

------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------

architecture testbench of tb_top is
  -- Testbech local constants
  constant c_CLK_100MHZ_PERIOD : time := 10 ns;
    
  -- Testbench local signals
  signal sig_rst : std_logic;
  signal sig_blank : std_logic;
  signal sig_clk_100mhz : std_logic;
  signal sig_data       : std_logic_vector(7 downto 0);
  signal sig_seg        : std_logic_vector(6 downto 0);
  signal sig_dig        : std_logic_vector(7 downto 0);
  --signal sig_hex   : std_logic_vector(3 downto 0);
  --signal sig_seg   : std_logic_vector(6 downto 0);
  signal sig_switch : std_logic_vector(15 downto 8); 
  signal sig_ledka : std_logic_vector (15 downto 15); 
  signal sig_nejaky : std_logic;
  signal sig_clk_set : natural;
  signal sig_vystup_tx : std_logic_vector (7 downto 0);
  signal sig_JA : std_logic;
  signal sig_JB : std_logic;

begin

  -- Connecting testbench signals with decoder entity
  -- (Unit Under Test)
  uut_top : entity work.top
    port map (
            CLK100MHZ => sig_clk_100mhz,
            LED   => sig_ledka,
            BTNC  => sig_rst,
            CA => sig_seg(6),
            CB => sig_seg(5),
            CC => sig_seg(4),
            CD => sig_seg(3),
            CE => sig_seg(2),
            CF => sig_seg(1),
            CG => sig_seg(0),
            
            SW(0) => sig_data(0),
            SW(1) => sig_data(1),
            SW(2) => sig_data(2),
            SW(3) => sig_data(3),
            SW(4) => sig_data(4),
            SW(5) => sig_data(5),
            SW(6) => sig_data(6),
            SW(7) => sig_data(7),
            SW(8) => sig_switch(8),
            SW(9) => sig_switch(9),
            SW(10) => sig_switch(10),
            SW(11) => sig_switch(11),
            SW(12) => sig_switch(12),
            SW(13) => sig_switch(13),
            SW(14) => sig_switch(14),
            SW(15) => sig_switch(15),
            NEJAKY => sig_nejaky,
            nevim => sig_vystup_tx,
            JA(0) => sig_JA,
            JB(0) => sig_JB
           );
            
  --------------------------------------------------------
  -- Data generation process
  --------------------------------------------------------
  p_clk_gen : process is
    begin
    while now < 40000 ns loop -- 40 periods of 100MHz clock

      sig_clk_100mhz <= '0';
      wait for c_CLK_100MHZ_PERIOD / 2;
      sig_clk_100mhz <= '1';
      wait for c_CLK_100MHZ_PERIOD / 2;

    end loop;
    wait;

  end process p_clk_gen;
  
  p_reset_gen : process is
  begin

    sig_rst <= '0';
    wait for 12 ns;
    sig_rst <= '1';-- WRITE YOUR CODE HERE AND ACTIVATE RESET FOR A WHILE
    wait for 10 ns;
    sig_rst <= '0';

    wait;

  end process p_reset_gen;
  
  p_stimulus : process is
  begin

    report "Stimulus process started";
    sig_JA <= '1';
    sig_switch(13) <= '1';
    sig_switch(12) <= '0';
    sig_switch(11) <= '0';
    sig_data <= "10000001";
    sig_switch(15) <= '1';
    wait for 50ns;
    sig_data <= "10101010";
    sig_switch(15) <= '1';
    --sig_JA <= '0';  -- start bit
    --wait for 40ns;
    sig_JA <= '1';  --0
    wait for 40 ns;
    sig_JA <= '0';  --1
    wait for 40ns;
    sig_JA <= '1';  --2
    wait for 40ns;
    sig_JA <= '1';  --3
    wait for 40ns;
    sig_JA <= '0';  --4
    wait for 40ns;
    sig_JA <= '0';  --5
    wait for 40ns;
    sig_JA <= '1';  --6
    wait for 40ns;
    sig_JA <= '0';  --7
    wait for 40ns;
    sig_JA <= '1';
    report "Stimulus process finished";
    wait;

  end process p_stimulus;

end architecture testbench;
