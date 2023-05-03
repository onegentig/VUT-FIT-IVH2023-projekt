-- Stavova logika projektu
-- @author Onegen Something <xonege99@vutbr.cz>
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
		DIRECTION : out DIRECTION_T;
		COL_EN    : out std_logic := '0';
		COL_RST   : out std_logic := '1'
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
			pstate <= RIGHT_ROTATION;
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
							backdown(CNT_STEP, CNT_ROT, COL_EN, COL_RST);
							pstate <= LEFT_ROTATION;
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
							backdown(CNT_STEP, CNT_ROT, COL_EN, COL_RST);
							pstate <= ROLL_UP;
						else
							COL_RST <= '0';
							COL_EN  <= '1';
						end if;

					when ROLL_UP =>
						DIRECTION <= DIR_TOP;

						if (CNT_STEP = 8) then
							backdown(CNT_STEP, CNT_ROT, COL_EN, COL_RST);
							pstate <= RIPPLE;
						else
							COL_RST <= '0';
							COL_EN  <= '1';
						end if;

					when RIPPLE =>
						DIRECTION <= DIR_TOP_BOTTOM;
						COL_RST   <= '0';

						if (CNT_STEP = (8 / 2) + 1) then
							COL_EN <= '0';
						else
							COL_EN <= '1';
						end if;
				end case;
			else
				COL_EN <= '0';
			end if;
		end if;
	end process;
end architecture behavioral;
