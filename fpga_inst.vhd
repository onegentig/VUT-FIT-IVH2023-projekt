LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

LIBRARY work;
USE work.effects_pack.ALL;

ARCHITECTURE behavioral OF tlv_gp_ifc IS
	CONSTANT IS_SIM    : BOOLEAN                       := TRUE;

	--CONSTANT INIT_FREQ : INTEGER := 25000000; -- pre beh
	--CONSTANT INIT_FREQ : INTEGER := 25; -- pre  simulaciu
	--SUBTYPE CNT_T IS INTEGER RANGE 0 TO INIT_FREQ;
	--CONSTANT INIT_FREQ : INTEGER := (IF SIMULATION THEN 5 ELSE 24);
	--SIGNAL CNT         : STD_LOGIC_VECTOR(INIT_FREQ - 1 DOWNTO 0) := (OTHERS => '0');

	SIGNAL A           : STD_LOGIC_VECTOR(3 DOWNTO 0)  := "0001";     -- Adresa stlpca
	SIGNAL R           : STD_LOGIC_VECTOR(7 DOWNTO 0)  := "01011100"; -- Stav stlpca
	SIGNAL EN          : STD_LOGIC                     := '1';
	SIGNAL CNT         : STD_LOGIC_VECTOR(23 DOWNTO 0) := (OTHERS => '0'); -- 1s - 25MHz / 20M ~ 24b
	SIGNAL RST         : STD_LOGIC                     := '0';

	SIGNAL DIRECTION_i : DIRECTION_T;
	SIGNAL COL_RST     : STD_LOGIC                     := '1';
	SIGNAL CNT_REFRESH : STD_LOGIC_VECTOR(7 DOWNTO 0); -- Citac pre obnovu displeja
	SIGNAL CNT_ANIM    : STD_LOGIC_VECTOR(7 DOWNTO 0); -- Citac pre ovladanie animacie
	SIGNAL STAT_INIT   : MATRIX_T := (OTHERS => (OTHERS => '0'));
	SIGNAL STAT_COL    : MATRIX_T := STAT_INIT;
	SIGNAL NEIGH_L     : MATRIX_T;
	SIGNAL NEIGH_R     : MATRIX_T;
	SIGNAL ROM_OUT     : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
	-- -----------------------
	--        Citace
	-- -----------------------
	CNT_REFRESH <= CNT(23 DOWNTO 16);
	CNT_ANIM    <= CNT(15 DOWNTO 8);

	p_cnt : PROCESS (CLK) IS
	BEGIN
		IF rising_edge(CLK) THEN
			IF IS_SIM THEN
				IF CNT = "111111111111111111111111" THEN
					CNT <= (OTHERS => '0');
				ELSE
					CNT <= CNT + "000000000000000100000000";
				END IF;
			ELSE
				CNT <= CNT + 1;
			END IF;

			IF conv_integer(CNT) = 0 THEN
				A <= A + 1;
			END IF;
		END IF;
	END PROCESS;

	-- -----------------------
	--         FSM
	-- -----------------------
	fsm_inst : ENTITY work.fsm
		PORT MAP(
			CLK       => CLK,
			CNT_ANIM  => CNT_ANIM,
			DIRECTION => DIRECTION_i,
			EN        => EN,
			RST       => COL_RST
		);

	-- -----------------------
	--        Stlpce
	-- -----------------------
	COLUMN_MAP : FOR i IN 0 TO 15 GENERATE
		column_inst : ENTITY work.column
			PORT MAP(
				CLK         => CLK,
				RESET       => COL_RST,
				STATE       => STAT_COL(i),
				INIT_STATE  => STAT_INIT(i),
				NEIGH_LEFT  => NEIGH_L(i),
				NEIGH_RIGHT => NEIGH_R(i),
				DIRECTION   => DIRECTION_i,
				EN          => EN
			);
	END GENERATE;

	-- Prepojenie susedov
	NEIGH_L(0)  <= STAT_COL(15);
	NEIGH_R(15) <= STAT_COL(0);

	LEFT_MAP_GEN : FOR i IN 1 TO 15 GENERATE
		NEIGH_L(i) <= STAT_COL(i - 1);
	END GENERATE;

	RIGHT_MAP_GEN : FOR i IN 0 TO 14 GENERATE
		NEIGH_R(i) <= STAT_COL(i + 1);
	END GENERATE;

	-- -----------------------
	--         ROM
	-- -----------------------
	rom_inst : ENTITY work.rom
		PORT MAP(
			ADDR => A,
			DATA => ROM_OUT
		);

	-- Prepojenie ROM a STAT_INIT
	INIT_MAP : FOR i IN 0 TO 15 GENERATE
		STAT_INIT(i) <= ROM_OUT;
	END GENERATE;

	-- -----------------------
	--       Displej
	-- -----------------------
	p_display : PROCESS (CLK) IS
	BEGIN
		IF rising_edge(CLK) THEN
			R <= STAT_COL(conv_integer(A));
		END IF;
	END PROCESS;

	-- Mapovani vystupu
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
