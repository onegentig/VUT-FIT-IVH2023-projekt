-- Stavova logika projektu
-- @author Onegen Something <xonege99@vutbr.cz>
-- @date 2023-04-22
--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY work;
USE work.effects_pack.ALL;

ENTITY fsm IS
	PORT (
		CLK       : IN STD_LOGIC;
		EN        : IN STD_LOGIC;
		RST       : IN STD_LOGIC;
		DIRECTION : OUT DIRECTION_T;
		COL_EN    : OUT STD_LOGIC := '0';
		COL_RST   : OUT STD_LOGIC := '1'
	);
END ENTITY fsm;

ARCHITECTURE behavioral OF fsm IS
	SIGNAL pstate   : STATE_T := RIGHT_ROTATION; -- Aktualny stav

	SIGNAL CNT_ROT  : INTEGER := 0;              -- Citac otociek
	SIGNAL CNT_STEP : INTEGER := 0;              -- Citac krokov
BEGIN
	state_logic : PROCESS (CLK) IS
	BEGIN
		IF RST = '1' THEN
			pstate   <= RIGHT_ROTATION;
			CNT_ROT  <= 0;
			CNT_STEP <= 0;
			COL_EN   <= '0';
			COL_RST  <= '1';
		ELSIF rising_edge(CLK) AND EN = '1' THEN
			CNT_STEP <= CNT_STEP + 1;
			COL_EN   <= '1';

			CASE pstate IS
				WHEN RIGHT_ROTATION =>
					DIRECTION <= DIR_RIGHT;

					IF (CNT_STEP = 16 - 1) THEN
						CNT_ROT  <= CNT_ROT + 1;
						CNT_STEP <= 0;
					END IF;

					IF CNT_ROT = 3 THEN
						CNT_ROT  <= 0;
						CNT_STEP <= 0;
						COL_EN   <= '0';
						COL_RST  <= '1';
						pstate   <= LEFT_ROTATION;
					ELSE
						COL_RST <= '0';
					END IF;

				WHEN LEFT_ROTATION =>
					DIRECTION <= DIR_LEFT;

					IF (CNT_STEP = 16 - 1) THEN
						CNT_ROT  <= CNT_ROT + 1;
						CNT_STEP <= 0;
					END IF;

					IF (CNT_ROT = 3) THEN
						CNT_ROT  <= 0;
						CNT_STEP <= 0;
						COL_EN   <= '0';
						COL_RST  <= '1';
						pstate   <= ROLL_UP;
					END IF;

				WHEN ROLL_UP =>
					DIRECTION <= DIR_TOP;

					IF (CNT_STEP = 8 - 1) THEN
						COL_RST <= '1';
						pstate  <= OWN_ANIM;
					ELSE
						COL_RST <= '0';
					END IF;

				WHEN OWN_ANIM =>
					-- TODO
					COL_RST <= '1';
					COL_EN  <= '0';
			END CASE;
		ELSE
			COL_EN <= '0';
		END IF;
	END PROCESS;
END ARCHITECTURE behavioral;
