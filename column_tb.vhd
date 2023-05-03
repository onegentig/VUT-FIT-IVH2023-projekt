-- Testbench pre stlpec LED displeja
-- @author Onegen Something <xonege99@vutbr.cz>
-- @date 2023-04-30
-- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.effects_pack.all;

entity column_tb is
end column_tb;

architecture behavior of column_tb is
	-- Vstupy
	signal CLK       : std_logic   := '0';
	signal EN        : std_logic   := '0';
	signal RESET     : std_logic   := '0';
	signal DIRECTION : DIRECTION_T := DIR_LEFT;

	-- Hodinova perioda
	constant CLK_period : time := 10 ns;

	-- Pamat ROM
	type MATRIX_T is array (0 to 2) of std_logic_vector(7 downto 0);
	constant ROM : MATRIX_T := (
		X"AA",
		X"CC",
		X"FF"
	);

	-- Stavy stlpcov
	signal NEIGH_L  : MATRIX_T;
	signal NEIGH_R  : MATRIX_T;
	signal STAT_COL : MATRIX_T := (others => (others => '0'));

	-- Vlajka pre koniec testu
	signal DONE : boolean := false;
begin
	-- Instanciacia troch susednych stlpcov
	COLUMN_MAP : for i in 0 to 2 generate
		col_i : entity work.column
			port map(
				CLK         => CLK,
				RESET       => RESET,
				STATE       => STAT_COL(i),
				INIT_STATE  => ROM(i),
				NEIGH_LEFT  => NEIGH_L(i),
				NEIGH_RIGHT => NEIGH_R(i),
				DIRECTION   => DIRECTION,
				EN          => EN
			);
	end generate;

	-- Prepojenie susedov
	NEIGH_L(0) <= STAT_COL(2);
	NEIGH_L(1) <= STAT_COL(0);
	NEIGH_L(2) <= STAT_COL(1);
	NEIGH_R(0) <= STAT_COL(1);
	NEIGH_R(1) <= STAT_COL(2);
	NEIGH_R(2) <= STAT_COL(0);

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
		variable passed   : boolean := false;
		variable pass_cnt : integer := 0;
	begin
		RESET <= '1';
		wait for 100 ns;
		RESET <= '0';
		wait for CLK_period;

		report "======================================" severity note;
		report "*          column testbench          *" severity note;
		report "======================================" severity note;
		report " " severity note;

		-- Test pociatocneho stavu
		passed := (STAT_COL(0) = X"AA") and (STAT_COL(1) = X"CC")
				and (STAT_COL(2) = X"FF");
		assert passed = true report "FAIL! Pociatocny stav" severity error;
		assert passed = false report "PASS! Pociatocny stav" severity note;

		-- Posun vlavo
		DIRECTION <= DIR_LEFT;
		EN        <= '1';
		wait for CLK_period;
		passed    := (STAT_COL(0) = X"CC") and (STAT_COL(1) = X"FF")
				and (STAT_COL(2) = X"AA");
		assert passed = true report "FAIL! Posun vlavo #1" severity error;
		if passed then
			pass_cnt := pass_cnt + 1;
		end if;

		wait for CLK_period;
		passed := (STAT_COL(0) = X"FF") and (STAT_COL(1) = X"AA")
				and (STAT_COL(2) = X"CC");
		assert passed = true report "FAIL! Posun vlavo #2" severity error;
		if passed then
			pass_cnt := pass_cnt + 1;
		end if;

		wait for CLK_period;
		passed := (STAT_COL(0) = X"AA") and (STAT_COL(1) = X"CC")
				and (STAT_COL(2) = X"FF");
		assert passed = true report "FAIL! Posun vlavo #3" severity error;
		if passed then
			pass_cnt := pass_cnt + 1;
		end if;

		assert pass_cnt /= 3 report "PASS! Posun vlavo" severity note;
		pass_cnt := 0;

		-- Posun vpravo
		DIRECTION <= DIR_RIGHT;
		wait for CLK_period;
		passed    := (STAT_COL(0) = X"FF") and (STAT_COL(1) = X"AA")
				and (STAT_COL(2) = X"CC");
		assert passed = true report "FAIL! Posun vpravo #1" severity error;
		if passed then
			pass_cnt := pass_cnt + 1;
		end if;

		wait for CLK_period;
		passed := (STAT_COL(0) = X"CC") and (STAT_COL(1) = X"FF")
				and (STAT_COL(2) = X"AA");
		assert passed = true report "FAIL! Posun vpravo #2" severity error;
		if passed then
			pass_cnt := pass_cnt + 1;
		end if;

		wait for CLK_period;
		passed := (STAT_COL(0) = X"AA") and (STAT_COL(1) = X"CC")
				and (STAT_COL(2) = X"FF");
		assert passed = true report "FAIL! Posun vpravo #3" severity error;
		if passed then
			pass_cnt := pass_cnt + 1;
		end if;

		assert pass_cnt /= 3 report "PASS! Posun vpravo" severity note;
		pass_cnt := 0;

		-- Rolovanie nahor
		DIRECTION <= DIR_TOP;

		for i in 1 to 8 loop
			wait for CLK_period;

			passed := (unsigned(STAT_COL(0)) = X"AA" srl i)
					and (unsigned(STAT_COL(1)) = X"CC" srl i)
					and (unsigned(STAT_COL(2)) = X"FF" srl i);
			assert passed = true report "FAIL! Rolovanie nahor #" & integer'image(i) severity error;
			if passed then
				pass_cnt := pass_cnt + 1;
			end if;
		end loop;

		assert pass_cnt /= 8 report "PASS! Rolovanie nahor" severity note;

		-- Reset
		RESET  <= '1';
		wait for CLK_period;
		RESET  <= '0';
		passed := (STAT_COL(0) = X"AA") and (STAT_COL(1) = X"CC")
				and (STAT_COL(2) = X"FF");
		assert passed = true report "FAIL! Reset" severity error;
		assert passed = false report "PASS! Reset" severity note;

		-- Negacia (vlastny efekt)
		DIRECTION <= DIR_NEGATE;
		wait for CLK_period;
		assert (STAT_COL(0) = X"55") and (STAT_COL(1) = X"33")
			and (STAT_COL(2) = X"00") report "FAIL! Negacia #1" severity error;

		wait for CLK_period;
		assert (STAT_COL(0) = X"AA") and (STAT_COL(1) = X"CC")
			and (STAT_COL(2) = X"FF") report "FAIL! Negacia #2" severity error;

		-- Ripple (vlastny efekt)
		DIRECTION <= DIR_TOP_BOTTOM;

		wait for CLK_period;
		assert (STAT_COL(0) = X"45") and (STAT_COL(1) = X"86")
			and (STAT_COL(2) = X"EF") report "FAIL! Ripple #1" severity error;

		wait for CLK_period;
		assert (STAT_COL(0) = X"82") and (STAT_COL(1) = X"03")
			and (STAT_COL(2) = X"C7") report "FAIL! Ripple #2" severity error;

		wait for CLK_period;
		assert (STAT_COL(0) = X"01") and (STAT_COL(1) = X"01")
			and (STAT_COL(2) = X"83") report "FAIL! Ripple #3" severity error;

		wait for CLK_period;
		assert (STAT_COL(0) = X"00") and (STAT_COL(1) = X"00")
			and (STAT_COL(2) = X"01") report "FAIL! Ripple #4" severity error;

		wait for CLK_period;
		assert (STAT_COL(0) = X"00") and (STAT_COL(1) = X"00")
			and (STAT_COL(2) = X"00") report "FAIL! Ripple #5" severity error;

		EN   <= '0';
		DONE <= true;
		wait;
	end process;
end;
