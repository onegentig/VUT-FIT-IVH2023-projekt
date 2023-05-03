-- Testbench stavovej logiky
-- @author Onegen Something <xonege99@vutbr.cz>
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
	signal DIRECTION : DIRECTION_T;
	signal COL_EN    : std_logic;
	signal COL_RST   : std_logic;

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
			DIRECTION => DIRECTION,
			COL_EN    => COL_EN,
			COL_RST   => COL_RST
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
		variable cnt      : integer := 0;
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
		for i in 1 to (16 * 3) loop
			wait for CLK_period;
			assert (DIRECTION = DIR_RIGHT) and (COL_EN = '1') and (COL_RST = '0')
				report "FAIL! Neocakavany stav pri pohybe doprava" severity error;
			if (DIRECTION /= DIR_RIGHT) then
				fail_all := true;
			end if;
		end loop;

		wait for CLK_period;
		assert (COL_EN = '0') and (COL_RST = '1')
			report "FAIL! Chybny reset alebo povolovac po pohybe doprava" severity error;

		-- Posun dolava
		for i in 1 to (16 * 3) loop
			wait for CLK_period;
			assert DIRECTION = DIR_LEFT
				report "FAIL! Neocakavany stav pri pohybe dolava" severity error;
			if (DIRECTION /= DIR_LEFT) then
				fail_all := true;
			end if;
		end loop;

		wait for CLK_period;
		assert (COL_EN = '0') and (COL_RST = '1')
			report "FAIL! Chybny reset alebo povolovac po pohybe dolava" severity error;

		-- Posun nahor
		for i in 1 to 8 loop
			wait for CLK_period;
			assert DIRECTION = DIR_TOP
				report "FAIL! Neocakavany stav pri pohybe nahor" severity error;
			if (DIRECTION /= DIR_TOP) then
				fail_all := true;
			end if;
		end loop;

		wait for CLK_period;
		assert (COL_EN = '0') and (COL_RST = '1')
			report "FAIL! Chybny reset alebo povolovac po pohybe nahor" severity error;

		-- Ripple (vlastna animacia)
		for i in 1 to 5 loop
			wait for CLK_period;
			assert DIRECTION = DIR_TOP_BOTTOM
				report "FAIL! Neocakavany stav pri obojsmernom posuve" severity error;
			if (DIRECTION /= DIR_TOP_BOTTOM) then
				fail_all := true;
			end if;
		end loop;

		assert fail_all = true report "PASS! Spravny pohyb stavov" severity note;

		-- Reset test
		RESET <= '1';
		wait for CLK_period;
		assert (COL_EN = '0') and (COL_RST = '1')
			report "FAIL! Chybne EN/RST po FSM resete" severity error;

		RESET <= '0';
		wait for CLK_period;
		assert (COL_EN = '1') and (COL_RST = '0')
			report "FAIL! Chybne EN/RST po FSM resete" severity error;

		assert DIRECTION /= DIR_RIGHT report "PASS! Spravny smer po resete" severity note;
		assert DIRECTION = DIR_RIGHT report "FAIL! Nespravny smer po resete" severity error;

		DONE <= true;
		wait;
	end process;
end;
