-- Top-Module IVH projektu 2023
-- @author Onegen Something <xonege99@vutbr.cz>
-- @date 2023-05-03
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.effects_pack.all;

architecture behavioral of tlv_gp_ifc is
	-- @constant {INTEGER} SPEED
	-- Dlzka periody medzi krokmi animacie (2^SPEED = pocet hodinovych cyklov medzi krokmi)
	constant SPEED   : integer := 22;                                       -- pre beh
	--constant SPEED   : integer := 5;                                        -- pre simulaciu

	-- Rozmery maticoveho displeja.
	constant WIDTH   : positive := 16;
	constant HEIGHT  : positive := 8;

	-- Stavy displeja
	signal STAT_INIT : MATRIX_T := (others => (others => '0'));             -- Pociatocny stav displeja
	signal STAT_COL  : MATRIX_T := STAT_INIT;                               -- Stavy stlpcov
	signal NEIGH_L   : MATRIX_T;                                            -- Lave susedne stlpce
	signal NEIGH_R   : MATRIX_T;                                            -- Prave susedne stlpce

	-- Ovladanie stlpcov
	signal CLK_ANIM  : std_logic := '0';                                    -- Hodiny pre ovladanie animacie
	signal COL_EN    : std_logic := '0';                                    -- Povolovaci signal stlpcov
	signal COL_RST   : std_logic := '0';                                    -- Reset stplcov na INIT_STATE
	signal DIRECTION : DIRECTION_T;                                         -- Smer animacie

	-- Ovladanie maticoveho displeja
	signal CLK_REFR  : std_logic                             := '0';        -- Spomalene hodiny pre obnovu displeja
	signal A         : std_logic_vector(3 downto 0)          := "0000";     -- Adresa stlpca
	signal R         : std_logic_vector(HEIGHT - 1 downto 0) := "00000000"; -- Stav stlpca

	-- ROM
	signal ROM_IDX   : natural                      := 0;                   -- Index obrazka v ROM
	signal ROM_ADDR  : std_logic_vector(1 downto 0) := "00";                -- Adresa ROM
	signal ROM_OUT   : std_logic_vector(WIDTH * HEIGHT - 1 downto 0);       -- Vystup z ROM
begin
	-- -----------------------
	--        Citace
	-- -----------------------
	counters : entity work.counter
		generic map(
			OUT1_PERIOD => 2,           -- Pre prepinanie stplcov
			OUT2_PERIOD => 2 ** SPEED   -- Pre koordinaciu animacie
		)
		port map(
			CLK   => CLK,
			RESET => RESET,
			EN1   => CLK_REFR,
			EN2   => CLK_ANIM
		);

	-- -----------------------
	--    Stavovy automat
	-- -----------------------
	fsm : entity work.fsm
		port map(
			CLK       => CLK_ANIM,
			EN        => '1',
			RST       => '0',
			COL_EN    => COL_EN,
			COL_RST   => COL_RST,
			DIRECTION => DIRECTION,
			IMAGE_IDX => ROM_IDX
		);

	-- -----------------------
	--         ROM
	-- -----------------------
	rom : entity work.rom
		port map(
			ADDR => ROM_ADDR,
			DATA => ROM_OUT
		);

	ROM_ADDR <= std_logic_vector(to_unsigned(ROM_IDX, ROM_ADDR'length));

	-- -----------------------
	--        Stlpce
	-- -----------------------
	COLUMN_MAP : for i in 0 to WIDTH - 1 generate
		subtype COLIDX_T is integer range 0 to WIDTH - 1;
		constant COLIDX   : COLIDX_T := COLIDX_T(i);
		constant COLIDX_L : COLIDX_T := COLIDX_T((COLIDX - 1) mod WIDTH);
		constant COLIDX_R : COLIDX_T := COLIDX_T((COLIDX + 1) mod WIDTH);
		signal COL_NOW    : std_logic_vector(HEIGHT - 1 downto 0); -- vhdl-linter-disable-line unused
	begin
		STAT_INIT(COLIDX) <= GETCOLUMN(ROM_OUT, COLIDX, HEIGHT);

		column_inst : entity work.column
			generic map(
				N => HEIGHT
			)
			port map(
				CLK         => CLK_ANIM,
				RESET       => COL_RST,
				STATE       => COL_NOW,
				INIT_STATE  => STAT_INIT(COLIDX),
				NEIGH_LEFT  => NEIGH_L(COLIDX),
				NEIGH_RIGHT => NEIGH_R(COLIDX),
				DIRECTION   => DIRECTION,
				EN          => COL_EN
			);

		STAT_COL(COLIDX)  <= COL_NOW;
		NEIGH_L(COLIDX_R) <= COL_NOW;
		NEIGH_R(COLIDX_L) <= COL_NOW;
	end generate;

	-- -----------------------
	--   Ovladanie displeja
	-- -----------------------
	R <= STAT_COL(to_integer(unsigned(A)));

	-- Prepinanie stlpcov
	p_addr : process (CLK_REFR)
	begin
		if rising_edge(CLK_REFR) then
			A <= std_logic_vector(unsigned(A) + 1);
		end if;
	end process;

	-- Mapovanie vystupu
	X(6)  <= A(3);
	X(8)  <= A(1);
	X(10) <= A(0);
	X(7)  <= '0'; -- en_n
	X(9)  <= A(2);
	X(16) <= R(1);
	X(18) <= R(0);
	X(20) <= R(7);
	X(22) <= R(2);
	X(17) <= R(4);
	X(19) <= R(3);
	X(21) <= R(6);
	X(23) <= R(5);
end behavioral;
