-- Testbench pre package effects_pack.vhd
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
	SIGNAL DATA_2 : STD_LOGIC_VECTOR(0 TO 23) := "000010110100110000111111";
	SIGNAL RES_2  : STD_LOGIC_VECTOR(0 TO 3)  := (OTHERS => '0');
BEGIN
	PROCESS IS
		VARIABLE n2n_a    : NATURAL := 0;
		VARIABLE n2n_r    : NATURAL := 0;
		VARIABLE cnt_pass : NATURAL := 0;
		VARIABLE cnt_fail : NATURAL := 0;
	BEGIN
		WAIT FOR 1 ps;

		REPORT "======================================" SEVERITY NOTE;
		REPORT "*      effects_pack testbench        *" SEVERITY NOTE;
		REPORT "======================================" SEVERITY NOTE;
		REPORT " " SEVERITY NOTE;

		REPORT "========= GETCOLUMN() zadanie =========" SEVERITY NOTE;
		RES_1 <= GETCOLUMN(DATA_1, 0, 3);
		WAIT FOR 1 ps;
		ASSERT RES_1 = "101" REPORT "FAIL! GETCOLUMN(DATA_1, 0, 3) /= 101" SEVERITY ERROR;
		ASSERT RES_1 /= "101" REPORT "PASS! GETCOLUMN(DATA_1, 0, 3) == 101" SEVERITY NOTE;
		IF RES_1 = "101" THEN
			cnt_pass := cnt_pass + 1;
		ELSE
			cnt_fail := cnt_fail + 1;
		END IF;

		RES_1 <= GETCOLUMN(DATA_1, 1, 3);
		WAIT FOR 1 ps;
		ASSERT RES_1 = "001" REPORT "FAIL! GETCOLUMN(DATA_1, 1, 3) /= 001" SEVERITY ERROR;
		ASSERT RES_1 /= "001" REPORT "PASS! GETCOLUMN(DATA_1, 1, 3) == 001" SEVERITY NOTE;
		IF RES_1 = "001" THEN
			cnt_pass := cnt_pass + 1;
		ELSE
			cnt_fail := cnt_fail + 1;
		END IF;

		RES_1 <= GETCOLUMN(DATA_1, 4, 3);
		WAIT FOR 1 ps;
		ASSERT RES_1 = "101" REPORT "FAIL! GETCOLUMN(DATA_1, 4, 3) /= 101" SEVERITY ERROR;
		ASSERT RES_1 /= "101" REPORT "PASS! GETCOLUMN(DATA_1, 4, 3) == 101" SEVERITY NOTE;
		IF RES_1 = "101" THEN
			cnt_pass := cnt_pass + 1;
		ELSE
			cnt_fail := cnt_fail + 1;
		END IF;

		REPORT "======== GETCOLUMN() rozsirene ========" SEVERITY NOTE;
		RES_1 <= GETCOLUMN(DATA_1, 2, 3);
		WAIT FOR 1 ps;
		ASSERT RES_1 = "100" REPORT "FAIL! GETCOLUMN(DATA_1, 2, 3) /= 100" SEVERITY ERROR;
		ASSERT RES_1 /= "100" REPORT "PASS! GETCOLUMN(DATA_1, 2, 3) == 100" SEVERITY NOTE;
		IF RES_1 = "100" THEN
			cnt_pass := cnt_pass + 1;
		ELSE
			cnt_fail := cnt_fail + 1;
		END IF;

		RES_1 <= GETCOLUMN(DATA_1, 3, 3);
		WAIT FOR 1 ps;
		ASSERT RES_1 = "111" REPORT "FAIL! GETCOLUMN(DATA_1, 3, 3) /= 111" SEVERITY ERROR;
		ASSERT RES_1 /= "111" REPORT "PASS! GETCOLUMN(DATA_1, 3, 3) == 111" SEVERITY NOTE;
		IF RES_1 = "111" THEN
			cnt_pass := cnt_pass + 1;
		ELSE
			cnt_fail := cnt_fail + 1;
		END IF;

		RES_1 <= GETCOLUMN(DATA_1, -1, 3);
		WAIT FOR 1 ps;
		ASSERT RES_1 = "111" REPORT "FAIL! GETCOLUMN(DATA_1, -1, 3) /= 111" SEVERITY ERROR;
		ASSERT RES_1 /= "111" REPORT "PASS! GETCOLUMN(DATA_1, -1, 3) == 111" SEVERITY NOTE;
		IF RES_1 = "111" THEN
			cnt_pass := cnt_pass + 1;
		ELSE
			cnt_fail := cnt_fail + 1;
		END IF;

		RES_2 <= GETCOLUMN(DATA_2, 0, 4);
		WAIT FOR 1 ps;
		ASSERT RES_2 = "0000" REPORT "FAIL! GETCOLUMN(DATA_2, 0, 4) /= 0000" SEVERITY ERROR;
		ASSERT RES_2 /= "0000" REPORT "PASS! GETCOLUMN(DATA_2, 0, 4) == 0000" SEVERITY NOTE;
		IF RES_2 = "0000" THEN
			cnt_pass := cnt_pass + 1;
		ELSE
			cnt_fail := cnt_fail + 1;
		END IF;

		RES_2 <= GETCOLUMN(DATA_2, 10, 4);
		WAIT FOR 1 ps;
		ASSERT RES_2 = "0000" REPORT "FAIL! GETCOLUMN(DATA_2, 10, 4) /= 0000" SEVERITY ERROR;
		ASSERT RES_2 /= "0000" REPORT "PASS! GETCOLUMN(DATA_2, 10, 4) == 0000" SEVERITY NOTE;
		IF RES_2 = "0000" THEN
			cnt_pass := cnt_pass + 1;
		ELSE
			cnt_fail := cnt_fail + 1;
		END IF;

		RES_2 <= GETCOLUMN(DATA_2, 5, 4);
		WAIT FOR 1 ps;
		ASSERT RES_2 = "1111" REPORT "FAIL! GETCOLUMN(DATA_2, 5, 4) /= 1111" SEVERITY ERROR;
		ASSERT RES_2 /= "1111" REPORT "PASS! GETCOLUMN(DATA_2, 5, 4) == 1111" SEVERITY NOTE;
		IF RES_2 = "1111" THEN
			cnt_pass := cnt_pass + 1;
		ELSE
			cnt_fail := cnt_fail + 1;
		END IF;

		RES_2 <= GETCOLUMN(DATA_2, -5, 4);
		WAIT FOR 1 ps;
		ASSERT RES_2 = "1111" REPORT "FAIL! GETCOLUMN(DATA_2, -5, 4) /= 1111" SEVERITY ERROR;
		ASSERT RES_2 /= "1111" REPORT "PASS! GETCOLUMN(DATA_2, -5, 4) == 1111" SEVERITY NOTE;
		IF RES_2 = "1111" THEN
			cnt_pass := cnt_pass + 1;
		ELSE
			cnt_fail := cnt_fail + 1;
		END IF;

		RES_1 <= GETCOLUMN(DATA_2, 0, 3);
		WAIT FOR 1 ps;
		ASSERT RES_1 = "000" REPORT "FAIL! GETCOLUMN(DATA_2, 0, 3) /= 000" SEVERITY ERROR;
		ASSERT RES_1 /= "000" REPORT "PASS! GETCOLUMN(DATA_2, 0, 3) == 000" SEVERITY NOTE;
		IF RES_1 = "000" THEN
			cnt_pass := cnt_pass + 1;
		ELSE
			cnt_fail := cnt_fail + 1;
		END IF;

		RES_1 <= GETCOLUMN(DATA_2, 8, 3);
		WAIT FOR 1 ps;
		ASSERT RES_1 = "000" REPORT "FAIL! GETCOLUMN(DATA_2, -8, 3) /= 000" SEVERITY ERROR;
		ASSERT RES_1 /= "000" REPORT "PASS! GETCOLUMN(DATA_2, -8, 3) == 000" SEVERITY NOTE;
		IF RES_1 = "000" THEN
			cnt_pass := cnt_pass + 1;
		ELSE
			cnt_fail := cnt_fail + 1;
		END IF;

		RES_1 <= GETCOLUMN(DATA_2, -8, 3);
		WAIT FOR 1 ps;
		ASSERT RES_1 = "111" REPORT "FAIL! GETCOLUMN(DATA_2, 8, 3) /= 111" SEVERITY ERROR;
		ASSERT RES_1 /= "111" REPORT "PASS! GETCOLUMN(DATA_2, 8, 3) == 111" SEVERITY NOTE;
		IF RES_1 = "111" THEN
			cnt_pass := cnt_pass + 1;
		ELSE
			cnt_fail := cnt_fail + 1;
		END IF;

		REPORT "========= NEAREST2N() zadanie =========" SEVERITY NOTE;
		n2n_a := 6;
		n2n_r := NEAREST2N(n2n_a);
		ASSERT n2n_r = 8 REPORT "FAIL! NEAREST2N(6) /= 8" SEVERITY ERROR;
		ASSERT n2n_r /= 8 REPORT "PASS! NEAREST2N(6) == 8" SEVERITY NOTE;
		IF n2n_r = 8 THEN
			cnt_pass := cnt_pass + 1;
		ELSE
			cnt_fail := cnt_fail + 1;
		END IF;

		n2n_a := 42;
		n2n_r := NEAREST2N(n2n_a);
		ASSERT n2n_r = 64 REPORT "FAIL! NEAREST2N(42) /= 64" SEVERITY ERROR;
		ASSERT n2n_r /= 64 REPORT "PASS! NEAREST2N(42) == 64" SEVERITY NOTE;
		IF n2n_r = 64 THEN
			cnt_pass := cnt_pass + 1;
		ELSE
			cnt_fail := cnt_fail + 1;
		END IF;

		REPORT "======== NEAREST2N() rozsirene ========" SEVERITY NOTE;
		n2n_a := 0;
		n2n_r := NEAREST2N(n2n_a);
		ASSERT n2n_r = 1 REPORT "FAIL! NEAREST2N(0) /= 1" SEVERITY ERROR;
		ASSERT n2n_r /= 1 REPORT "PASS! NEAREST2N(0) == 1" SEVERITY NOTE;
		IF n2n_r = 1 THEN
			cnt_pass := cnt_pass + 1;
		ELSE
			cnt_fail := cnt_fail + 1;
		END IF;

		n2n_a := 1;
		n2n_r := NEAREST2N(n2n_a);
		ASSERT n2n_r = 1 REPORT "FAIL! NEAREST2N(1) /= 1" SEVERITY ERROR;
		ASSERT n2n_r /= 1 REPORT "PASS! NEAREST2N(1) == 1" SEVERITY NOTE;
		IF n2n_r = 1 THEN
			cnt_pass := cnt_pass + 1;
		ELSE
			cnt_fail := cnt_fail + 1;
		END IF;

		n2n_a := 2;
		n2n_r := NEAREST2N(n2n_a);
		ASSERT n2n_r = 2 REPORT "FAIL! NEAREST2N(2) /= 2" SEVERITY ERROR;
		ASSERT n2n_r /= 2 REPORT "PASS! NEAREST2N(2) == 2" SEVERITY NOTE;
		IF n2n_r = 2 THEN
			cnt_pass := cnt_pass + 1;
		ELSE
			cnt_fail := cnt_fail + 1;
		END IF;

		n2n_a := 3;
		n2n_r := NEAREST2N(n2n_a);
		ASSERT n2n_r = 4 REPORT "FAIL! NEAREST2N(3) /= 4" SEVERITY ERROR;
		ASSERT n2n_r /= 4 REPORT "PASS! NEAREST2N(3) == 4" SEVERITY NOTE;
		IF n2n_r = 4 THEN
			cnt_pass := cnt_pass + 1;
		ELSE
			cnt_fail := cnt_fail + 1;
		END IF;

		n2n_a := 4;
		n2n_r := NEAREST2N(n2n_a);
		ASSERT n2n_r = 4 REPORT "FAIL! NEAREST2N(4) /= 4" SEVERITY ERROR;
		ASSERT n2n_r /= 4 REPORT "PASS! NEAREST2N(4) == 4" SEVERITY NOTE;
		IF n2n_r = 4 THEN
			cnt_pass := cnt_pass + 1;
		ELSE
			cnt_fail := cnt_fail + 1;
		END IF;

		n2n_a := 63;
		n2n_r := NEAREST2N(n2n_a);
		ASSERT n2n_r = 64 REPORT "FAIL! NEAREST2N(63) /= 64" SEVERITY ERROR;
		ASSERT n2n_r /= 64 REPORT "PASS! NEAREST2N(63) == 64" SEVERITY NOTE;
		IF n2n_r = 64 THEN
			cnt_pass := cnt_pass + 1;
		ELSE
			cnt_fail := cnt_fail + 1;
		END IF;

		n2n_a := 64;
		n2n_r := NEAREST2N(n2n_a);
		ASSERT n2n_r = 64 REPORT "FAIL! NEAREST2N(64) /= 64" SEVERITY ERROR;
		ASSERT n2n_r /= 64 REPORT "PASS! NEAREST2N(64) == 64" SEVERITY NOTE;
		IF n2n_r = 64 THEN
			cnt_pass := cnt_pass + 1;
		ELSE
			cnt_fail := cnt_fail + 1;
		END IF;

		n2n_a := 65;
		n2n_r := NEAREST2N(n2n_a);
		ASSERT n2n_r = 128 REPORT "FAIL! NEAREST2N(65) /= 128" SEVERITY ERROR;
		ASSERT n2n_r /= 128 REPORT "PASS! NEAREST2N(65) == 128" SEVERITY NOTE;
		IF n2n_r = 128 THEN
			cnt_pass := cnt_pass + 1;
		ELSE
			cnt_fail := cnt_fail + 1;
		END IF;

		n2n_a := 127;
		n2n_r := NEAREST2N(n2n_a);
		ASSERT n2n_r = 128 REPORT "FAIL! NEAREST2N(127) /= 128" SEVERITY ERROR;
		ASSERT n2n_r /= 128 REPORT "PASS! NEAREST2N(127) == 128" SEVERITY NOTE;
		IF n2n_r = 128 THEN
			cnt_pass := cnt_pass + 1;
		ELSE
			cnt_fail := cnt_fail + 1;
		END IF;

		REPORT "======================================" SEVERITY NOTE;
		REPORT " " SEVERITY NOTE;
		REPORT "Testbench skoncil s " & INTEGER'image(cnt_pass) & " PASSed a "
			& INTEGER'image(cnt_fail) & " FAILed assertami." SEVERITY NOTE;

		WAIT;
	END PROCESS;
END;
