-- Testbench ROM
-- @author Onegen Something <xonege99@vutbr.cz>
-- @date 2023-05-03
-- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.effects_pack.GETCOLUMN;

entity rom_tb is
end rom_tb;

architecture behavior of rom_tb is
	-- Vstupy
	signal ADDR : std_logic_vector(1 downto 0) := (others => '0');

	-- Vystupy
	constant HEIGHT : integer := 8;
	signal DATA     : std_logic_vector(16 * HEIGHT - 1 downto 0);

	-- Hodiny
	constant CLK_period : time      := 10 ns;
	signal CLK          : std_logic := '0';  -- vhdl-linter-disable-line unused

	-- Vlajka pre koniec testu
	signal DONE : boolean := false;
begin
	-- Instanciacia jednotky pod testom (UUT)
	uut : entity work.rom
		port map (
			ADDR => ADDR,
			DATA => DATA
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
		variable fail_img : boolean := false;

		procedure assert_col (
			signal ADDRESS    : in std_logic_vector(1 downto 0);
			signal DISPLAY    : in std_logic_vector(127 downto 0);
			constant COL_ID   : in integer;
			constant EXPECTED : in std_logic_vector(7 downto 0)
		) is
		begin
			if GETCOLUMN(DISPLAY, COL_ID, HEIGHT) /= EXPECTED then
				fail_img := true;
				report "FAIL! [ADDR "&integer'image(to_integer(unsigned(ADDRESS)))&
					", COL "&integer'image(COL_ID)&"] neodpoveda ocakavaniu!" severity error;
			end if;
		end procedure;
	begin
		wait for CLK_period;

		report "======================================" severity note;
		report "*            rom testbench           *" severity note;
		report "======================================" severity note;
		report " " severity note;

		-- Kontrola obrazkov, samotne obrazky (ako ascii-art) su v rom.vhd.
		-- Podla implementacie GETCOLUMN su data ulozene zlava-doprava, zdola-hore.
		--                                 ┌─────────────┐
		--                                 │ 8   H       │
		--                                 │ 7   G       │
		--   COLID=0     COLID=1           │ 6   F       │
		-- "12345678", "ABCDEFGH", ... --> │ 5   E   ... │
		--                                 │ 4   D       │
		--                                 │ 3   C       │
		--                                 │ 2   B       │
		--                                 │ 1   A       │
		--                                 └─────────────┘
		-- Obrazok 1 (ADDR = 0) : Mrkajuca tvar
		ADDR <= "00";
		wait for CLK_period;

		assert_col(ADDR, DATA, 0, "00001100");
		assert_col(ADDR, DATA, 1, "00010010");
		assert_col(ADDR, DATA, 2, "00100001");
		assert_col(ADDR, DATA, 3, "00100001");
		assert_col(ADDR, DATA, 4, "00010010");
		assert_col(ADDR, DATA, 5, "01001100");
		assert_col(ADDR, DATA, 6, "10000000");
		assert_col(ADDR, DATA, 7, "01000000");
		assert_col(ADDR, DATA, 8, "10010000");
		assert_col(ADDR, DATA, 9, "01001000");
		assert_col(ADDR, DATA, 10, "00000100");
		assert_col(ADDR, DATA, 11, "00000010");
		assert_col(ADDR, DATA, 12, "00000100");
		assert_col(ADDR, DATA, 13, "00001000");
		assert_col(ADDR, DATA, 14, "00010000");
		assert_col(ADDR, DATA, 15, "00000000");
		assert fail_img = true report "PASS! Obrazok 1 OK" severity note;
		fail_img := false;

		-- Obrazok 2 (ADDR = 1) : Sachovnica
		ADDR <= "01";
		wait for CLK_period;

		assert_col(ADDR, DATA, 0, "01010101");
		assert_col(ADDR, DATA, 1, "10101010");
		assert_col(ADDR, DATA, 2, "01010101");
		assert_col(ADDR, DATA, 3, "10101010");
		assert_col(ADDR, DATA, 4, "01010101");
		assert_col(ADDR, DATA, 5, "10101010");
		assert_col(ADDR, DATA, 6, "01010101");
		assert_col(ADDR, DATA, 7, "10101010");
		assert_col(ADDR, DATA, 8, "01010101");
		assert_col(ADDR, DATA, 9, "10101010");
		assert_col(ADDR, DATA, 10, "01010101");
		assert_col(ADDR, DATA, 11, "10101010");
		assert_col(ADDR, DATA, 12, "01010101");
		assert_col(ADDR, DATA, 13, "10101010");
		assert_col(ADDR, DATA, 14, "01010101");
		assert_col(ADDR, DATA, 15, "10101010");
		assert fail_img = true report "PASS! Obrazok 2 OK" severity note;
		fail_img := false;

		DONE <= true;
		wait;
	end process;
end;
