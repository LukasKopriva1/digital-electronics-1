----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2023 11:13:07 AM
-- Design Name: 
-- Module Name: rx_tx_switch - Behavioral
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

entity rx_tx_switch is
    Port ( switch : in STD_LOGIC;
           ledka : out STD_LOGIC
           );
end rx_tx_switch;

architecture Behavioral of rx_tx_switch is

begin

ledka <= '1' when (switch = '1') else '0'; 

end Behavioral;
