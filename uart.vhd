-- uart.vhd: UART controller - receiving part
-- Author: Gabriel Biel
-- Login: xbielg00

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-------------------------------------------------
entity UART_RX is
port(	
   CLK: 	     in std_logic;
	RST: 	     in std_logic;
	DIN: 	     in std_logic;
	DOUT: 	  out std_logic_vector(7 downto 0);
	DOUT_VLD:  out std_logic
);
end UART_RX;  

-------------------------------------------------
architecture behavioral of UART_RX is
signal cnt					:std_logic_vector(4 downto 0);
signal cnt_b			:std_logic_vector(3 downto 0);
signal count_enable  	:std_logic;
signal count_b_enable		:std_logic;
signal valid_data :std_logic;

begin
	FSM: entity work.UART_FSM(behavioral)
	port map (
		CLK				=>	CLK,
		RST				=>	RST,
		DIN				=>	DIN,
		COUNT 			=> cnt,
		COUNT_EN 		=> count_enable,
		COUNT_B	 		=> cnt_b,
		COUNT_B_EN		=> count_b_enable,
		D_OUT_VAL 		=> valid_data
	);
	
	
	DOUT_VLD <= valid_data; 
	
	
	process (CLK) begin
		if rising_edge(CLK) then 
			
				if count_enable = '1' then 
					cnt <= cnt + 1;
				else 
					cnt <= "00000";
					cnt_b <= "0000";
				end if; 
				
				if count_b_enable = '1' then
					if cnt= "10000" then
						 cnt <= "00000";
						 
						 case cnt_b is
						 when "0000" => DOUT(0) <= DIN; 
						 when "0001" => DOUT(1) <= DIN; 
						 when "0010" => DOUT(2) <= DIN; 
						 when "0011" => DOUT(3) <= DIN;
						 when "0100" => DOUT(4) <= DIN; 
						 when "0101" => DOUT(5) <= DIN; 
						 when "0110" => DOUT(6) <= DIN; 
						 when "0111" => DOUT(7) <= DIN; 
						 when others => null; 
						 end case; 
						 cnt_b <= cnt_b + 1;
						 
					end if;
				end if;
		end if;
	end process; 
end behavioral;
