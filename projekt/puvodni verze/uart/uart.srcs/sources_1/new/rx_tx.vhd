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
           data7    : in STD_LOGIC
           );
end rx_tx;

architecture behavioral of rx_tx is

    signal slovo    : STD_LOGIC_VECTOR(7 downto 0);
    -- Internal clock enable
    signal sig_en_2ms : std_logic;
    -- Internal 2-bit counter for multiplexing 4 digits
    signal sig_cnt_4bit : std_logic_vector(3 downto 0);
    -- Internal 4-bit value for 7-segment decoder
    signal sig_hex : std_logic;

begin

bin_cnt0 : entity work.cnt_up_rx
    generic map (
      g_CNT_WIDTH => 4-- WRITE YOUR CODE HERE
    )
    port map (
      clk => clk,-- WRITE YOUR CODE HERE
      rst => rst,
      en => sig_en_2ms,
      cnt_up => '0',
      cnt => sig_cnt_4bit
    );

rxtx : process (clk) is
  begin
   if(rising_edge(clk)) then 
    if (prepinac = '1') then
            slovo(0) <= data0;
            slovo(1) <= data1;
            slovo(2) <= data2;
            slovo(3) <= data3;
            slovo(4) <= data4;
            slovo(5) <= data5;
            slovo(6) <= data6;
            slovo(7) <= data7;
            
            case sig_cnt_4bit is
                when "1111" =>
                    vystup <= '1';
                
                when "1110" =>
                    vystup <= '0';

                when "1101" =>
                    vystup <= slovo(7);
          
                when "1100" =>
                    vystup <= slovo(6);
          
                when "1011" =>
                    vystup <= slovo(5);
          
                when "1010" =>
                    vystup <= slovo(4);

                when "1001" =>
                    vystup <= slovo(3);
                
                when "0111" =>
                    vystup <= slovo(2);
                
                when "0110" =>
                    vystup <= slovo(1);
                
                when "0101" =>
                    vystup <= slovo(0);
                    
                when "0100" =>
                    vystup <= '1';
                
                when others =>
                    vystup <= '1';
            end case;
            

    end if;
    
    if (counter = '7') then
      counter <= '0'
    end if
     
case counter is

          when "0" =>
            vystup <= tla?ítko_0

          when "1" =>
            vystup <= tla?ítko_1
 
          when "2" =>
            vystup <= tla?ítko_2
 
          when "3" =>
            vystup <= tla?ítko_3
 
          when "4" =>
            vystup <= tla?ítko_4
 
          when "5" =>
            vystup <= tla?ítko_5
 
          when "6" =>
            vystup <= tla?ítko_6
          
         when "7" =>
            vystup <= tla?ítko_7
        end case;
         
  end process rxtx;