-- Citac s volitelnou frekvenciou
-- @author Onegen Something <xonege99@vutbr.cz>
-- @date 2023-03-14
--

library ieee;
use ieee.std_logic_1164.all;

entity counter is
	generic (
		OUT1_PERIOD : positive := 1;
		OUT2_PERIOD : positive := 1;
		OUT3_PERIOD : positive := 1
	);
	port (
		CLK   : in  std_logic;
		RESET : in  std_logic;
		EN1   : out std_logic;
		EN2   : out std_logic;
		EN3   : out std_logic
	);
end counter;

architecture behavioral of counter is
	signal CNT1 : integer range 0 to OUT1_PERIOD - 1 := 0;
	signal CNT2 : integer range 0 to OUT2_PERIOD - 1 := 0;
	signal CNT3 : integer range 0 to OUT3_PERIOD - 1 := 0;
begin

	-- Counter 1
	p_cnt1 : process (CLK, RESET)
	begin
		if RESET = '1' then
			CNT1 <= 0;
			EN1  <= '0';
		elsif rising_edge(CLK) then
			if CNT1 = OUT1_PERIOD - 1 then
				CNT1 <= 0;
				EN1  <= '1';
			else
				CNT1 <= CNT1 + 1;
				EN1  <= '0';
			end if;
		end if;
	end process;

	-- Counter 2
	p_cnt2 : process (CLK, RESET)
	begin
		if RESET = '1' then
			CNT2 <= 0;
			EN2  <= '0';
		elsif rising_edge(CLK) then
			if CNT2 = OUT2_PERIOD - 1 then
				CNT2 <= 0;
				EN2  <= '1';
			else
				CNT2 <= CNT2 + 1;
				EN2  <= '0';
			end if;
		end if;
	end process;

	-- Counter 3
	p_cnt3 : process (CLK, RESET)
	begin
		if RESET = '1' then
			CNT3 <= 0;
			EN3  <= '0';
		elsif rising_edge(CLK) then
			if CNT3 = OUT3_PERIOD - 1 then
				CNT3 <= 0;
				EN3  <= '1';
			else
				CNT3 <= CNT3 + 1;
				EN3  <= '0';
			end if;
		end if;
	end process;

end behavioral;
