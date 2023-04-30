-- Testbench pre stlpec LED displeja
-- @author Onegen Something <xonege99@vutbr.cz>
-- @date 2023-04-30
-- 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY work;
USE work.effects_pack.ALL;

ENTITY column_tb IS
END column_tb;

ARCHITECTURE behavior OF column_tb IS
	-- Vstupy
	SIGNAL CLK          : STD_LOGIC   := '0';
	SIGNAL EN           : STD_LOGIC   := '0';
	SIGNAL RESET        : STD_LOGIC   := '0';
	SIGNAL DIRECTION    : DIRECTION_T := DIR_LEFT;

	-- Hodinova perioda
	CONSTANT CLK_period : TIME        := 10 ns;

	-- Pamat ROM
	TYPE MATRIX_T IS ARRAY (0 TO 2) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	CONSTANT ROM : MATRIX_T := (
		X"AA",
		X"CC",
		X"FF"
	);

	-- Stavy stlpcov
	SIGNAL NEIGH_L  : MATRIX_T;
	SIGNAL NEIGH_R  : MATRIX_T;
	SIGNAL STAT_COL : MATRIX_T := (OTHERS => (OTHERS => '0'));

	-- Vlajka pre koniec testu
	SIGNAL DONE     : BOOLEAN  := FALSE;
BEGIN
	-- Instanciacia troch susednych stlpcov
	COLUMN_MAP : FOR i IN 0 TO 2 GENERATE
		col_i : ENTITY work.column
			PORT MAP(
				CLK         => CLK,
				RESET       => RESET,
				STATE       => STAT_COL(i),
				INIT_STATE  => ROM(i),
				NEIGH_LEFT  => NEIGH_L(i),
				NEIGH_RIGHT => NEIGH_R(i),
				DIRECTION   => DIRECTION,
				EN          => EN
			);
	END GENERATE;

	-- Prepojenie susedov
	NEIGH_L(0) <= STAT_COL(2);
	NEIGH_L(1) <= STAT_COL(0);
	NEIGH_L(2) <= STAT_COL(1);
	NEIGH_R(0) <= STAT_COL(1);
	NEIGH_R(1) <= STAT_COL(2);
	NEIGH_R(2) <= STAT_COL(0);

	-- Hodinovy proces
	CLK_process : PROCESS BEGIN
		IF DONE = TRUE THEN
			WAIT;
		END IF;

		CLK <= '0';
		WAIT FOR CLK_period/2;
		CLK <= '1';
		WAIT FOR CLK_period/2;
	END PROCESS;

	-- Stimulus
	stim_proc : PROCESS IS
		VARIABLE passed   : BOOLEAN := FALSE;
		VARIABLE pass_cnt : INTEGER := 0;
	BEGIN
		RESET <= '1';
		WAIT FOR 100 ns;
		RESET <= '0';
		WAIT FOR CLK_period;

		REPORT "======================================" SEVERITY NOTE;
		REPORT "*          column testbench          *" SEVERITY NOTE;
		REPORT "======================================" SEVERITY NOTE;
		REPORT " " SEVERITY NOTE;

		-- Test pociatocneho stavu
		passed := (STAT_COL(0) = X"AA") AND (STAT_COL(1) = X"CC")
			AND (STAT_COL(2) = X"FF");
		ASSERT passed = TRUE REPORT "FAIL! Pociatocny stav" SEVERITY ERROR;
		ASSERT passed = FALSE REPORT "PASS! Pociatocny stav" SEVERITY NOTE;

		-- Posun vlavo
		DIRECTION <= DIR_LEFT;
		EN        <= '1';
		WAIT FOR CLK_period;
		passed := (STAT_COL(0) = X"CC") AND (STAT_COL(1) = X"FF")
			AND (STAT_COL(2) = X"AA");
		ASSERT passed = TRUE REPORT "FAIL! Posun vlavo #1" SEVERITY ERROR;
		IF passed THEN
			pass_cnt := pass_cnt + 1;
		END IF;

		WAIT FOR CLK_period;
		passed := (STAT_COL(0) = X"FF") AND (STAT_COL(1) = X"AA")
			AND (STAT_COL(2) = X"CC");
		ASSERT passed = TRUE REPORT "FAIL! Posun vlavo #2" SEVERITY ERROR;
		IF passed THEN
			pass_cnt := pass_cnt + 1;
		END IF;

		WAIT FOR CLK_period;
		passed := (STAT_COL(0) = X"AA") AND (STAT_COL(1) = X"CC")
			AND (STAT_COL(2) = X"FF");
		ASSERT passed = TRUE REPORT "FAIL! Posun vlavo #3" SEVERITY ERROR;
		IF passed THEN
			pass_cnt := pass_cnt + 1;
		END IF;

		ASSERT pass_cnt /= 3 REPORT "PASS! Posun vlavo" SEVERITY NOTE;
		pass_cnt := 0;

		-- Posun vpravo
		DIRECTION <= DIR_RIGHT;
		WAIT FOR CLK_period;
		passed := (STAT_COL(0) = X"FF") AND (STAT_COL(1) = X"AA")
			AND (STAT_COL(2) = X"CC");
		ASSERT passed = TRUE REPORT "FAIL! Posun vpravo #1" SEVERITY ERROR;
		IF passed THEN
			pass_cnt := pass_cnt + 1;
		END IF;

		WAIT FOR CLK_period;
		passed := (STAT_COL(0) = X"CC") AND (STAT_COL(1) = X"FF")
			AND (STAT_COL(2) = X"AA");
		ASSERT passed = TRUE REPORT "FAIL! Posun vpravo #2" SEVERITY ERROR;
		IF passed THEN
			pass_cnt := pass_cnt + 1;
		END IF;

		WAIT FOR CLK_period;
		passed := (STAT_COL(0) = X"AA") AND (STAT_COL(1) = X"CC")
			AND (STAT_COL(2) = X"FF");
		ASSERT passed = TRUE REPORT "FAIL! Posun vpravo #3" SEVERITY ERROR;
		IF passed THEN
			pass_cnt := pass_cnt + 1;
		END IF;

		ASSERT pass_cnt /= 3 REPORT "PASS! Posun vpravo" SEVERITY NOTE;
		pass_cnt := 0;

		-- Rolovanie nahor
		DIRECTION <= DIR_TOP;

		FOR i IN 1 TO 8 LOOP
			WAIT FOR CLK_period;

			passed := (UNSIGNED(STAT_COL(0)) = X"AA" SLL i)
				AND (UNSIGNED(STAT_COL(1)) = X"CC" SLL i)
				AND (UNSIGNED(STAT_COL(2)) = X"FF" SLL i);
			ASSERT passed = TRUE REPORT "FAIL! Rolovanie nahor #" & INTEGER'IMAGE(i) SEVERITY ERROR;
			IF passed THEN
				pass_cnt := pass_cnt + 1;
			END IF;
		END LOOP;

		ASSERT pass_cnt /= 8 REPORT "PASS! Rolovanie nahor" SEVERITY NOTE;

		-- Reset
		RESET <= '1';
		WAIT FOR CLK_period;
		RESET <= '0';
		passed := (STAT_COL(0) = X"AA") AND (STAT_COL(1) = X"CC")
			AND (STAT_COL(2) = X"FF");
		ASSERT passed = TRUE REPORT "FAIL! Reset" SEVERITY ERROR;
		ASSERT passed = FALSE REPORT "PASS! Reset" SEVERITY NOTE;

		EN   <= '0';
		DONE <= TRUE;
		WAIT;
	END PROCESS;
END;
