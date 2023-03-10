-- Testovani counteru, kod je tak, jak je vygenerovan od ISE
-- Autor: Onegen Something <xonege99@vutbr.cz>

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY counter_tb IS
END counter_tb;

ARCHITECTURE behavior OF counter_tb IS
	-- Vstupy
	SIGNAL CLK          : STD_LOGIC := '0';
	SIGNAL RESET        : STD_LOGIC := '0';

	-- Vystupy
	SIGNAL EN1          : STD_LOGIC;
	SIGNAL EN2          : STD_LOGIC;
	SIGNAL EN3          : STD_LOGIC;

	-- Clock period definitions
	CONSTANT CLK_period : TIME := 10 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	--    muzete samozrejme nastavit i genericke parametry!
	--    pozor na dobu simulace (nenastavujte moc dlouhe casy nebo zkratte CLK_period)
	--    Pocitejte s tim, ze pri zkouseni pobezi testbench 100 ms
	uut : ENTITY work.counter PORT MAP (
		CLK   => CLK,
		RESET => RESET,
		EN1   => EN1,
		EN2   => EN2,
		EN3   => EN3
		);

	-- Clock process definitions
	CLK_process : PROCESS
	BEGIN
		CLK <= '0';
		WAIT FOR CLK_period/2;
		CLK <= '1';
		WAIT FOR CLK_period/2;
	END PROCESS;
	-- Stimulus process
	stim_proc : PROCESS
	BEGIN
		-- hold reset state for 100 ns.
		RESET <= '1';
		WAIT FOR 100 ns;
		RESET <= '0';

		WAIT FOR CLK_period * 10;

		-- insert stimulus here 

		WAIT;
	END PROCESS;

END;
