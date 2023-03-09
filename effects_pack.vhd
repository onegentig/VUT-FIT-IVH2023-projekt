-- Balik funkcii a vyctov pre IVH projekt 2023
-- @author Onegen Something <xonege99@vutbr.cz>
-- @date 2023-03-09
--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

PACKAGE effects_pack IS

	-- Vycet smerov
	TYPE DIRECTION_T IS (DIR_LEFT, DIR_RIGHT, DIR_TOP);

	-- Funkcia GETCOLUMN vracia stlpec dlzky ROWS z 2D matice, ktoru reprezentuje DATA
	-- COLID vybera ktory stlpec vratit, indexovany od vrchu (0 to ROWS*COLS-1)
	-- Pokial je COLID vacsie ako maximalny pocet stlpcov, vracia prvy stlpec
	-- Pokial je COLID mensie ako 0, vracia posledny stlpec
	-- Vracia 'X' v pripade chyby
	FUNCTION GETCOLUMN (SIGNAL DATA : IN STD_LOGIC_VECTOR; COLID : IN INTEGER; ROWS : IN INTEGER) RETURN STD_LOGIC_VECTOR;

	-- Funkcia NEAREST2N vracia najblizsiu mocninu dvojky pre cislo DATA
	FUNCTION NEAREST2N (DATA : IN NATURAL) RETURN NATURAL;

END effects_pack;

PACKAGE BODY effects_pack IS

	FUNCTION GETCOLUMN (SIGNAL DATA : IN STD_LOGIC_VECTOR; COLID : IN INTEGER; ROWS : IN INTEGER) RETURN STD_LOGIC_VECTOR IS
		VARIABLE COLS : INTEGER;
		VARIABLE I    : INTEGER;
	BEGIN
		-- DATA nemoze byt prazdny a ROWS musi byt vacsi ako 0
		IF DATA'LENGTH = 0 OR ROWS <= 0 THEN
			RETURN "";
		END IF;

		-- Pocet stlpcov
		COLS := DATA'LENGTH / ROWS;

		IF COLID >= COLS THEN
			-- COLID mimo rozsah  -> prvy stlpec
			I := 0;
		ELSIF COLID < 0 THEN
			-- COLID mensie ako 0 -> posledny stlpec
			I := COLS - 1;
		ELSE
			-- COLID v rozsahu
			I := COLID;
		END IF;

		-- Navrat stlpca z matice
		RETURN DATA(I * ROWS TO (ROWS * I) + (ROWS - 1));
	END FUNCTION;

	FUNCTION NEAREST2N (DATA : IN NATURAL) RETURN NATURAL IS
		VARIABLE N               : REAL;    -- REAL(DATA)
		VARIABLE LG              : NATURAL; -- LOG2(N)
	BEGIN
		-- DATA nemoze byt 0
		IF DATA <= 0 THEN
			RETURN 0;
		END IF;

		-- Cast na real
		N  := REAL(DATA);

		-- Vypocet logaritmu
		LG := NATURAL(FLOOR(LOG2(N)));

		-- Cislo uz je mocnina dvojky
		IF LG ** 2 = NATURAL(N) THEN
			RETURN DATA;
		END IF;

		RETURN NATURAL(2 ** (LG + 1));
	END FUNCTION;

END effects_pack;
