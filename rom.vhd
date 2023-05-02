LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY work;
USE work.effects_pack.ALL;

ENTITY rom IS
	PORT (
		ADDR : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		DATA : OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
	);
END ENTITY rom;

ARCHITECTURE behavioral OF rom IS
	TYPE ROM_T IS ARRAY (0 TO 1) OF STD_LOGIC_VECTOR(0 TO 127);
	CONSTANT rom_arr : ROM_T := (
		X"FF" & X"EE" & X"DD" & X"CC" &
		X"BB" & X"AA" & X"99" & X"88" &
		X"77" & X"66" & X"55" & X"44" &
		X"33" & X"22" & X"11" & X"00",

		X"00" & X"00" & X"00" & X"00" &
		X"00" & X"00" & X"00" & X"00" &
		X"00" & X"00" & X"00" & X"00" &
		X"00" & X"00" & X"00" & X"00"
	);
BEGIN
	DATA <= rom_arr(to_integer(unsigned(ADDR)));
END ARCHITECTURE;
