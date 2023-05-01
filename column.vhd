-- Stlpec LED displeja
-- @author Onegen Something <xonege99@vutbr.cz>
-- @date 2023-04-22
--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY work;
USE work.effects_pack.ALL;

ENTITY column IS
	GENERIC (
		N : POSITIVE := 8
	);

	PORT (
		CLK         : IN STD_LOGIC;
		RESET       : IN STD_LOGIC;
		STATE       : BUFFER STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		INIT_STATE  : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		NEIGH_LEFT  : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		NEIGH_RIGHT : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		DIRECTION   : IN DIRECTION_T;
		EN          : IN STD_LOGIC
	);
END column;

ARCHITECTURE behavioral OF column IS

BEGIN
	PROCESS (CLK, RESET) BEGIN
		IF RESET = '1' THEN
			----- Reset -----
			STATE <= INIT_STATE;
		ELSIF rising_edge(CLK) AND (EN = '1') THEN
			IF (DIRECTION = DIR_LEFT) THEN
				----- Posun vlavo -----
				STATE <= NEIGH_RIGHT;
			ELSIF (DIRECTION = DIR_RIGHT) THEN
				----- Posun vpravo -----
				STATE <= NEIGH_LEFT;
			ELSIF (DIRECTION = DIR_TOP) THEN
				----- Shift nahor -----
				STATE(N - 1 DOWNTO 1) <= STATE(N - 2 DOWNTO 0);
				STATE(0)              <= '0';
			ELSIF (DIRECTION = DIR_TOP_BOTTOM) THEN
				----- Ripple efekt -----
				STATE(N - 1 DOWNTO (N / 2) + 1) <= STATE(N - 2 DOWNTO (N / 2));
				STATE((N / 2) - 1 DOWNTO 0)     <= STATE((N / 2) DOWNTO 1);
				STATE((N / 2))                  <= '0';
			END IF;
		END IF;
	END PROCESS;
END behavioral;
