-- ROM obrazkov
-- @author Onegen Something <xonege99@vutbr.cz>
-- @date 2023-04-30
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
	port (
		ADDR : in  std_logic_vector(1 downto 0);
		DATA : out std_logic_vector(127 downto 0)
	);
end entity rom;

architecture behavioral of rom is
	type ROM_T is array (0 to 1) of std_logic_vector(0 to 127);
	-- Kazdy 128-bitovy vektor reprezentuje 16 stlpcov 8-riadkovej matice.
	-- Obrazky su ulozene po stlpcoch (column-major order), v konkatenovanom
	-- zapise nizsie v poradi zprava-dolava, zdola-nahor.
	--                                   ┌─────────────┐
	--                                   │       H   8 │
	--                                   │       G   7 │
	--                                   │       F   6 │
	-- "12345678" & "ABCDEFGH" & ... --> │ ...   E   5 │
	--                                   │       D   4 │
	--                                   │       C   3 │
	--                                   │       B   2 │
	--                                   │       A   1 │
	--                                   └─────────────┘
	constant rom_arr : ROM_T := (
		-- Obrazok 1 (ADDR = 0) : Mrkajuca tvar
		--          ┌─────────────────────────────────┐
		--          │ . . X X . . . . . . . . . . . . │
		--          │ . X . . X . . . . . . X . . . . │
		--          │ X . . . . X . . . . X . X . . . │
		--          │ X . . . . X . . . X . . . X . . │
		--          │ . X . . X . . . X . . . . . X . │
		--          │ . . X X . . . . . . . . . . . . │
		--          │ . . . . . X . X . X . . . . . . │
		--          │ . . . . . . X . X . . . . . . . │
		--          └─────────────────────────────────┘
		"00000000" & "00010000" & "00001000" & "00000100" &
		"00000010" & "00000100" & "01001000" & "10010000" &
		"01000000" & "10000000" & "01001100" & "00010010" &
		"00100001" & "00100001" & "00010010" & "00001100",

		-- Obrazok 2 (ADDR = 1) : Sachovnica
		--          ┌─────────────────────────────────┐
		--          │ X . X . X . X . X . X . X . X . │
		--          │ . X . X . X . X . X . X . X . X │
		--          │ X . X . X . X . X . X . X . X . │
		--          │ . X . X . X . X . X . X . X . X │
		--          │ X . X . X . X . X . X . X . X . │
		--          │ . X . X . X . X . X . X . X . X │
		--          │ X . X . X . X . X . X . X . X . │
		--          │ . X . X . X . X . X . X . X . X │
		--          └─────────────────────────────────┘
		"10101010" & "01010101" & "10101010" & "01010101" &
		"10101010" & "01010101" & "10101010" & "01010101" &
		"10101010" & "01010101" & "10101010" & "01010101" &
		"10101010" & "01010101" & "10101010" & "01010101"
	);
begin
	DATA <= rom_arr(to_integer(unsigned(ADDR)));
end architecture;
