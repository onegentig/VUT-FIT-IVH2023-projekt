-- Citac s volitelnou frekvenciou
-- @author Onegen Something <xonege99@vutbr.cz>
-- @date 2023-03-14
--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY counter IS
	GENERIC (
		OUT1_PERIOD : POSITIVE := 1;
		OUT2_PERIOD : POSITIVE := 1;
		OUT3_PERIOD : POSITIVE := 1);
	PORT (
		CLK   : IN STD_LOGIC;
		RESET : IN STD_LOGIC;
		EN1   : OUT STD_LOGIC;
		EN2   : OUT STD_LOGIC;
		EN3   : OUT STD_LOGIC
	);
END counter;

ARCHITECTURE behavioral OF counter IS
	SIGNAL CNT1 : INTEGER RANGE 0 TO OUT1_PERIOD - 1 := 0;
	SIGNAL CNT2 : INTEGER RANGE 0 TO OUT2_PERIOD - 1 := 0;
	SIGNAL CNT3 : INTEGER RANGE 0 TO OUT3_PERIOD - 1 := 0;
BEGIN

	-- Counter 1
	p_cnt1 : PROCESS (CLK, RESET) BEGIN
		IF RESET = '1' THEN
			CNT1 <= 0;
			EN1  <= '0';
		ELSIF rising_edge(CLK) THEN
			IF CNT1 = OUT1_PERIOD - 1 THEN
				CNT1 <= 0;
				EN1  <= '1';
			ELSE
				CNT1 <= CNT1 + 1;
				EN1  <= '0';
			END IF;
		END IF;
	END PROCESS;

	-- Counter 2
	p_cnt2 : PROCESS (CLK, RESET) BEGIN
		IF RESET = '1' THEN
			CNT2 <= 0;
			EN2  <= '0';
		ELSIF rising_edge(CLK) THEN
			IF CNT2 = OUT2_PERIOD - 1 THEN
				CNT2 <= 0;
				EN2  <= '1';
			ELSE
				CNT2 <= CNT2 + 1;
				EN2  <= '0';
			END IF;
		END IF;
	END PROCESS;

	-- Counter 3
	p_cnt3 : PROCESS (CLK, RESET) BEGIN
		IF RESET = '1' THEN
			CNT3 <= 0;
			EN3  <= '0';
		ELSIF rising_edge(CLK) THEN
			IF CNT3 = OUT3_PERIOD - 1 THEN
				CNT3 <= 0;
				EN3  <= '1';
			ELSE
				CNT3 <= CNT3 + 1;
				EN3  <= '0';
			END IF;
		END IF;
	END PROCESS;

END behavioral;
