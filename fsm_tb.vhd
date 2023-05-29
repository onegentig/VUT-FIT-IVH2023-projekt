-- Testbench stavovej logiky
-- @date 2023-05-01
-- 

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.effects_pack.all;

entity fsm_tb is
end fsm_tb;

architecture behavior of fsm_tb is
	-- Vstupy
	signal EN    : std_logic := '0';
	signal RESET : std_logic := '0';

	-- Vystupy
	signal COL_EN    : std_logic;
	signal COL_RST   : std_logic;
	signal DIRECTION : DIRECTION_T;
	signal IMAGE_IDX : natural;

	-- Hodiny
	constant CLK_period : time      := 10 ns;
	signal CLK          : std_logic := '0';

	-- Vlajka pre koniec testu
	signal DONE : boolean := false;
begin
	-- Instanciacia jednotky pod testom (UUT)
	uut : entity work.fsm
		port map(
			CLK       => CLK,
			EN        => EN,
			RST       => RESET,
			COL_EN    => COL_EN,
			COL_RST   => COL_RST,
			DIRECTION => DIRECTION,
			IMAGE_IDX => IMAGE_IDX
		);

	-- Hodinovy proces
	CLK_process : process
	begin
		if done = true then
			wait;
		end if;

		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
	end process;

	-- Stimulus
	stim_proc : process is
		variable fail_all : boolean := false;
	begin
		RESET <= '1';
		wait for 100 ns;
		RESET <= '0';

		report "======================================" severity note;
		report "*            fsm testbench           *" severity note;
		report "======================================" severity note;
		report " " severity note;

		-- Pociatocny stav
		assert DIRECTION = DIR_RIGHT
			report "FAIL! Pociatocny stav nie je DIR_RIGHT" severity error;

		-- Posun doprava
		EN <= '1';
		for i_unused in 1 to (16 * 3) loop
			wait for CLK_period;
			assert (DIRECTION = DIR_RIGHT) and (COL_EN = '1') and (COL_RST = '0')
				report "FAIL! Neocakavany stav pri RIGHT_ROTATION" severity error;
			assert (IMAGE_IDX = 0) report "FAIL! Nespravny obrazok pri RIGHT_ROTATION" severity error;
			if (DIRECTION /= DIR_RIGHT) then
				fail_all := true;
			end if;
		end loop;

		wait for CLK_period;
		assert (COL_EN = '0') and (COL_RST = '1')
			report "FAIL! Chybny reset alebo povolovac po RIGHT_ROTATION" severity error;

		-- Posun dolava
		for i_unused in 1 to (16 * 3) loop
			wait for CLK_period;
			assert DIRECTION = DIR_LEFT
				report "FAIL! Neocakavany stav pri LEFT_ROTATION" severity error;
			assert (IMAGE_IDX = 0) report "FAIL! Nespravny obrazok pri LEFT_ROTATION" severity error;
			if (DIRECTION /= DIR_LEFT) then
				fail_all := true;
			end if;
		end loop;

		wait for CLK_period;
		assert (COL_EN = '0') and (COL_RST = '1')
			report "FAIL! Chybny reset alebo povolovac po LEFT_ROTATION" severity error;

		-- Posun nahor
		for i_unused in 1 to 8 loop
			wait for CLK_period;
			assert DIRECTION = DIR_TOP
				report "FAIL! Neocakavany stav pri ROLL_UP" severity error;
			assert (IMAGE_IDX = 0) report "FAIL! Nespravny obrazok pri ROLL_UP" severity error;
			if (DIRECTION /= DIR_TOP) then
				fail_all := true;
			end if;
		end loop;

		wait for CLK_period;
		assert (COL_EN = '0') and (COL_RST = '1')
			report "FAIL! Chybny reset alebo povolovac po ROLL_UP" severity error;

		-- Sachovnica (vlastny efekt)
		for i in 0 to 19 loop
			wait for CLK_period;
			assert DIRECTION = DIR_NEGATE
				report "FAIL! Neocakavany stav pri CHECKERBOARD" severity error;
			assert (IMAGE_IDX = 1) report "FAIL! Nespravny obrazok pri CHECKERBOARD" severity error;
			if i mod 2 = 0 then
				assert (COL_EN = '1') and (COL_RST = '0')
					report "FAIL! Chybny povolovac alebo reset pri CHECKERBOARD" severity error;
			else
				assert (COL_EN = '0') and (COL_RST = '0')
					report "FAIL! Chybny povolovac alebo reset pri CHECKERBOARD" severity error;
			end if;
			if (DIRECTION /= DIR_NEGATE) then
				fail_all := true;
			end if;
		end loop;

		wait for CLK_period;
		assert (COL_EN = '0') and (COL_RST = '1')
			report "FAIL! Chybny reset alebo povolovac po CHECKERBOARD" severity error;

		-- Ripple (vlastna animacia)
		for i in 0 to 19 loop
			wait for CLK_period;
			assert DIRECTION = DIR_TOP_BOTTOM
				report "FAIL! Neocakavany stav pri RIPPLE" severity error;
			assert (IMAGE_IDX = 1) report "FAIL! Nespravny obrazok pri RIPPLE" severity error;
			if i mod 4 = 0 then
				assert (COL_EN = '1') and (COL_RST = '0')
					report "FAIL! Chybny povolovac alebo reset pri RIPPLE" severity error;
			else
				assert (COL_EN = '0') and (COL_RST = '0')
					report "FAIL! Chybny povolovac alebo reset pri RIPPLE" severity error;
			end if;
			if (DIRECTION /= DIR_TOP_BOTTOM) then
				fail_all := true;
			end if;
		end loop;

		wait for CLK_period;
		assert (COL_EN = '0') and (COL_RST = '0')
			report "FAIL! Chybny reset alebo povolovac po RIPPLE" severity error;

		assert fail_all = true report "PASS! Spravny pohyb stavov" severity note;

		-- Reset test
		RESET <= '1';
		wait for CLK_period;
		assert (COL_EN = '0') and (COL_RST = '1')
			report "FAIL! Chybne EN/RST po FSM resete" severity error;

		RESET <= '0';
		wait for CLK_period;
		assert (COL_EN = '1') and (COL_RST = '0') and (IMAGE_IDX = 0)
			report "FAIL! Chybne EN/RST po FSM resete" severity error;

		assert DIRECTION /= DIR_RIGHT report "PASS! Spravny smer po resete" severity note;
		assert DIRECTION = DIR_RIGHT report "FAIL! Nespravny smer po resete" severity error;

		DONE <= true;
		wait;
	end process;
end;
