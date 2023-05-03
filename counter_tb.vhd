-- Testbench pre counter.vhd
-- @author Onegen Something <xonege99@vutbr.cz>
-- @date 2023-03-14
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_tb is
end counter_tb;

architecture behavior of counter_tb is
	-- Vstupy
	signal CLK   : std_logic := '0';
	signal RESET : std_logic := '0';

	-- Vystupy
	signal EN1 : std_logic;
	signal EN2 : std_logic;
	signal EN3 : std_logic;

	-- Hodinova perioda
	constant CLK_period : time := 10 ns;

	-- Vlajka pre koniec testu
	signal DONE : boolean := false;

	-- Prevod boolean na std_logic pre ASSERT
	function b2sl (b : boolean) return std_logic is
	begin
		if b = true then
			return '1';
		else
			return '0';
		end if;
	end function;
begin
	-- Instaciacia jednotky pod testom (UUT)
	--    Pocitejte s tim, ze pri zkouseni pobezi testbench 100 ms
	uut : entity work.counter
		generic map(
			OUT1_PERIOD => 2,
			OUT2_PERIOD => 3,
			OUT3_PERIOD => 5
		)
		port map(
			CLK   => CLK,
			RESET => RESET,
			EN1   => EN1,
			EN2   => EN2,
			EN3   => EN3
		);

	-- Hodinovy proces
	CLK_process : process
	begin
		if DONE = true then
			wait;
		end if;

		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
	end process;

	-- Stimulus
	stim_proc : process is
		variable clk_i      : integer := 1;
		variable passed_rst : boolean := false;
		variable passed_now : boolean := false;
		variable cnt_pass   : natural := 0;
		variable cnt_fail   : natural := 0;
	begin
		RESET <= '1';
		wait for 100 ns;
		RESET <= '0';

		report "======================================" severity note;
		report "*         counter testbench          *" severity note;
		report "======================================" severity note;
		report " " severity note;

		while clk_i <= 50 loop
			wait for CLK_period;

			-- Test citacov
			assert EN1 = b2sl(clk_i mod 2 = 0) report "FAIL! Nespravny EN1 v CLK "
				& integer'image(clk_i) severity error;
			assert EN2 = b2sl(clk_i mod 3 = 0) report "FAIL! Nespravny EN2 v CLK "
				& integer'image(clk_i) severity error;
			assert EN3 = b2sl(clk_i mod 5 = 0) report "FAIL! Nespravny EN3 v CLK "
				& integer'image(clk_i) severity error;

			-- Celkovy stav
			passed_now := (EN1 = b2sl(clk_i mod 2 = 0))
						and (EN2 = b2sl(clk_i mod 3 = 0))
						and (EN3 = b2sl(clk_i mod 5 = 0));
			assert passed_now = false report "PASS! Vsetky citace spravne v CLK "
				& integer'image(clk_i) severity note;

			if passed_now = true then
				cnt_pass := cnt_pass + 1;
			else
				cnt_fail := cnt_fail + 1;
			end if;

			clk_i := clk_i + 1;
		end loop;

		-- Testy resetu
		passed_rst := true;
		RESET      <= '1';

		while clk_i <= 60 loop
			wait for CLK_period;

			passed_now := (EN1 = '0')
						and (EN2 = '0')
						and (EN3 = '0');
			assert passed_now = true report "FAIL! Nefunkcny reset v CLK "
				& integer'image(clk_i) severity error;

			if passed_now = true then
				cnt_pass := cnt_pass + 1;
			else
				cnt_fail   := cnt_fail + 1;
				passed_rst := false;
			end if;

			clk_i := clk_i + 1;
		end loop;
		assert passed_rst = false report "PASS! Reset funguje v CLK 51-60" severity note;

		-- Vypis vysledkov
		report "======================================" severity note;
		report " " severity note;
		report "Citace spravne " & natural'image(cnt_pass) & "-krat a chybne "
			& natural'image(cnt_fail) & "-krat za 60 CLK." severity note;
		DONE <= true;
		wait;
	end process;
end;
