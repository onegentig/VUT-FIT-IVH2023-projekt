-- Stavova logika projektu
-- @author Onegen Something <xkrame00@vutbr.cz>
-- @date 2023-04-22
--

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.effects_pack.all;

entity fsm is
	port (
		CLK       : in  std_logic;
		EN        : in  std_logic;
		RST       : in  std_logic;
		COL_EN    : out std_logic := '0';
		COL_RST   : out std_logic := '1';
		DIRECTION : out DIRECTION_T;
		IMAGE_IDX : out natural   := 0
	);
end entity fsm;

architecture behavioral of fsm is
	signal pstate : STATE_T := RIGHT_ROTATION;  -- Aktualny stav

	signal CNT_ROT  : integer := 0;             -- Citac otociek
	signal CNT_STEP : integer := 0;             -- Citac krokov

	-- Procedura na reset citacov a vlajok
	procedure backdown (signal STEP : out integer; signal ROT : out integer; signal ENABLE : out std_logic; signal RESET : out std_logic) is
	begin
		STEP   <= 0;
		ROT    <= 0;
		ENABLE <= '0';
		RESET  <= '1';
	end procedure;
begin
	state_logic : process (CLK, RST) is
	begin
		if RST = '1' then
			pstate    <= RIGHT_ROTATION;
			IMAGE_IDX <= 0;
			backdown(CNT_STEP, CNT_ROT, COL_EN, COL_RST);
		elsif rising_edge(CLK) then
			if EN = '1' then
				CNT_STEP <= CNT_STEP + 1;

				case pstate is
					when RIGHT_ROTATION =>
						DIRECTION <= DIR_RIGHT;

						if (CNT_STEP = 16 - 1) then
							CNT_ROT  <= CNT_ROT + 1;
							CNT_STEP <= 0;
						end if;

						if (CNT_ROT = 3) then
							pstate    <= LEFT_ROTATION;
							IMAGE_IDX <= 0;
							backdown(CNT_STEP, CNT_ROT, COL_EN, COL_RST);
						else
							COL_EN  <= '1';
							COL_RST <= '0';
						end if;

					when LEFT_ROTATION =>
						DIRECTION <= DIR_LEFT;

						if (CNT_STEP = 16 - 1) then
							CNT_ROT  <= CNT_ROT + 1;
							CNT_STEP <= 0;
						end if;

						if (CNT_ROT = 3) then
							pstate    <= ROLL_UP;
							IMAGE_IDX <= 0;
							backdown(CNT_STEP, CNT_ROT, COL_EN, COL_RST);
						else
							COL_RST <= '0';
							COL_EN  <= '1';
						end if;

					when ROLL_UP =>
						DIRECTION <= DIR_TOP;

						if (CNT_STEP = 8) then
							pstate    <= CHECKERBOARD;
							IMAGE_IDX <= 1;
							backdown(CNT_STEP, CNT_ROT, COL_EN, COL_RST);
						else
							COL_RST <= '0';
							COL_EN  <= '1';
						end if;

					when CHECKERBOARD =>
						DIRECTION <= DIR_NEGATE;
						IMAGE_IDX <= 1;
						COL_RST   <= '0';

						if (CNT_STEP = 20) then
							pstate    <= RIPPLE;
							IMAGE_IDX <= 1;
							backdown(CNT_STEP, CNT_ROT, COL_EN, COL_RST);
						else
							-- O polovicu pomalsie (epilepsy warning)
							if (CNT_STEP mod 2 = 0) then
								COL_EN <= '1';
							else
								COL_EN <= '0';
							end if;
						end if;

					when RIPPLE =>
						DIRECTION <= DIR_TOP_BOTTOM;
						IMAGE_IDX <= 1;
						COL_RST   <= '0';

						if (CNT_STEP = ((8 / 2) + 1) * 4) then
							COL_EN <= '0';
						else
							-- Stvornasobne pomalsie
							if (CNT_STEP mod 4 = 0) then
								COL_EN <= '1';
							else
								COL_EN <= '0';
							end if;
						end if;
				end case;
			else
				COL_EN <= '0';
			end if;
		end if;
	end process;
end architecture behavioral;
