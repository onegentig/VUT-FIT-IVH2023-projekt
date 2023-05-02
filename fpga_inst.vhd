LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY work;
USE work.effects_pack.ALL;

ARCHITECTURE behavioral OF tlv_gp_ifc IS
	-- @constant {INTEGER} INIT_FREQ
	-- Zakladna frekvencia pre beh, pre FITKit 25MHz, mensia pre simulaciu.
	CONSTANT INIT_FREQ : INTEGER  := 25; -- pre beh
	--CONSTANT INIT_FREQ : INTEGER := 5; -- pre simulaciu

	-- @constant {POSITIVE} WIDTH
	-- @constant {POSITIVE} HEIGHT
	-- Rozmery maticoveho displeja.
	CONSTANT WIDTH     : POSITIVE := 16;
	CONSTANT HEIGHT    : POSITIVE := 8;

	-- Stavy displeja
	SIGNAL STAT_INIT   : MATRIX_T := (OTHERS => (OTHERS => '0'));             -- Pociatocny stav displeja
	SIGNAL STAT_COL    : MATRIX_T := STAT_INIT;                               -- Stavy stlpcov
	SIGNAL NEIGH_L     : MATRIX_T;                                            -- Lave susedne stlpce
	SIGNAL NEIGH_R     : MATRIX_T;                                            -- Prave susedne stlpce

	-- Ovladanie stlpcov
	SIGNAL CLK_ANIM    : STD_LOGIC := '0';                                    -- Hodiny pre ovladanie animacie
	SIGNAL COL_EN      : STD_LOGIC := '0';                                    -- Povolovaci signal stlpcov
	SIGNAL COL_RST     : STD_LOGIC := '0';                                    -- Reset stplcov na INIT_STATE
	SIGNAL DIRECTION   : DIRECTION_T;                                         -- Smer animacie

	-- Ovladanie maticoveho displeja
	SIGNAL CLK_REFR    : STD_LOGIC                             := '0';        -- Spomalene hodiny pre obnovu displeja
	SIGNAL A           : STD_LOGIC_VECTOR(3 DOWNTO 0)          := "0000";     -- Adresa stlpca
	SIGNAL R           : STD_LOGIC_VECTOR(HEIGHT - 1 DOWNTO 0) := "01011100"; -- Stav stlpca

	-- ROM
	SIGNAL ROM_OUT     : STD_LOGIC_VECTOR(HEIGHT - 1 DOWNTO 0);

	--CONSTANT INIT_FREQ : INTEGER := 25000000; -- pre beh
	--CONSTANT INIT_FREQ : INTEGER := 25; -- pre  simulaciu
	--SUBTYPE CNT_T IS INTEGER RANGE 0 TO INIT_FREQ;
	--CONSTANT INIT_FREQ : INTEGER := (IF SIMULATION THEN 5 ELSE 24);
	--SIGNAL CNT         : STD_LOGIC_VECTOR(INIT_FREQ - 1 DOWNTO 0) := (OTHERS => '0');

	--SIGNAL EN          : STD_LOGIC                     := '1';
	--SIGNAL CNT         : STD_LOGIC_VECTOR(23 DOWNTO 0) := (OTHERS => '0'); -- 1s - 25MHz / 20M ~ 24b
	--SIGNAL RST         : STD_LOGIC                     := '0';

	--SIGNAL DIRECTION_i : DIRECTION_T;
	--SIGNAL COL_RST     : STD_LOGIC                     := '1';
	--SIGNAL CNT_REFRESH : STD_LOGIC_VECTOR(7 DOWNTO 0); -- Citac pre obnovu displeja
	--SIGNAL CNT_ANIM    : STD_LOGIC_VECTOR(7 DOWNTO 0); -- Citac pre ovladanie animacie
	--SIGNAL STAT_INIT   : MATRIX_T := (OTHERS => (OTHERS => '0'));
	--SIGNAL STAT_COL    : MATRIX_T := STAT_INIT;
	--SIGNAL NEIGH_L     : MATRIX_T;
	--SIGNAL NEIGH_R     : MATRIX_T;
	--SIGNAL ROM_OUT     : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
	-- -----------------------
	--        Citace
	-- -----------------------
	counters : ENTITY work.counter
		GENERIC MAP(
			OUT1_PERIOD => 2,              -- Pre prepinanie stplcov
			OUT2_PERIOD => 2 ** INIT_FREQ, -- Pre koordinaciu animacie
			OUT3_PERIOD => 1
		)
		PORT MAP(
			CLK   => CLK,
			RESET => RESET,
			EN1   => CLK_REFR,
			EN2   => CLK_ANIM
		);

	-- -----------------------
	--    Stavovy automat
	-- -----------------------
	fsm : ENTITY work.fsm
		PORT MAP(
			CLK       => CLK_ANIM,
			EN        => '1',
			RST       => '0',
			DIRECTION => DIRECTION,
			COL_EN    => COL_EN,
			COL_RST   => COL_RST
		);

	-- -----------------------
	--         ROM
	-- -----------------------
	rom : ENTITY work.rom
		PORT MAP(
			ADDR => A,
			DATA => ROM_OUT
		);
	STAT_INIT(to_integer(unsigned(A))) <= ROM_OUT;

	-- -----------------------
	--        Stlpce
	-- -----------------------
	COLUMN_MAP : FOR i IN 0 TO WIDTH - 1 GENERATE
		column_inst : ENTITY work.column
			GENERIC MAP(
				N => HEIGHT
			)
			PORT MAP(
				CLK         => CLK_ANIM,
				RESET       => COL_RST,
				STATE       => STAT_COL(i),
				INIT_STATE  => ROM_OUT,
				NEIGH_LEFT  => NEIGH_L(i),
				NEIGH_RIGHT => NEIGH_R(i),
				DIRECTION   => DIRECTION,
				EN          => COL_EN
			);
	END GENERATE;

	-- Prepojenie susedov
	NEIGH_L(0)         <= STAT_COL(WIDTH - 1);
	NEIGH_R(WIDTH - 1) <= STAT_COL(0);

	NEIGH_L_MAP : FOR i IN 1 TO WIDTH - 1 GENERATE
		NEIGH_L(i) <= STAT_COL(i - 1);
	END GENERATE;

	NEIGH_R_MAP : FOR i IN 0 TO WIDTH - 2 GENERATE
		NEIGH_R(i) <= STAT_COL(i + 1);
	END GENERATE;

	-- -----------------------
	--   Ovladanie displeja
	-- -----------------------
	p_display : PROCESS (CLK_REFR) BEGIN
		IF rising_edge(CLK_REFR) THEN
			A <= STD_LOGIC_VECTOR(unsigned(A) + 1);
			R <= STAT_COL(to_integer(unsigned(A)));
		END IF;
	END PROCESS;

	-- Mapovanie vystupu
	X(6)  <= A(3);
	X(8)  <= A(1);
	X(10) <= A(0);
	X(7)  <= '0'; -- en_n
	X(9)  <= A(2);
	X(16) <= R(1);
	X(18) <= R(0);
	X(20) <= R(7);
	X(22) <= R(2);
	X(17) <= R(4);
	X(19) <= R(3);
	X(21) <= R(6);
	X(23) <= R(5);
END behavioral;
