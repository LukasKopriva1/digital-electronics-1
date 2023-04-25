----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2023 12:38:29 PM
-- Design Name: 
-- Module Name: rx_cnt - Behavioral
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

entity rx_cnt is
    Port ( btnr : in STD_LOGIC;
           rx_en : out STD_LOGIC);
end rx_cnt;

architecture Behavioral of rx_cnt is

begin

if btnr = '1' then
    rx_en = '1';
    wait for 1041666;
    rx_en = '0';
else
    rx_en = '0';
end Behavioral;
