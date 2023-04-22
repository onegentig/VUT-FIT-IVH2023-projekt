LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

LIBRARY work;
USE work.fsm.ALL;

ARCHITECTURE behavioral OF tlv_gp_ifc IS
	SIGNAL A           : STD_LOGIC_VECTOR(3 DOWNTO 0)  := "0001";          -- Adresa stlpca
	SIGNAL R           : STD_LOGIC_VECTOR(7 DOWNTO 0)  := "01011100";      -- Stav stlpca
	SIGNAL CNT         : STD_LOGIC_VECTOR(23 DOWNTO 0) := (OTHERS => '0'); -- 1s - 25MHz / 20M ~ 24b

	SIGNAL CNT_REFRESH : STD_LOGIC_VECTOR(7 DOWNTO 0);                     -- Citac pre obnovu displeja
	SIGNAL CNT_ANIM    : STD_LOGIC_VECTOR(7 DOWNTO 0);                     -- Citac pre ovladanie animacie
BEGIN
	-- -----------------------
	--        Citace
	-- -----------------------
	CNT_REFRESH <= CNT(23 DOWNTO 16);
	CNT_ANIM    <= CNT(15 DOWNTO 8);

	p_cnt : PROCESS (clk) IS
	BEGIN
		IF rising_edge(clk) THEN
			CNT <= CNT + 1;
			IF conv_integer(CNT) = 0 THEN
				A <= A + 1;
			END IF;
		END IF;
	END PROCESS;

	-- -----------------------
	--         FSM
	-- -----------------------
	fsm_inst : ENTITY work.fsm
		PORT MAP(
			clk       => clk,
			CNT_ANIM  => CNT_ANIM,
			DIRECTION => DIRECTION_i,
			EN        => EN_i
		);

	-- Mapovani vystupu
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
END behavioral;
