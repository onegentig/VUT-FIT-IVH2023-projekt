-- TestBench pre package effects_pack.vhd
-- @author Onegen Something <xonege99@vutbr.cz>
-- @date 2023-03-09
--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY work;
USE work.effects_pack.ALL;

ENTITY effects_pack_tb IS
END effects_pack_tb;

ARCHITECTURE behavior OF effects_pack_tb IS
	SIGNAL DATA_1 : STD_LOGIC_VECTOR(0 TO 11) := "101001100111";
	SIGNAL RES_1  : STD_LOGIC_VECTOR(0 TO 2)  := (OTHERS => '0');
BEGIN
	PROCESS IS
		VARIABLE n2n_a : NATURAL := 0;
		VARIABLE n2n_r : NATURAL := 0;
	BEGIN
		WAIT FOR 1 ps;
		-- ----------------------------------------------------------------
		--                         TEST GETCOLUMN
		-- ----------------------------------------------------------------
		REPORT "======== GETCOLUMN() ========";
		RES_1 <= GETCOLUMN(DATA_1, 0, 3);
		WAIT FOR 1 ps;
		ASSERT RES_1 = "101" REPORT "FAIL! GETCOLUMN(DATA, 0, 3) /= 101" SEVERITY ERROR;
		ASSERT RES_1 /= "101" REPORT "PASS! GETCOLUMN(DATA, 0, 3) == 101" SEVERITY NOTE;

		RES_1 <= GETCOLUMN(DATA_1, 1, 3);
		WAIT FOR 1 ps;
		ASSERT RES_1 = "001" REPORT "FAIL! GETCOLUMN(DATA, 1, 3) /= 001" SEVERITY ERROR;
		ASSERT RES_1 /= "001" REPORT "PASS! GETCOLUMN(DATA, 1, 3) == 001" SEVERITY NOTE;

		RES_1 <= GETCOLUMN(DATA_1, 4, 3);
		WAIT FOR 1 ps;
		ASSERT RES_1 = "101" REPORT "FAIL! GETCOLUMN(DATA, 4, 3) /= 101" SEVERITY ERROR;
		ASSERT RES_1 /= "101" REPORT "PASS! GETCOLUMN(DATA, 4, 3) == 101" SEVERITY NOTE;

		WAIT;
	END PROCESS;
END;
