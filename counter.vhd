-- Citac s volitelnou frekvenci
-- IVH projekt - ukol 2
-- Autor: Onegen Something <xonege99@vutbr.cz>

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- v pripade nutnosti muzete nacist dalsi knihovny

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

ARCHITECTURE Behavioral OF counter IS

BEGIN
	-- Například čítač s periodou OUT1_PERIOD = 3 (t.j., každé 3 cykly)
	-- aktivuje na právě na jeden hodinový cyklus signál EN1. Analogicky 
	-- to bude fungovat i pro další dva kanály 

END Behavioral;
