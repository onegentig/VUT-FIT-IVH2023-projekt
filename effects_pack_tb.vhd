-- Testbench pre package effects_pack.vhd
-- @date 2023-03-09
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.effects_pack.all;

entity effects_pack_tb is
end effects_pack_tb;

architecture behavior of effects_pack_tb is
	signal DATA_1 : std_logic_vector(11 downto 0) := "111100001101";
	signal RES_1  : std_logic_vector(2 downto 0)  := (others => '0');
	signal DATA_2 : std_logic_vector(23 downto 0) := "111111000011001011010000";
	signal RES_2  : std_logic_vector(3 downto 0)  := (others => '0');
begin
	process is
		variable n2n_a    : natural := 0;
		variable n2n_r    : natural := 0;
		variable cnt_pass : natural := 0;
		variable cnt_fail : natural := 0;
	begin
		wait for 1 ps;

		report "======================================" severity note;
		report "*      effects_pack testbench        *" severity note;
		report "======================================" severity note;
		report " " severity note;

		report "========= GETCOLUMN() zadanie =========" severity note;
		RES_1 <= GETCOLUMN(DATA_1, 0, 3);
		wait for 1 ps;
		assert RES_1 = "101" report "FAIL! GETCOLUMN(DATA_1, 0, 3) /= 101" severity error;
		assert RES_1 /= "101" report "PASS! GETCOLUMN(DATA_1, 0, 3) == 101" severity note;
		if RES_1 = "101" then
			cnt_pass := cnt_pass + 1;
		else
			cnt_fail := cnt_fail + 1;
		end if;

		RES_1 <= GETCOLUMN(DATA_1, 1, 3);
		wait for 1 ps;
		assert RES_1 = "001" report "FAIL! GETCOLUMN(DATA_1, 1, 3) /= 001" severity error;
		assert RES_1 /= "001" report "PASS! GETCOLUMN(DATA_1, 1, 3) == 001" severity note;
		if RES_1 = "001" then
			cnt_pass := cnt_pass + 1;
		else
			cnt_fail := cnt_fail + 1;
		end if;

		RES_1 <= GETCOLUMN(DATA_1, 4, 3);
		wait for 1 ps;
		assert RES_1 = "101" report "FAIL! GETCOLUMN(DATA_1, 4, 3) /= 101" severity error;
		assert RES_1 /= "101" report "PASS! GETCOLUMN(DATA_1, 4, 3) == 101" severity note;
		if RES_1 = "101" then
			cnt_pass := cnt_pass + 1;
		else
			cnt_fail := cnt_fail + 1;
		end if;

		report "======== GETCOLUMN() rozsirene ========" severity note;
		RES_1 <= GETCOLUMN(DATA_1, 2, 3);
		wait for 1 ps;
		assert RES_1 = "100" report "FAIL! GETCOLUMN(DATA_1, 2, 3) /= 100" severity error;
		assert RES_1 /= "100" report "PASS! GETCOLUMN(DATA_1, 2, 3) == 100" severity note;
		if RES_1 = "100" then
			cnt_pass := cnt_pass + 1;
		else
			cnt_fail := cnt_fail + 1;
		end if;

		RES_1 <= GETCOLUMN(DATA_1, 3, 3);
		wait for 1 ps;
		assert RES_1 = "111" report "FAIL! GETCOLUMN(DATA_1, 3, 3) /= 111" severity error;
		assert RES_1 /= "111" report "PASS! GETCOLUMN(DATA_1, 3, 3) == 111" severity note;
		if RES_1 = "111" then
			cnt_pass := cnt_pass + 1;
		else
			cnt_fail := cnt_fail + 1;
		end if;

		RES_1 <= GETCOLUMN(DATA_1, -1, 3);
		wait for 1 ps;
		assert RES_1 = "111" report "FAIL! GETCOLUMN(DATA_1, -1, 3) /= 111" severity error;
		assert RES_1 /= "111" report "PASS! GETCOLUMN(DATA_1, -1, 3) == 111" severity note;
		if RES_1 = "111" then
			cnt_pass := cnt_pass + 1;
		else
			cnt_fail := cnt_fail + 1;
		end if;

		RES_2 <= GETCOLUMN(DATA_2, 0, 4);
		wait for 1 ps;
		assert RES_2 = "0000" report "FAIL! GETCOLUMN(DATA_2, 0, 4) /= 0000" severity error;
		assert RES_2 /= "0000" report "PASS! GETCOLUMN(DATA_2, 0, 4) == 0000" severity note;
		if RES_2 = "0000" then
			cnt_pass := cnt_pass + 1;
		else
			cnt_fail := cnt_fail + 1;
		end if;

		RES_2 <= GETCOLUMN(DATA_2, 10, 4);
		wait for 1 ps;
		assert RES_2 = "0000" report "FAIL! GETCOLUMN(DATA_2, 10, 4) /= 0000" severity error;
		assert RES_2 /= "0000" report "PASS! GETCOLUMN(DATA_2, 10, 4) == 0000" severity note;
		if RES_2 = "0000" then
			cnt_pass := cnt_pass + 1;
		else
			cnt_fail := cnt_fail + 1;
		end if;

		RES_2 <= GETCOLUMN(DATA_2, 5, 4);
		wait for 1 ps;
		assert RES_2 = "1111" report "FAIL! GETCOLUMN(DATA_2, 5, 4) /= 1111" severity error;
		assert RES_2 /= "1111" report "PASS! GETCOLUMN(DATA_2, 5, 4) == 1111" severity note;
		if RES_2 = "1111" then
			cnt_pass := cnt_pass + 1;
		else
			cnt_fail := cnt_fail + 1;
		end if;

		RES_2 <= GETCOLUMN(DATA_2, -5, 4);
		wait for 1 ps;
		assert RES_2 = "1111" report "FAIL! GETCOLUMN(DATA_2, -5, 4) /= 1111" severity error;
		assert RES_2 /= "1111" report "PASS! GETCOLUMN(DATA_2, -5, 4) == 1111" severity note;
		if RES_2 = "1111" then
			cnt_pass := cnt_pass + 1;
		else
			cnt_fail := cnt_fail + 1;
		end if;

		RES_1 <= GETCOLUMN(DATA_2, 0, 3);
		wait for 1 ps;
		assert RES_1 = "000" report "FAIL! GETCOLUMN(DATA_2, 0, 3) /= 000" severity error;
		assert RES_1 /= "000" report "PASS! GETCOLUMN(DATA_2, 0, 3) == 000" severity note;
		if RES_1 = "000" then
			cnt_pass := cnt_pass + 1;
		else
			cnt_fail := cnt_fail + 1;
		end if;

		RES_1 <= GETCOLUMN(DATA_2, 8, 3);
		wait for 1 ps;
		assert RES_1 = "000" report "FAIL! GETCOLUMN(DATA_2, -8, 3) /= 000" severity error;
		assert RES_1 /= "000" report "PASS! GETCOLUMN(DATA_2, -8, 3) == 000" severity note;
		if RES_1 = "000" then
			cnt_pass := cnt_pass + 1;
		else
			cnt_fail := cnt_fail + 1;
		end if;

		RES_1 <= GETCOLUMN(DATA_2, -8, 3);
		wait for 1 ps;
		assert RES_1 = "111" report "FAIL! GETCOLUMN(DATA_2, 8, 3) /= 111" severity error;
		assert RES_1 /= "111" report "PASS! GETCOLUMN(DATA_2, 8, 3) == 111" severity note;
		if RES_1 = "111" then
			cnt_pass := cnt_pass + 1;
		else
			cnt_fail := cnt_fail + 1;
		end if;

		report "========= NEAREST2N() zadanie =========" severity note;
		n2n_a := 6;
		n2n_r := NEAREST2N(n2n_a);
		assert n2n_r = 8 report "FAIL! NEAREST2N(6) /= 8" severity error;
		assert n2n_r /= 8 report "PASS! NEAREST2N(6) == 8" severity note;
		if n2n_r = 8 then
			cnt_pass := cnt_pass + 1;
		else
			cnt_fail := cnt_fail + 1;
		end if;

		n2n_a := 42;
		n2n_r := NEAREST2N(n2n_a);
		assert n2n_r = 64 report "FAIL! NEAREST2N(42) /= 64" severity error;
		assert n2n_r /= 64 report "PASS! NEAREST2N(42) == 64" severity note;
		if n2n_r = 64 then
			cnt_pass := cnt_pass + 1;
		else
			cnt_fail := cnt_fail + 1;
		end if;

		report "======== NEAREST2N() rozsirene ========" severity note;
		n2n_a := 0;
		n2n_r := NEAREST2N(n2n_a);
		assert n2n_r = 1 report "FAIL! NEAREST2N(0) /= 1" severity error;
		assert n2n_r /= 1 report "PASS! NEAREST2N(0) == 1" severity note;
		if n2n_r = 1 then
			cnt_pass := cnt_pass + 1;
		else
			cnt_fail := cnt_fail + 1;
		end if;

		n2n_a := 1;
		n2n_r := NEAREST2N(n2n_a);
		assert n2n_r = 1 report "FAIL! NEAREST2N(1) /= 1" severity error;
		assert n2n_r /= 1 report "PASS! NEAREST2N(1) == 1" severity note;
		if n2n_r = 1 then
			cnt_pass := cnt_pass + 1;
		else
			cnt_fail := cnt_fail + 1;
		end if;

		n2n_a := 2;
		n2n_r := NEAREST2N(n2n_a);
		assert n2n_r = 2 report "FAIL! NEAREST2N(2) /= 2" severity error;
		assert n2n_r /= 2 report "PASS! NEAREST2N(2) == 2" severity note;
		if n2n_r = 2 then
			cnt_pass := cnt_pass + 1;
		else
			cnt_fail := cnt_fail + 1;
		end if;

		n2n_a := 3;
		n2n_r := NEAREST2N(n2n_a);
		assert n2n_r = 4 report "FAIL! NEAREST2N(3) /= 4" severity error;
		assert n2n_r /= 4 report "PASS! NEAREST2N(3) == 4" severity note;
		if n2n_r = 4 then
			cnt_pass := cnt_pass + 1;
		else
			cnt_fail := cnt_fail + 1;
		end if;

		n2n_a := 4;
		n2n_r := NEAREST2N(n2n_a);
		assert n2n_r = 4 report "FAIL! NEAREST2N(4) /= 4" severity error;
		assert n2n_r /= 4 report "PASS! NEAREST2N(4) == 4" severity note;
		if n2n_r = 4 then
			cnt_pass := cnt_pass + 1;
		else
			cnt_fail := cnt_fail + 1;
		end if;

		n2n_a := 63;
		n2n_r := NEAREST2N(n2n_a);
		assert n2n_r = 64 report "FAIL! NEAREST2N(63) /= 64" severity error;
		assert n2n_r /= 64 report "PASS! NEAREST2N(63) == 64" severity note;
		if n2n_r = 64 then
			cnt_pass := cnt_pass + 1;
		else
			cnt_fail := cnt_fail + 1;
		end if;

		n2n_a := 64;
		n2n_r := NEAREST2N(n2n_a);
		assert n2n_r = 64 report "FAIL! NEAREST2N(64) /= 64" severity error;
		assert n2n_r /= 64 report "PASS! NEAREST2N(64) == 64" severity note;
		if n2n_r = 64 then
			cnt_pass := cnt_pass + 1;
		else
			cnt_fail := cnt_fail + 1;
		end if;

		n2n_a := 65;
		n2n_r := NEAREST2N(n2n_a);
		assert n2n_r = 128 report "FAIL! NEAREST2N(65) /= 128" severity error;
		assert n2n_r /= 128 report "PASS! NEAREST2N(65) == 128" severity note;
		if n2n_r = 128 then
			cnt_pass := cnt_pass + 1;
		else
			cnt_fail := cnt_fail + 1;
		end if;

		n2n_a := 127;
		n2n_r := NEAREST2N(n2n_a);
		assert n2n_r = 128 report "FAIL! NEAREST2N(127) /= 128" severity error;
		assert n2n_r /= 128 report "PASS! NEAREST2N(127) == 128" severity note;
		if n2n_r = 128 then
			cnt_pass := cnt_pass + 1;
		else
			cnt_fail := cnt_fail + 1;
		end if;

		report "======================================" severity note;
		report " " severity note;
		report "Testbench skoncil s " & integer'image(cnt_pass) & " PASSed a "
			& integer'image(cnt_fail) & " FAILed assertami." severity note;

		wait;
	end process;
end;
