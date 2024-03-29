----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2023 11:51:40 AM
-- Design Name: 
-- Module Name: top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port ( CLK100MHZ : in STD_LOGIC;
           SW : in STD_LOGIC_VECTOR (15 downto 0);
           CA : out STD_LOGIC;
           CB : out STD_LOGIC;
           CC : out STD_LOGIC;
           CD : out STD_LOGIC;
           CE : out STD_LOGIC;
           CF : out STD_LOGIC;
           CG : out STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           BTNC : in STD_LOGIC;
           LED : out STD_LOGIC_VECTOR (15 downto 15);
           -- NEJAKY : out STD_LOGIC; --simulace
           --nevim : out STD_LOGIC_VECTOR (7 downto 0);
           JA : in STD_LOGIC_VECTOR (0 downto 0);
           JB : out STD_LOGIC_VECTOR (0 downto 0)
           );
end top;

architecture Behavioral of top is
  signal sig_datap : std_logic_vector (7 downto 0);
-- No internal signals are needed today:)
begin

  rx_tx_switch : entity work.rx_tx_switch
      port map(
          switch => SW(15),
          ledka  => LED(15)
      );
  --------------------------------------------------------
  -- Instance (copy) of driver_7seg_4digits 
  --------------------------------------------------------
  driver_seg_4 : entity work.driver_7seg_8digits -- entity work.driver_7seg_8digits
      port map (
          clk      => CLK100MHZ,
          rst      => BTNC,
          
                
          data0 => SW(0),
          data1 => SW(1),
          data2 => SW(2),
          data3 => SW(3),
          data4 => SW(4),
          data5 => SW(5),
          data6 => SW(6),
          data7 => SW(7), 
          
          datap => sig_datap,
                   

          prepinac => SW(15),
          -- DECIMAL POINT
          seg(6) => CA,
          seg(5) => CB,
          seg(4) => CC,
          seg(3) => CD,
          seg(2) => CE,
          seg(1) => CF,
          seg(0) => CG,
          -- MAP OTHER DISPLAY SEGMENTS HERE


          -- DIGITS
          dig(7 downto 0) => AN(7 downto 0)
      );
 rx_tx : entity work.rx_tx
    port map(
        prepinac => SW(15),
        clk => CLK100MHZ,
        rst => BTNC,
        -- vystup => NEJAKY, -- simulace
        data0 => SW(0),
        data1 => SW(1),
        data2 => SW(2),
        data3 => SW(3),
        data4 => SW(4),
        data5 => SW(5),
        data6 => SW(6),
        data7 => SW(7),
        
        SW(2) => SW(13),
        SW(1) => SW(12),
        SW(0) => SW(11),
        vstup => JA(0),
        vystup => JB(0), -- implementace
        vysledek => sig_datap
        );
        
  --------------------------------------------------------
  -- Other settings
  --------------------------------------------------------
  -- Disconnect the top four digits of the 7-segment display
  --AN(7 downto 4) <= b"1111";

end architecture behavioral;
