----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.04.2023 23:06:15
-- Design Name: 
-- Module Name: bd_rate_set - Behavioral
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

entity bd_rate_set is
    Port ( SW : in STD_LOGIC_VECTOR (2 downto 0);
           clk_out : out natural
           
           );
end bd_rate_set;

architecture Behavioral of bd_rate_set is

begin

p_bd_r_set : process (SW) is
  begin

    case SW is
                when "000" =>  --9600
                   -- clk_out <= 16; -- simulaci
                   clk_out <= 10417;
                
                when "100" => -- 4800
                    --clk_out <= 5; -- simulaci
                    clk_out <= 20834;
                
                when others => -- 2400
                    --clk_out <= 6; --simulaci
                    clk_out <= 41668;
            end case;

  end process p_bd_r_set;

end Behavioral;
