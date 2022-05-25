-- uart_fsm.vhd: UART controller - finite state machine
-- Author(s): Gabriel Biel
-- Login : xbielg00
library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------
entity UART_FSM is
port(
   CLK 				: in std_logic;
   RST 				: in std_logic;
	DIN 				: in std_logic;
	COUNT 			: in std_logic_vector(4 downto 0);
	COUNT_EN			: out std_logic;
	COUNT_B 			: in std_logic_vector (3 downto 0);
	COUNT_B_EN		: out std_logic;
	D_OUT_VAL 		: out std_logic
   );
end entity UART_FSM;

-------------------------------------------------
architecture behavioral of UART_FSM is
type statetype is (WAIT_TO_START, START_BIT, READ_DATA, STOP_BIT, VAL_D);
signal state : statetype := WAIT_TO_START;
begin

COUNT_B_EN<= '1' when state = READ_DATA else '0'; 	
COUNT_EN <= '1' when state = READ_DATA or state = START_BIT else  '0';
D_OUT_VAL <= '1' when state = VAL_D else '0';		

	process(CLK)begin
		if rising_edge(CLK) then
			if RST = '1' then
			state <= WAIT_TO_START;
			
			else 
				case state is
				
					when WAIT_TO_START => if DIN = '0' then
						state <= START_BIT;
						end if; 
					
					when START_BIT => if COUNT = "01000" then
						state <= READ_DATA;
						end if;
						
					when READ_DATA => if COUNT_B = "1000" then
						state <= STOP_BIT;
						end if;
						
					when STOP_BIT => if DIN = '1' then
						state <= VAL_D;
						end if;
						
					when VAL_D => state <= WAIT_TO_START;
					
					when others 		 => null;
				
				end case;
			end if;
		end if;
	end process;
end behavioral;
