-- Balik funkcii a vyctov pre IVH projekt 2023
-- @author Onegen Something <xonege99@vutbr.cz>
-- @date 2023-03-09
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package effects_pack is

	-- Vycet smerov pre posuv obrazu
	type DIRECTION_T is (DIR_RIGHT, DIR_LEFT, DIR_TOP, DIR_TOP_BOTTOM, DIR_NEGATE);  -- DIR_TOP_BOTTOM a DIR_NEGATE su vlastne efekty

	-- Vycet pre stavy FSM
	type STATE_T is (RIGHT_ROTATION, LEFT_ROTATION, ROLL_UP, CHECKERBOARD, RIPPLE);  -- CHECKERBOARD a RIPPLE su vlastne efekty

	-- Typ pre maticovy displej
	type MATRIX_T is array (0 to 15) of std_logic_vector(7 downto 0);

	-- Funkcia GETCOLUMN vracia stlpec dlzky ROWS z 2D matice, ktoru reprezentuje DATA
	-- COLID vybera ktory stlpec vratit, indexovany od vrchu (0 to ROWS*COLS-1)
	-- Pokial je COLID vacsie ako maximalny pocet stlpcov, vracia prvy stlpec
	-- Pokial je COLID mensie ako 0, vracia posledny stlpec
	-- Vracia 'X' v pripade chyby
	function GETCOLUMN (signal DATA : in std_logic_vector; COLID : in integer; ROWS : in integer) return std_logic_vector;

	-- Funkcia NEAREST2N vracia najblizsiu mocninu dvojky pre cislo DATA
	-- Pokial DATA uz je mocnina dvojky, vracia DATA
	function NEAREST2N (DATA : in natural) return natural;

end effects_pack;

package body effects_pack is

	function GETCOLUMN (signal DATA : in std_logic_vector; COLID : in integer; ROWS : in integer) return std_logic_vector is
		variable COLS : integer;
		variable I    : integer;
	begin
		-- DATA nemoze byt prazdny a ROWS musi byt vacsi ako 0
		if DATA'length = 0 or ROWS <= 0 then
			return "X";
		end if;

		-- Pocet stlpcov
		COLS := DATA'length / ROWS;

		if COLID >= COLS then
			-- COLID mimo rozsah  -> prvy stlpec
			I := 0;
		elsif COLID < 0 then
			-- COLID mensie ako 0 -> posledny stlpec
			I := COLS - 1;
		else
			-- COLID v rozsahu
			I := COLID;
		end if;

		-- Navrat stlpca z matice
		return DATA((ROWS * I) + (ROWS - 1) downto I * ROWS);
	end function;

	function NEAREST2N (DATA : in natural) return natural is
		variable LG : real;           -- LOG2(N)
	begin
		-- DATA nemoze byt mensie alebo rovne 0
		--   D(log2) = (0, inf>
		if DATA <= 0 then
			return 1;
		end if;

		-- Vypocet logaritmu
		LG := LOG2(real(DATA));

		-- Ak je logaritmus cele cislo, parameter uz je mocnina 2
		if LG = real(natural(LG)) then
			return DATA;
		end if;

		return 2 ** (natural(FLOOR(LG)) + 1);
	end function;

end effects_pack;
