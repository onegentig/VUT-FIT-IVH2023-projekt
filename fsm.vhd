-- Stavova logika
-- @author Onegen Something <xonege99@vutbr.cz>
-- @date 2023-04-22
--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

LIBRARY work;
USE work.effects_pack.ALL;

ENTITY fsm IS
	PORT (
		CLK       : IN STD_LOGIC;
		CNT_ANIM  : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		DIRECTION : OUT DIRECTION_T;
		EN        : OUT STD_LOGIC := '0';
		RST       : OUT STD_LOGIC := '1'
	);
END ENTITY fsm;

ARCHITECTURE behavioral OF fsm IS
	SIGNAL pstate   : STATE_T := RIGHT_ROTATION; -- Aktualny stav

	SIGNAL CNT_ROT  : INTEGER := 0;              -- Citac otociek
	SIGNAL CNT_STEP : INTEGER := 0;              -- Citac krokov
BEGIN
	state_logic : PROCESS (CLK) IS
	BEGIN
		IF rising_edge(CLK) THEN
			IF CNT_ANIM = "00000000" THEN
				CNT_STEP <= CNT_STEP + 1;
			END IF;

			CASE pstate IS
				WHEN RIGHT_ROTATION =>
					DIRECTION <= DIR_RIGHT;

					IF CNT_ANIM = "10000000" THEN
						EN <= '1';
					ELSE
						EN <= '0';
					END IF;

					IF CNT_STEP = 16 THEN
						CNT_STEP <= 0;
						CNT_ROT  <= CNT_ROT + 1;
					END IF;

					IF CNT_ROT = 3 THEN
						RST     <= '1';
						CNT_ROT <= 0;
						pstate  <= LEFT_ROTATION;
					ELSE
						RST <= '0';
					END IF;

				WHEN LEFT_ROTATION =>
					DIRECTION <= DIR_LEFT;

					IF CNT_ANIM = "10000000" THEN
						EN <= '1';
					ELSE
						EN <= '0';
					END IF;

					IF CNT_STEP = 16 THEN
						CNT_STEP <= 0;
						CNT_ROT  <= CNT_ROT + 1;
					END IF;

					IF CNT_ROT = 3 THEN
						RST     <= '1';
						CNT_ROT <= 0;
						pstate  <= ROLL_UP;
					END IF;

				WHEN ROLL_UP =>
					DIRECTION <= DIR_TOP;

					IF CNT_ANIM = "10000000" THEN
						EN <= '1';
					ELSE
						EN <= '0';
					END IF;

					IF CNT_STEP = 8 THEN
						RST    <= '1';
						pstate <= OWN_ANIM;
					ELSE
						RST <= '0';
					END IF;

				WHEN OWN_ANIM =>
					-- TODO
					EN <= '0';
			END CASE;
		END IF;
	END PROCESS;
END ARCHITECTURE behavioral;
