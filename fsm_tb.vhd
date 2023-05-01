-- Testbench stavovej logiky
-- @author Onegen Something <xonege99@vutbr.cz>
-- @date 2023-05-01
-- 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY work;
USE work.effects_pack.ALL;

ENTITY fsm_tb IS
END fsm_tb;

ARCHITECTURE behavior OF fsm_tb IS
	-- Vstupy
	SIGNAL EN           : STD_LOGIC := '0';
	SIGNAL RESET        : STD_LOGIC := '0';

	-- Vystupy
	SIGNAL DIRECTION    : DIRECTION_T;
	SIGNAL COL_EN       : STD_LOGIC;
	SIGNAL COL_RST      : STD_LOGIC;

	-- Hodiny
	CONSTANT CLK_period : TIME      := 10 ns;
	SIGNAL CLK          : STD_LOGIC := '0';

	-- Vlajka pre koniec testu
	SIGNAL DONE         : BOOLEAN   := FALSE;
BEGIN
	-- Instanciacia jednotky pod testom (UUT)
	uut : ENTITY work.fsm
		PORT MAP(
			CLK       => CLK,
			EN        => EN,
			RST       => RESET,
			DIRECTION => DIRECTION,
			COL_EN    => COL_EN,
			COL_RST   => COL_RST
		);

	-- Hodinovy proces
	CLK_process : PROCESS BEGIN
		IF done = TRUE THEN
			WAIT;
		END IF;

		CLK <= '0';
		WAIT FOR CLK_period/2;
		CLK <= '1';
		WAIT FOR CLK_period/2;
	END PROCESS;

	-- Stimulus
	stim_proc : PROCESS IS
		VARIABLE cnt      : INTEGER := 0;
		VARIABLE fail_all : BOOLEAN := FALSE;
	BEGIN
		RESET <= '1';
		WAIT FOR 100 ns;
		RESET <= '0';

		REPORT "======================================" SEVERITY NOTE;
		REPORT "*            fsm testbench           *" SEVERITY NOTE;
		REPORT "======================================" SEVERITY NOTE;
		REPORT " " SEVERITY NOTE;

		-- Pociatocny stav
		ASSERT DIRECTION = DIR_RIGHT
		REPORT "FAIL! Pociatocny stav nie je DIR_RIGHT" SEVERITY ERROR;

		-- Posun doprava
		EN <= '1';
		FOR i IN 1 TO (16 * 3) LOOP
			WAIT FOR CLK_period;
			ASSERT (DIRECTION = DIR_RIGHT) AND (COL_EN = '1') AND (COL_RST = '0')
			REPORT "FAIL! Neocakavany stav pri pohybe doprava" SEVERITY ERROR;
			IF (DIRECTION /= DIR_RIGHT) THEN
				fail_all := TRUE;
			END IF;
		END LOOP;

		WAIT FOR CLK_period;
		ASSERT (COL_EN = '0') AND (COL_RST = '1')
		REPORT "FAIL! Chybny reset alebo povolovac po pohybe doprava" SEVERITY ERROR;

		-- Posun dolava
		FOR i IN 1 TO (16 * 3) LOOP
			WAIT FOR CLK_period;
			ASSERT DIRECTION = DIR_LEFT
			REPORT "FAIL! Neocakavany stav pri pohybe dolava" SEVERITY ERROR;
			IF (DIRECTION /= DIR_LEFT) THEN
				fail_all := TRUE;
			END IF;
		END LOOP;

		WAIT FOR CLK_period;
		ASSERT (COL_EN = '0') AND (COL_RST = '1')
		REPORT "FAIL! Chybny reset alebo povolovac po pohybe dolava" SEVERITY ERROR;

		-- Posun nahor
		FOR i IN 1 TO 8 LOOP
			WAIT FOR CLK_period;
			ASSERT DIRECTION = DIR_TOP
			REPORT "FAIL! Neocakavany stav pri pohybe nahor" SEVERITY ERROR;
			IF (DIRECTION /= DIR_TOP) THEN
				fail_all := TRUE;
			END IF;
		END LOOP;

		WAIT FOR CLK_period;
		ASSERT (COL_EN = '0') AND (COL_RST = '1')
		REPORT "FAIL! Chybny reset alebo povolovac po pohybe nahor" SEVERITY ERROR;

		-- Ripple (vlastna animacia)
		FOR i IN 1 TO 5 LOOP
			WAIT FOR CLK_period;
			ASSERT DIRECTION = DIR_TOP_BOTTOM
			REPORT "FAIL! Neocakavany stav pri obojsmernom posuve" SEVERITY ERROR;
			IF (DIRECTION /= DIR_TOP_BOTTOM) THEN
				fail_all := TRUE;
			END IF;
		END LOOP;

		ASSERT fail_all = TRUE REPORT "PASS! Spravny pohyb stavov" SEVERITY NOTE;

		-- Reset test
		RESET <= '1';
		WAIT FOR CLK_period;
		ASSERT (COL_EN = '0') AND (COL_RST = '1')
		REPORT "FAIL! Chybne EN/RST po FSM resete" SEVERITY ERROR;

		RESET <= '0';
		WAIT FOR CLK_period;
		ASSERT (COL_EN = '1') AND (COL_RST = '0')
		REPORT "FAIL! Chybne EN/RST po FSM resete" SEVERITY ERROR;

		ASSERT DIRECTION /= DIR_RIGHT REPORT "PASS! Spravny smer po resete" SEVERITY NOTE;
		ASSERT DIRECTION = DIR_RIGHT REPORT "FAIL! Nespravny smer po resete" SEVERITY ERROR;

		DONE <= TRUE;
		WAIT;
	END PROCESS;
END;
