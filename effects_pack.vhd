LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

PACKAGE effects_pack IS

	-- Výčet smerov
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
		-- DATA nemôže byť prázdny a ROWS musí byť väčší ako 0
		IF DATA'LENGTH = 0 OR ROWS <= 0 THEN
			RETURN (OTHERS => 'X');
		END IF;

		-- Počet stĺpcov
		COLS := DATA'LENGTH / ROWS;

		IF COLID >= COLS THEN
			-- COLID mimo rozsah  -> posledný stĺpec
			I := COLS - 1;
		ELSIF COLID < 0 THEN
			-- COLID menšie ako 0 -> prvý stĺpec
			I := 0;
		ELSE
			-- COLID v rozsahu
			I := COLID;
		END IF;

		-- Návrat stĺpca z matice
		RETURN DATA(I * ROWS TO (I + 1) * ROWS - 1);
	END FUNCTION;

	FUNCTION NEAREST2N (DATA : IN NATURAL) RETURN NATURAL IS
		VARIABLE N               : REAL;
		VARIABLE LG              : REAL;
	BEGIN
		-- DATA nemôže byť 0
		IF DATA <= 0 THEN
			RETURN 0;
		END IF;

		-- Cast na real
		N  := REAL(DATA);

		-- Výpočet logaritmu
		LG := FLOOR(LOG2(N));

		-- Číslo už je mocnina dvojky
		IF LG ** 2 = N THEN
			RETURN DATA;
		END IF;

		RETURN NATURAL(2 ** (LG + 1));
	END FUNCTION;

END effects_pack;
