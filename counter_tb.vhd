-- Testbench pre counter.vhd
-- @author Onegen Something <xonege99@vutbr.cz>
-- @date 2023-03-14
--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY counter_tb IS
END counter_tb;

ARCHITECTURE behavior OF counter_tb IS
	-- Vstupy
	SIGNAL CLK          : STD_LOGIC := '0';
	SIGNAL RESET        : STD_LOGIC := '0';

	-- Vystupy
	SIGNAL EN1          : STD_LOGIC;
	SIGNAL EN2          : STD_LOGIC;
	SIGNAL EN3          : STD_LOGIC;

	-- Hodinova perioda
	CONSTANT CLK_period : TIME    := 10 ns;

	-- Vlajka pre koniec testu
	SIGNAL done         : BOOLEAN := FALSE;

	-- Prevod boolean na std_logic pre ASSERT
	FUNCTION b2sl (b    : BOOLEAN) RETURN STD_LOGIC IS BEGIN
		IF b = TRUE THEN
			RETURN '1';
		ELSE
			RETURN '0';
		END IF;
	END FUNCTION;
BEGIN

	-- Instaciacia jednotky pod testom (UUT)
	--    Pocitejte s tim, ze pri zkouseni pobezi testbench 100 ms
	uut : ENTITY work.counter
		GENERIC MAP(
			OUT1_PERIOD => 2,
			OUT2_PERIOD => 3,
			OUT3_PERIOD => 5
		)
		PORT MAP(
			CLK   => CLK,
			RESET => RESET,
			EN1   => EN1,
			EN2   => EN2,
			EN3   => EN3
		);

	-- Hodinovy proces
	CLK_process : PROCESS BEGIN
		IF done = TRUE THEN
			WAIT;
		END IF;

		CLK <= '0';
		WAIT FOR CLK_period/2;
		CLK <= '1';
		WAIT FOR CLK_period/2;
	END PROCESS;

	-- Stimulus
	stim_proc : PROCESS IS
		VARIABLE clk_i      : INTEGER := 1;
		VARIABLE passed_now : BOOLEAN := FALSE;
		VARIABLE cnt_pass   : NATURAL := 0;
		VARIABLE cnt_fail   : NATURAL := 0;
	BEGIN
		RESET <= '1';
		WAIT FOR 100 ns;
		RESET <= '0';

		REPORT "======================================" SEVERITY NOTE;
		REPORT "*         counter testbench          *" SEVERITY NOTE;
		REPORT "======================================" SEVERITY NOTE;
		REPORT " " SEVERITY NOTE;

		WHILE clk_i <= 65 LOOP
			WAIT FOR CLK_period;

			-- Test citacov
			ASSERT EN1 = b2sl(clk_i MOD 2 = 0) REPORT "FAIL! Nespravny EN1 v CLK "
				& INTEGER'image(clk_i) SEVERITY ERROR;
			ASSERT EN2 = b2sl(clk_i MOD 3 = 0) REPORT "FAIL! Nespravny EN2 v CLK "
				& INTEGER'image(clk_i) SEVERITY ERROR;
			ASSERT EN3 = b2sl(clk_i MOD 5 = 0) REPORT "FAIL! Nespravny EN3 v CLK "
				& INTEGER'image(clk_i) SEVERITY ERROR;

			-- Celkovy stav
			passed_now := (EN1 = b2sl(clk_i MOD 2 = 0))
				AND (EN2 = b2sl(clk_i MOD 3 = 0))
				AND (EN3 = b2sl(clk_i MOD 5 = 0));
			ASSERT passed_now = FALSE REPORT "PASS! Vsetky citace spravne v CLK "
				& INTEGER'image(clk_i) SEVERITY NOTE;

			IF passed_now = TRUE THEN
				cnt_pass := cnt_pass + 1;
			ELSE
				cnt_fail := cnt_fail + 1;
			END IF;

			clk_i := clk_i + 1;
		END LOOP;

		-- Vypis vysledkov
		REPORT "======================================" SEVERITY NOTE;
		REPORT " " SEVERITY NOTE;
		REPORT "Citace spravne " & NATURAL'image(cnt_pass) & "-krat a chybne "
			& NATURAL'image(cnt_fail) & "-krat za 65 CLK." SEVERITY NOTE;
		DONE <= TRUE;
		WAIT;
	END PROCESS;
END;
