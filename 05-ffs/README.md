# Lab 5: Lukáš Kopřiva

### D & T Flip-flops

1. Screenshot with simulated time waveforms. Try to simulate both D- and T-type flip-flops in a single testbench with a maximum duration of 350 ns, including reset. Always display all inputs and outputs (display the inputs at the top of the image, the outputs below them) at the appropriate time scale!

   ![EPWave](waveform.PNG)

### JK Flip-flop

1. Listing of VHDL architecture for JK-type flip-flop. Always use syntax highlighting, meaningful comments, and follow VHDL guidelines:

```vhdl
architecture behavioral of jk_ff_rst is
    
    signal s_q : std_logic;
begin
    
    p_jk_ff_rst : process (clk)
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                s_q <= '0';
            elsif (j ='0' and k='0') then
                s_q <= s_q;
            elsif (j ='0' and k='1') then
            	s_q <= '0';
            elsif (j ='1' and k='0') then
            	s_q <= '1';
            else
                s_q <= not s_q;
            end if;
        end if;
    end process p_jk_ff_rst;

    -- Output ports are permanently connected to local signal
    q     <= s_q;
    q_bar <= not s_q;
end architecture behavioral;

```

### Shift register

1. Image of `top` level schematic of the 4-bit shift register. Use four D-type flip-flops and connect them properly. The image can be drawn on a computer or by hand. Always name all inputs, outputs, components and internal signals!

   ![shift register](4bit.jpg)

## Pre-Lab preparation

1. Write characteristic equations and complete truth tables for D, JK, T flip-flops where `q(n)` represents main output value before the clock edge and `q(n+1)` represents output value after the clock edge.

   ![Characteristic equations](images/eq_flip_flops.png)
<!--
https://editor.codecogs.com/
\begin{align*}
    q_{n+1}^D =&~D \\
    q_{n+1}^{JK} =& \\
    q_{n+1}^T =& \\
\end{align*}
-->

   **D-type FF**
   | **clk** | **d** | **q(n)** | **q(n+1)** | **Comments** |
   | :-: | :-: | :-: | :-: | :-- |
   | ![rising](images/eq_uparrow.png) | 0 | 0 | 0 | `q(n+1)` has the same level as `d` |
   | ![rising](images/eq_uparrow.png) | 0 | 1 | 0 |  |
   | ![rising](images/eq_uparrow.png) | 1 | 0 | 1 |  |
   | ![rising](images/eq_uparrow.png) | 1 | 1 | 1 |  |

   **JK-type FF**
   | **clk** | **j** | **k** | **q(n)** | **q(n+1)** | **Comments** |
   | :-: | :-: | :-: | :-: | :-: | :-- |
   | ![rising](images/eq_uparrow.png) | 0 | 0 | 0 | 0 | Output did not change |
   | ![rising](images/eq_uparrow.png) | 0 | 0 | 1 | 1 | Output did not change |
   | ![rising](images/eq_uparrow.png) | 0 | 1 | 1 | 0 |  |
   | ![rising](images/eq_uparrow.png) | 0 | 1 | 0 | 0 |  |
   | ![rising](images/eq_uparrow.png) | 1 | 0 | 0 | 1 |  |
   | ![rising](images/eq_uparrow.png) | 1 | 1 | 1 | 0 |  |
   | ![rising](images/eq_uparrow.png) | 1 | 1 | 0 | 1 |  |
   | ![rising](images/eq_uparrow.png) | 1 | 1 | 1 | 0 |  |

   **T-type FF**
   | **clk** | **t** | **q(n)** | **q(n+1)** | **Comments** |
   | :-: | :-: | :-: | :-: | :-- |
   | ![rising](images/eq_uparrow.png) | 0 | 0 | 0 | Output did not change |
   | ![rising](images/eq_uparrow.png) | 0 | 1 | 1 |  |
   | ![rising](images/eq_uparrow.png) | 1 | 1 | 0 |  |
   | ![rising](images/eq_uparrow.png) | 1 | 0 | 1 |  |
