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
		EN        : OUT STD_LOGIC := '0'
	);
END ENTITY fsm;

ARCHITECTURE behavioral OF fsm IS
	SIGNAL pstate   : STATE_T := RIGHT_ROTATION; -- Aktualny stav

	SIGNAL cnt_rot  : INTEGER := 0;              -- Citac otociek
	SIGNAL cnt_step : INTEGER := 0;              -- Citac krokov
BEGIN
	state_logic : PROCESS (CLK) IS
	BEGIN
		IF rising_edge(CLK) THEN
			IF cnt_anim = "00000000" THEN
				cnt_step <= cnt_step + 1;
			END IF;

			CASE pstate IS
				WHEN RIGHT_ROTATION =>
					DIRECTION <= DIR_RIGHT;

					IF cnt_anim = "10000000" THEN
						EN <= '1';
					ELSE
						EN <= '0';
					END IF;

					IF cnt_step = 16 THEN
						cnt_step <= 0;
						cnt_rot  <= cnt_rot + 1;
					END IF;

					IF cnt_rot = 3 THEN
						pstate  <= LEFT_ROTATION;
						cnt_rot <= 0;
					END IF;

				WHEN LEFT_ROTATION =>
					DIRECTION <= DIR_LEFT;

					IF cnt_anim = "10000000" THEN
						EN <= '1';
					ELSE
						EN <= '0';
					END IF;

					IF cnt_step = 16 THEN
						cnt_step <= 0;
						cnt_rot  <= cnt_rot + 1;
					END IF;

					IF cnt_rot = 3 THEN
						pstate  <= ROLL_UP;
						cnt_rot <= 0;
					END IF;

				WHEN ROLL_UP =>
					DIRECTION <= DIR_TOP;

					IF cnt_anim = "10000000" THEN
						EN <= '1';
					ELSE
						EN <= '0';
					END IF;

					IF cnt_step = 8 THEN
						pstate <= OWN_ANIM;
					END IF;

				WHEN OWN_ANIM =>
					-- TODO
					EN <= '0';
			END CASE;
		END IF;
	END PROCESS;
END ARCHITECTURE behavioral;
