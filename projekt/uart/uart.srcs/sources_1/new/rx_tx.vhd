library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity rx_tx is
    Port ( prepinac : in STD_LOGIC;
           clk      : in STD_LOGIC;
           rst      : in STD_LOGIC;
           vystup   : out STD_LOGIC;
           data0    : in STD_LOGIC;
           data1    : in STD_LOGIC;
           data2    : in STD_LOGIC;
           data3    : in STD_LOGIC;
           data4    : in STD_LOGIC;
           data5    : in STD_LOGIC;
           data6    : in STD_LOGIC;
           data7    : in STD_LOGIC;
           SW       : in STD_LOGIC_VECTOR(2 downto 0);
           vstup    : in STD_LOGIC;
           vysledek : out STD_LOGIC_VECTOR(7 downto 0)
           
           );
end rx_tx;

architecture behavioral of rx_tx is

    signal slovo    : STD_LOGIC_VECTOR(7 downto 0);
    -- Internal clock enable
    signal sig_en_2ms_tx : std_logic;
    signal sig_en_2ms_rx : std_logic;
    -- Internal 2-bit counter for multiplexing 4 digits
    signal sig_cnt_4bit_tx : std_logic_vector(3 downto 0);
    signal sig_cnt_4bit_rx : std_logic_vector(3 downto 0);
    -- Internal 4-bit value
    signal sig_hex : std_logic;
    -- vnitrni propojeni nastaveni rychlosti
    signal clock_set : natural;
    -- povoleni clock_enable_rx pro rx vzdy zaple, tx vzdy nutno zapnout
    signal sig_cerx_en : std_logic;
    -- Interní reset
    signal sig_rst_cnt : std_logic;
    signal sig_rx_cnt : std_logic := '0';

begin

clk_en1 : entity work.clock_enable_rx
    port map (
      clk => clk,-- WRITE YOUR CODE HERE
      rst => rst,-- WRITE YOUR CODE HERE
      ce  => sig_en_2ms_rx,
      max => clock_set,
      cerx_en => sig_cerx_en
    );
    
clk_en2 : entity work.clock_enable_tx
    port map (
      clk => clk,-- WRITE YOUR CODE HERE
      rst => rst,-- WRITE YOUR CODE HERE
      ce  => sig_en_2ms_tx,
      max => clock_set
    );

bd_rate_set : entity work.bd_rate_set
    port map(
        clk_out => clock_set,
        SW => SW
        );

bin_cnt0 : entity work.tx_cnt_up
    generic map (
      g_CNT_WIDTH => 4-- WRITE YOUR CODE HERE
    )
    port map (
      clk => clk,-- WRITE YOUR CODE HERE
      rst => rst,
      en => sig_en_2ms_tx,
      cnt_up => '0',
      cnt => sig_cnt_4bit_tx
    );
    
in_cnt1 : entity work.rx_cnt_up
    generic map (
      g_CNT_WIDTH => 4-- WRITE YOUR CODE HERE
    )
    port map (
      clk => clk,-- WRITE YOUR CODE HERE
      rst => rst,
      en => sig_en_2ms_rx,
      cnt_up => '0',
      cnt => sig_cnt_4bit_rx,
      int_rst => sig_rst_cnt,
      cnt_en => sig_cerx_en
    );    
    
  
tx : process (clk) is
  begin
   if(rising_edge(clk)) then
        else
            if (prepinac = '1') then
            report "sig_cerx_en nastaven na 1";
            slovo(0) <= data0;
            slovo(1) <= data1;
            slovo(2) <= data2;
            slovo(3) <= data3;
            slovo(4) <= data4;
            slovo(5) <= data5;
            slovo(6) <= data6;
            slovo(7) <= data7;
            
            case sig_cnt_4bit_tx is
                when "1111" =>  --f
                    vystup <= '1';
                
                when "1110" => -- e
                    vystup <= '0';

                when "1101" => -- d
                    vystup <= slovo(7);
          
                when "1100" => -- c
                    vystup <= slovo(6);
          
                when "1011" => -- b
                    vystup <= slovo(5);
          
                when "1010" => -- a
                    vystup <= slovo(4);

                when "1001" => -- 9
                    vystup <= slovo(3);
                
                when "1000" => -- 8
                    vystup <= slovo(2);
                
                when "0111" =>  -- 7
                    vystup <= slovo(1);
                
                when "0110" => -- 6
                    vystup <= slovo(0);
                    
                when "0101" => -- 5
                    vystup <= '1';
                
                when "0000" => -- 0
                    vystup <= '1';
                
                when others =>
                    vystup <= '1';

            end case;
        end if;
    end if;
 end process tx;
 
 rx : process (clk, vstup) is
  begin
  if (prepinac = '0') then
        --sig_cerx_en <= '0';
        if(vstup = '0' and sig_rx_cnt = '0') then
            report "vstup 0";
            sig_cerx_en <= '1';
            sig_rx_cnt <= '1';
        elsif(sig_rx_cnt = '1')then                
             case sig_cnt_4bit_rx is
                when "1111" =>  --f
                    vysledek(0) <= vstup;
                    report "vysledek 0";
                
                when "1110" => -- e
                    vysledek(1) <= vstup;
                    report "vysledek 1";

                when "1101" => -- d
                    vysledek(2) <= vstup;
                    report "vysledek 2";
          
                when "1100" => -- c
                    vysledek(3) <= vstup;
                    report "vysledek 3";
          
                when "1011" => -- b
                    vysledek(4) <= vstup;
                    report "vysledek 4";
          
                when "1010" => -- a
                    vysledek(5) <= vstup;
                    report "vysledek 5";

                when "1001" => -- 9
                    vysledek(6) <= vstup;
                    report "vysledek 6";
                
                when "1000" => -- 8
                    vysledek(7) <= vstup;
                    report "vysledek 7";
                
                when "0000" =>
                     sig_rx_cnt <= '1';              
                when others =>
                sig_rx_cnt <= '0';
                report "vynulovani";
            end case;
           
        end if;
   end if;
end process rx; 

end architecture behavioral;