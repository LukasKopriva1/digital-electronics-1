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
    
    -- Vnitrni signal pro vysilane slovo
    signal slovo    : STD_LOGIC_VECTOR(7 downto 0);
    -- Vnitrni clock enable
    signal sig_en_tx : std_logic;
    signal sig_en_rx : std_logic;
    -- vnitrni 4-bit citac pro multiplexing 8 digits
    signal sig_cnt_4bit_tx : std_logic_vector(3 downto 0);     -- pro vysilac
    signal sig_cnt_4bit_rx_x16 : std_logic_vector(3 downto 0); -- pro prijimac
    -- vnitrni propojeni nastaveni rychlosti
    signal clock_set : natural;      -- zakladni rychlost
    signal clock_setx16 : natural;   -- 16x rychlejsi
    -- signal pro zapnuti clock_enable_rx 
    signal sig_cerx_en : std_logic;
    -- Intern� reset
    signal sig_rst_cnt : std_logic := '0';
    signal sig_rx_cnt : std_logic := '0';
   -- signal vysledek : std_logic_vector(7 downto 0);
    -- pocitadla pro jednotlive funkce
    signal pocitadlo : natural;  -- pocitadlo pro prijimac - vyber, kam zapsat prijaty bit
    signal pocitadlo2 : natural; -- pocitadlo pro prijimac - detekce start bitu
begin

clock_setx16 <= clock_set /16;

clk_en1 : entity work.clock_enable_rx
    port map (
      clk => clk,
      rst => rst,
      ce  => sig_en_rx,
      max => clock_setx16, -- rychlost citace je 16x rychlejsi nez nastaveny BD rate
      cerx_en => sig_cerx_en
    );
    
clk_en2 : entity work.clock_enable_tx
    port map (
      clk => clk,
      rst => rst,
      ce  => sig_en_tx,
      max => clock_set -- rychlost citace je rovna nastavenemu BD rate
    );

bd_rate_set : entity work.bd_rate_set
    port map(
        clk_out => clock_set, -- nacteni BD rate
        SW => SW
        );

bin_cnt_tx : entity work.tx_cnt_up
    generic map (
      g_CNT_WIDTH => 4
    )
    port map (
      clk => clk,
      rst => rst,
      en => sig_en_tx,
      cnt_up => '0',
      cnt => sig_cnt_4bit_tx
    );
    
bin_cnt_rx_16x : entity work.rx_cnt_up
    generic map (
      g_CNT_WIDTH => 4
    )
    port map (
      clk => clk,
      rst => rst,
      en => sig_en_rx,
      cnt_up => '0',
      cnt => sig_cnt_4bit_rx_x16,
      int_rst => sig_rst_cnt,
      cnt_en => sig_cerx_en
    );    
    
  
tx : process (clk) is  -- vysilac
  begin
   if(rising_edge(clk)) then  
        
            if (prepinac = '1') then  -- pokud je deska prepnuta do rezimu vysilace
            report "sig_cerx_en nastaven na 1"; 
            slovo(0) <= data0; -- nacteni vstupu do pameti
            slovo(1) <= data1;
            slovo(2) <= data2;
            slovo(3) <= data3;
            slovo(4) <= data4;
            slovo(5) <= data5;
            slovo(6) <= data6;
            slovo(7) <= data7;
            
            case sig_cnt_4bit_tx is -- multiplexovani vystupu
                when "1111" =>  --f  -- pred stardbitem vzdy 1
                    vystup <= '1';
                
                when "1110" => -- e
                    vystup <= '0';   -- start bit

                when "1101" => -- d
                    vystup <= slovo(0);  -- vyslani LSB
          
                when "1100" => -- c
                    vystup <= slovo(1);
          
                when "1011" => -- b
                    vystup <= slovo(2);
          
                when "1010" => -- a
                    vystup <= slovo(3);

                when "1001" => -- 9
                    vystup <= slovo(4);
                
                when "1000" => -- 8
                    vystup <= slovo(5);
                
                when "0111" =>  -- 7
                    vystup <= slovo(6);
                
                when "0110" => -- 6
                    vystup <= slovo(7);  -- vyslani MSB
                    
                when "0101" => -- 5
                    vystup <= '1';       -- vyplnove bity zajistujici odstup jednotlivych vysilani
                
                when "0000" => -- 0
                    vystup <= '1';
                
                when others =>
                    vystup <= '1';

            end case;
        end if;
    end if;
 end process tx;
 
 rx : process (clk, vstup) is  -- prijimac
  begin
if(rising_edge(clk))then
  if (prepinac = '0') then
            -- kontrola nastaveni Vysilac/prijmac
        if(vstup = '0' and sig_rx_cnt = '0') then -- pokud je vstup 0 a jeste sme nedetekovali start bit
            report "vstup 0";
            sig_cerx_en <= '1';  -- aktivace citace pro prijimac
            sig_rx_cnt <= '1';   -- zaznam do pameti, ze jsme detekovali start bit
        elsif(sig_rx_cnt = '1')then          -- pokud jsme jiz detekovali start bit, tak se divame na hodnotu citace x16 a podle      
             case sig_cnt_4bit_rx_x16 is
                when "1000" => 
                    if(pocitadlo2 = 0)then -- vystredeni citace, probiha pouze pri prvnim napocitani 8ky.
                           pocitadlo2 <= 1;
                        if(pocitadlo = 0)then -- pokud je pocitadlo rovno nule, zacneme pocitat prijate bity
                            pocitadlo <= 1;   -- pokud jiz neni rovno nule, tak zaznamenavame bity zpravy
                        end if;
                    if(pocitadlo > 0) then -- pokud pocitadlo poradi bitu je vetsi jak 0, tedy je detekovan start bit, tak nacitame vystupy pokazde, kdyz sig_cnt_4bit_rx_x16 je roven "1000"
                        case pocitadlo is
                        when 1 =>
                            vysledek(7) <= vstup;
                            pocitadlo <= 2;
                            report "vysledek 0";
                
                        when 2 =>
                            vysledek(6) <= vstup;
                            pocitadlo <= 3;
                            report "vysledek 1";

                        when 3 => -- d
                            vysledek(5) <= vstup;
                            pocitadlo <= 4;
                            report "vysledek 2";
          
                        when 4 => -- c
                            vysledek(4) <= vstup;
                            pocitadlo <= 5;
                            report "vysledek 3";
          
                        when 5 => -- b
                            vysledek(3) <= vstup;
                            pocitadlo <= 6;
                            report "vysledek 4";
          
                        when 6 => -- a
                            vysledek(2) <= vstup;
                            pocitadlo <= 7;
                            report "vysledek 5";

                        when 7 => -- 9
                            vysledek(1) <= vstup;
                            pocitadlo <= 8;
                            report "vysledek 6";
                
                        when 8 => -- 8
                            vysledek(0) <= vstup;
                            pocitadlo <= 9;
                            report "vysledek 7";
                
                        when others =>
                            sig_rx_cnt <= '0';   -- resetovani detekce start bitu
                            sig_cerx_en  <= '0'; -- deaktivace citace prijmu 
                            pocitadlo <= 0;
                        report "vynulovani";
                    end case;
                   end if;
                  end if;
                
                when "1001" => 
                    pocitadlo2 <= 0;
                
                when others =>
                    -- do nothing;    
                end case;
        end if;
   end if;
 end if;
end process rx; 

end architecture behavioral;