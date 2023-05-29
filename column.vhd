-- Stlpec LED displeja
-- @author Onegen Something <xkrame00@vutbr.cz>
-- @date 2023-04-22
--

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.effects_pack.all;

entity column is
	generic (
		N : positive := 8
	);

	port (
		CLK         : in     std_logic;
		RESET       : in     std_logic;
		STATE       : buffer std_logic_vector(N - 1 downto 0);
		INIT_STATE  : in     std_logic_vector(N - 1 downto 0);
		NEIGH_LEFT  : in     std_logic_vector(N - 1 downto 0);
		NEIGH_RIGHT : in     std_logic_vector(N - 1 downto 0);
		DIRECTION   : in     DIRECTION_T;
		EN          : in     std_logic
	);
end column;

architecture behavioral of column is
begin
	process (CLK, RESET)
	begin
		if RESET = '1' then
			----- Reset -----
			STATE <= INIT_STATE;
		elsif rising_edge(CLK) and (EN = '1') then
			if (DIRECTION = DIR_LEFT) then
				----- Posun vlavo -----
				STATE <= NEIGH_RIGHT;
			elsif (DIRECTION = DIR_RIGHT) then
				----- Posun vpravo -----
				STATE <= NEIGH_LEFT;
			elsif (DIRECTION = DIR_TOP) then
				----- Shift nahor -----
				STATE(N - 2 downto 0) <= STATE(N - 1 downto 1);
				STATE(N - 1)          <= '0';
			elsif (DIRECTION = DIR_TOP_BOTTOM) then
				----- Ripple efekt -----
				STATE(N - 1 downto (N / 2) + 1) <= STATE(N - 2 downto (N / 2));
				STATE((N / 2) - 1 downto 0)     <= STATE((N / 2) downto 1);
				STATE((N / 2))                  <= '0';
			elsif (DIRECTION = DIR_NEGATE) then
				----- Negacia -----
				STATE <= not STATE;
			end if;
		end if;
	end process;
end behavioral;
