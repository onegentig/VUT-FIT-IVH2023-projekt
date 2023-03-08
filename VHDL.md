# Sumár VHDL #

VHDL (celým *VHSIC HDL* — **V**ery **H**igh **S**peed **I**ntegrated **C**ircuit **H**ardware **D**escription **L**anguage) je [štandardizovaný](http://vhdl-manual.narod.ru/books/ieee_manual.pdf) jazyk navrhnutý a optimalizovaný na popis štruktúry a správania **elektronických systémov**.

- Založení na jazyku [Ada](https://en.wikipedia.org/wiki/Ada_(programming_language)), high–level jazyk v rodine [PASCAL](https://en.wikipedia.org/wiki/Pascal_(programming_language))
  - case–insensitive (*pozn.: od verzie VHDL-93 sú identifikátory case–sensitive*)
  - staticky a silne typovaný
  - memory–safe
  - používa `begin` a `end` na popis paralelizmu
  - komentár uvádzajú dve pomlčky (`--`)
  - príkazy a deklarácie delené bodkočiarkou (`;`), položky zoznamu čiarkou (`,`)
- Popisuje číslicové zariadenia pomocou komponentov
  - *Entita* definuje rozhranie
  - *Architektúra* definuje správanie
- `:=` priraďuje hodnotu premennej alebo sekvenčne signálu, `<=` priraďuje hodnotu signálu paralelne (alebo v procese alebo v procedúre)

## Dátové objekty ##

### Konštanta ###

Hodnoty konštánt nemôžu byť v priebehu behu/simulácie zmenené. Hodnota môže byť deklarovaná, ale nemusí (*deffered constant*). Použitie: parametrizácia, zprehľadnenie kódu.

```text
constant identifier(s) : type := value;
```

```vhdl
constant ITERATIONS    : integer;
constant WIDTH1        : integer := 13;
constant DELAY, DELAY2 : time := 10 ns;
constant WIDTH2        : natural := log2(DW);
```

### Premenná ###

```text
variable identifier(s) : type := value;
```

```vhdl
variable i             : integer := 0;
```

Premenné môžu byť deklarované/definované v procese, funkcií alebo procedúry (okrem verzie VHDL-87). Použitie: medzihodnoty.

```vhdl
process
	variable temp : integer := 0;
begin
	for i in range 0 to 15 loop
		-- ...
		temp := temp + 1;
	end loop;
end process;
```

### Signál ###

Najdôležitejší dátový objekt.

```text
signal identifier(s) : type := value;
```

```vhdl
signal wire          : std_logic := '1';
-- ...
wire <= '0';
```

## Typy ##

|   **Dátovy typ**   |                 **Popis**                  |
| :----------------: | :----------------------------------------: |
|       `bit`        |     Jedna binárna hodnota (0 alebo 1)      |
|    `bit_vector`    |          Vektor binárnych hodnôt           |
|    `std_logic`     | Jedna hodnota signálu s definovaným stavom |
| `std_logic_vector` |           Vektor hodnôt signálu            |
|     `boolean`      |                true / false                |
|     `integer`      |                 Celé čislo                 |
|     `natural`      |           Prirodzené čislo (0+)            |
|     `positive`     |        Kladné prirodzené čislo (0+)        |
|     `unsigned`     |         Bez–znamienkové celé čislo         |
|      `signed`      |           Znamienkové celé čislo           |
|       `real`       |     Čislo s plávajúcou radovou čiarkou     |
|    `character`     |         Jeden znak (ako C `char`)          |
|      `string`      |           Reťazec `character`ov            |
|       `time`       |                    Čas                     |

Na určenie jednoduchej hodnoty (napr. jeden `bit`, `std_logic` alebo `character`) používame **apostrof** (`'`).

```vhdl
signal a : std_logic := '0';
```

### Hodnoty `std_vector` ###

V praxi sa typy `bit` a `bit_vector` nepoužívajú (namiesto toho sa používajú `std_logic` a `std_logic_vector`). 

| **Hodnota** |                    **Popis**                    |
| :---------: | :---------------------------------------------: |
|     `0`     |                Logická nula (0)                 |
|     `1`     |              Logická jednotka (1)               |
|     `U`     |       Neinicializovaný signál bez hodnoty       |
|     `X`     |          Neznáma, neurčiteľná hodnota           |
|     `Z`     |                Vysoká impedancia                |
|     `W`     | Príliš slabý signál, nie je možné určiť hodnotu |
|     `H`     | Signál so slabým ťahom nadol (mal by ísť k `0`) |
|     `L`     | Signál so slabým ťahom nahor (mal by ísť k `1`) |
|     `-`     |                  *Don't care*                   |

Používať sa má iba `X`, `0`, `1` a `Z`.

![Sila std_logic hodnôt signálu](https://user-images.githubusercontent.com/84882649/223572934-202d34c4-844e-4de7-aa8e-225a5eefde56.png)

![Resoluční tabulka std_logic](https://user-images.githubusercontent.com/84882649/223587720-c609852f-92cd-472b-9fd3-e63385f72b06.png)

### Komplexné typy ###

Na tvorbu komplexných typov ("""polí""", IRL by šlo o skupinu vodičov) sa používa `downto` alebo `to` (neodporúčané).

```vhdl
signal a : std_logic_vector(11 downto 0);
```

```vhdl
signal a : std_logic_vector(0 to 11);
```

Tieto dva riadky sú zhodné. Vzniknutý signál bude mať **indexy** od 0 do 11, teda veľkosť poľa je 12. Veľkosť poľa nesmie presiahnuť 4 bity.

Na určenie komplexnej hodnoty (napr. `bit_vector`, `std_logic_vector` alebo `string`) používame **úvodzovky** (`"`).

```vhdl
signal a : std_logic_vector(3 downto 0) := "1001";
```

Pre indexáciu používame **okrúhle zátvorky** (`(i)`).

```vhdl
-- a = "1001"

a(0) <= '0';
-- a = "0001"

a(1) <= a(3);
-- a = "0101"
```

#### Prečo `downto` a nie `to`? ####

`downto` a `to` vypadajú rovnako, ale pozície určujú naopak.

```vhdl
signal A : std_logic_vector(3 downto 0);
signal B : std_logic_vector(0 to 3);
```

Zdanlivo zhodné, ale signál A má pozície od 3, zatiaľ čo B od 0. Použitie sa líši, napr. príkaz priradenia:

```vhdl
A <= B;
```

spôsobí:

```vhdl
A(3) <= B(0);
A(2) <= B(1);
A(1) <= B(2);
A(0) <= B(3);
```

Pokiaľ by A aj B boli `3 downto 0`:

```vhdl
A(3) <= B(3);
A(2) <= B(2);
A(1) <= B(1);
A(0) <= B(0);
```

### Typová konverzia ###

Buď **cast** alebo **funkcia** (knižnica `numeric_std`).

![Typové konverzie vo VHDL](https://user-images.githubusercontent.com/84882649/223578260-861233a7-8f80-4667-be40-7d1cc426b499.png)

```vhdl
signal slv_example : std_logic_vector(3 downto 0);
signal us_example  : unsigned(3 downto 0);
signal s_example   : signed(3 downto 0);
signal int_example : integer;

-- unsigned → std_logic_vector
slv_example <= std_logic_vector(us_example);

-- unsigned → signed
s_example <= signed(us_example);

-- unsigned → integer
int_example <= to_integer(us_example);

-- signed → std_logic_vector
slv_example <= std_logic_vector(s_example);

-- signed → unsigned
us_example <= unsigned(s_example);

-- signed → integer
int_example <= to_integer(s_example);

-- std_logic_vector → unsigned
us_example <= unsigned(slv_example);

-- std_logic_vector → signed
s_example <= signed(slv_example);

-- std_logic_vector → integer
--     VHDL nevie interpretovať std_logic_vector
--     ako číslo, takže je nutné použiť cast na
--     buď signed alebo unsigned.
int_example <= to_integer(unsigned(slv_example));
int_example <= to_integer(signed(slv_example));

-- integer → unsigned
--     funkcie to_[un]signed() majú dva argumenty,
--     a to hodnotu a počet bitov.
us_example <= to_unsigned(int_example, us_example'length);

-- integer → signed
s_example <= to_signed(int_example, s_example'length);

-- integer → std_logic_vector
--     VHDL nevie interpretovať std_logic_vector
--     ako číslo, takže je nutné použiť cast na
--     buď signed alebo unsigned.
slv_example <= std_logic_vector(to_unsigned(int_example, slv_example'length));
slv_example <= std_logic_vector(to_signed(int_example, slv_example'length));
```

#### C-style cast ####

```text
TypeName'(Expression)
TypeName'Aggregate
```

```vhdl
case std_logic_vector'(A, B) is ...
if A > unsigned'("10000000") then ...
std_logic'(others => '0')
```

## Operátory ##

### Logické binárne operácie ###

|   **Označenie**   |
| :---------------: |
|       `and`       |
|       `or`        |
|       `not`       |
|       `xor`       |
| `xnor` (VHDL-93+) |
|       `nor`       |
|      `nand`       |

#### Komplexné typy a logické operácie ####

```vhdl
-- ak máme napr. definované:
signal a : std_logic_vector(3 downto 0) := "1001";

-- ...potom toto:
c(3 downto 0) <= a and b(3 downto 0);
-- ...alebo skrátene:
c <= a and b(0 to 3);

-- ...je to isté ako:
c(3) <= a(3) and b(3);
c(2) <= a(2) and b(2);
c(1) <= a(1) and b(1);
c(0) <= a(0) and b(0);

-- Pozn.: možné iba s komplex. typmi zhodnej dĺžky so zhodným typom!
```

### Logické posuny a rotácie ###

| **Označenie** |                       **Význam**                       |
| :-----------: | :----------------------------------------------------: |
|     `sll`     |     logický posun vľavo<br>*(shift left logical)*      |
|     `srl`     |    logický posun vpravo<br>*(shift right logical)*     |
|     `rol`     |           otočenie vľavo<br>*(rotate left)*            |
|     `ror`     |           otočenie vlavo<br>*(rotate left)*            |
|     `sla`     |  aritmetický posun vľavo<br>*(shift left arithmetic)*  |
|     `sra`     | aritmetický posun vpravo<br>*(shift right arithmetic)* |

![Logické posuny vo VHDL](https://user-images.githubusercontent.com/84882649/223595835-843a79c5-78c4-4ce5-985d-6024fe1a39c2.png)

### Relačné operácie ###

| **Znak** |
| :------: |
|   `=`    |
|   `/=`   |
|   `<`    |
|   `<=`   |
|   `>`    |
|   `>=`   |

#### Komplexné typy a relačné operácie ####

```vhdl
-- ak máme napr. definované:
signal a : std_logic_vector(3 downto 0) := "1000";
signal b : std_logic_vector(0 to 7) := "11101111";
signal c : std_logic_vector;

-- ...potom je toto:
c <= '1' when (a < b) else '0';

-- ...zhodné s:
c <= '1' when (a(3) < b(0)) or
	((a(3) = b(0)) and (a(2) < b(1))) or
	((a(3) = b(0)) and (a(2) = b(1)) and (a(1) < b(2))) or
	((a(3) = b(0)) and (a(2) = b(1)) and (a(1) = b(2)) and (a(0) = b(3))) or
	((a(3) = b(0)) and (a(2) = b(1)) and (a(1) = b(2)) and (a(0) = b(3))) else '0';

-- dĺžka komplexného typu nemusí byť zhodná (na rozdiel od log.).

-- ...pokiaľ je toto správanie nežiadúce, alt.:
c <= '1' when ("0000" & a < b) else '0';
```

### Matematické operácie ###

|   **Znak**    |
| :-----------: |
|      `+`      |
|      `-`      |
|      `*`      |
|     `**`      |
|      `/`      |
| `rem` / `mod` |
|     `abs`     |
|      `&`      |

#### Konkatenácia (`&`) ####

```vhdl
'0' & '1' = "01"
```

```vhdl
signal a : std_logic_vector(3 downto 0) := "1001";
signal b : std_logic_vector(7 downto 0) := "00011111";
signal c : std_logic_vector(7 downto 0);

c <= "0000" & (a and b(0 to 3));
```

#### `mod` vs. `rem` ####

```vhdl
a mod b == a - b * N
a rem b == a - ( a / b ) * b
```

Znamienko `rem` sa bude zhodovať so znamienkom prvého čísla, a naopak `mod` bude mať znamienko zhodné s druhým číslom.

```vhdl
5 mod 3          -- 2
5 rem 3          -- 2

(-5) mod 3       -- 2
(-5) rem 3       -- -2

5 mod (-3)       -- -2
5 rem (-3)       -- 2

(-5) mod (-3)    -- -2
(-5) rem (-3)    -- -2
```

## Kontrolné štruktúry ##

### IF ###

```vhdl
if condition then
	-- kód, čo sa spustí ak je podmienka splnená
end if;
```

### IF-ELSE ###

```vhdl
if condition then
	-- ...
else 
	-- ...
end if;
```

```vhdl
-- invertor
if (A = '0') then     -- zátvorky sú nepovinné
	A <= '1';
else
	A <= '0';
end if;
```

### IF-ELSIF-ELSE ###

```vhdl
if condition1 then
	-- ...
elsif condition2 then
	-- ...
else                  -- else nie je povinný
	-- ...
end if;
```

```vhdl
-- random príklad idk
if input = "00" then
	output <= "0000";
elsif input = "01" then
	output <= "0010";
elsif input = "10" then
	output <= "0101";
else
	output <= "1111";
end if;	
```

### CASE ###

```vhdl
case variable is
	when value1 =>
		-- ...
	when value2 =>
		-- ...
	when others =>
		-- ...
end case;
```

Je *good practice* vždy definovať `when others`, aj pokiaľ sa nič nemá stať (`when others => null`).

### FOR ###

```vhdl
for i in range loop
	-- ...
end loop
```

```vhdl
signal sum : integer := 0;
signal data : std_logic_vector(7 downto 0);

for i in 0 to 7 loop
  sum <= sum + to_integer(unsigned(data(i)));
end loop;
```

### WHILE ###

```vhdl
while condition loop
	-- ...
end loop;
```

## Štruktúra VHDL kódu ##

- Primárne stavebné jednotky (viditeľné v library)
	- Rozhranie (entity)
	- Deklarácie knižníc (package)
	- Konfigurácia (configuration)
- Sekundárne stavebné jednotky
	- Architektúra (architecture)
	- Implementácia knižnicových funkcií (package body)

`.vhd`/`.vhdl` end súbor zvyčajne obsahuje:

- Odkazy na knižnice (use)

```vhdl
library ieee;
	use ieee.std_logic_1164.all; -- logika
	use ieee.numeric_std.all; -- numerika
```

- Špecifikáciu komponentov (entity)

```vhdl
entity samplee is 
port (
    port1 : in std_logic,  -- vstup
    port2 : out std_logic, -- výstup
    port3 : inout std_logic_vector(15 downto 0) -- obojsmerný port
);
end entity;
```

- Popis komponenty (architecture)

```vhdl
architecture arch_samplee of samplee is
	-- signály sem
begin
	-- správanie sem
end architecture;
```

![Štruktúra VHDL súboru](https://user-images.githubusercontent.com/84882649/223590576-5b8aae89-95b8-40d9-b52a-15f1260aaad2.png)

### Špecifikácia komponentu ###

```text
entity entity_name is
	port (
		port_name : signal_mode signal_type [:= default_value];
		port_name : signal_mode signal_type [:= default_value];
		...
		port_name : signal_mode signal_type [:= default_value]
	);
end [entity] [entity_name];
```

#### Módy signálov ####

| **Mód**  |                                     **Význam**                                      |
| :------: | :---------------------------------------------------------------------------------: |
|   `IN`   |                        vstupný pin, dátovy tok do súčiastky                         |
|  `OUT`   | výstupný pin, dátovy tok zo súčiastky, môze byť nastavená súčiastkov ale nie čítana |
| `INOUT`  |                       obojsmerný pin, používa sa na zbernice                        |
| `BUFFER` |   výstupný pin, datovy tok zo súčiastky, no hodnota môze byť nastavená aj čítana    |

#### Generické parametre ####

Generické parametre (*generics*) umožnujú modifikovať behom inštancie entity jej chovanie.

```text
entity entity_name is
	generic (
		gen_name : data_type [:= default_value];
		gen_name : data_type [:= default_value];
		...
		gen_name : data_type [:= default_value]
	);
	port (
		...
	);
end [entity] [entity_name];
```

Napríklad:

```vhdl
entity PARITY is
	generic (N : integer);
	port (
		A   : in std_logic_vector (N-1 downto 0);
		ODD : out std_logic
	);
end PARITY;
```

## Architektúra ##

```vhdl
architecture arch_name of entity_name is
	-- deklaračná časť
begin
	-- sekcia pre paralelné príkazy
end architecture arch_name;
```

Architektúra je viazaná na komponentu (entitu) menom. V deklaračnej časti možno deklarovať signály, konštanty, typy, funkcie etc.; sekcia paralelných príkazov môže obsahovať instancie komponentov a procesy.

- Architektúra zložená z procesov sa nazýva *behaviorálny popis*
- Architektúra instancie komponentov sa nazýva *štruktúrny popis*

![Zloženie popisu architektúry komponenty](https://user-images.githubusercontent.com/84882649/223598108-f74dd439-e284-4c5b-b4f8-3faa30e00b36.png)

Príkazy v architektúre sú vyhodnocované *paralelne*. Pre modelovanie sekvenčného chovania sa používa **proces**.

- Príkazy v procese sú vyhodnocované sekvenčne.
- Proces je chápaný ako paralelná jednotka.
- Procesy môžu komunikovať medzi sebou pomocou signálov.
- Procesy sú aktivované udalosťami
  - implicitne — *sensitivity list*
  - explicitne — *waiting*

Najčastejšie chceme, aby proces bol spustený na nábežnú hranu hodinového signálu:

```vhdl
process_sample: process (CLK)
begin
	if rising_edge(CLK) then
		-- ...
	end if;
end process;
```

Signály, na ktoré proces reaguje (v ukážke hore len *CLK*) sú zapísané do zátvoriek za slovom `process` — to je *sensitivity list*.

```vhdl
-- špecifikácia komponentu 9bit čítača
--    CLK je hodinový signál
--    Q je výstupná hodnota čítača
entity cnt9 is
	port (
		CLK : in  std_logic;
		Q   : out std_logic_vector(3 downto 0)
	);
end cnt9;

-- architektúra komponentu
architecture beh of cnt9 is
	-- vnútorné signály
	signal cnt : std_logic_vector(3 downto 0) := "0000";
	signal eq  : std_logic;
begin
	-- proces samotného čítača
	citac: process (CLK)
	begin
		if rising_edge(CLK) then
			cnt <= cnt + 1;
			if (eq = '1') then
				cnt <= "0000";
			end if;
		end if;
	end process;

	-- paralelne-spúšťané príkazy
	eq <= '1' when cnt = "1001" else '0';
	
	Q <= cnt;
end architecture;
```

## "typedef" ##

### Vlastný typ ###

implicitne `integer` typ; nie je rozdiel medzi použitím `to` a `downto` (teda okrem poradia).

```vhdl
type day is range 1 to 31;

type byte is range 0 to 255;
type word is range 65535 downto 0;
```

Je možné definovať jednotky vlastného typu konštrukciou `units`:

```vhdl
type resistance is range 1 to 10e9
units
	ohm;                -- základná jednotka
	kohm = 1000 ohm;    -- odvodená, násobená jednotka
end units;

constant test : resistance := 25 kohm;
```

Iný typ/explicitne `integer`:

```vhdl
subtype day is integer range 0 to 31;
```

### Pole ###

```vhdl
-- neobmedzené pole
type arr_1 is array (integer range <>) of bit;

-- obmedzené polia
type arr_2 is array (integer range -5 to 5) of bit;
type arr_3 is array (-5 to 5) of bit;
type arr_3 is array (5 downto -5) of bit;

-- môžu byť viac–rozmerné...
type arr_4 is array (15 downto 0, 0 to 3) of bit;

-- ...alebo používať výčet...
type color is (red, green, blue);
type arr_5 is array (color range red to blue) of bit;

-- ...ale záleží na syntéznom nástroji, či to
-- bude podporovať...
type arr_6 is array (15 downto 0) of bit_vector(0 to 3);

-- príklad: preddefinované polia
type string is array (positive range <>) of character;
type bit_vector is array (natural range <>) of bit;
type arr is array (integer range <>)
```

Rovnaký spôsob indexácie ako komplexné typy.

```vhdl
-- arr_1 = ('1', '0', '0', '1')
arr_1(0) <= '0';
-- arr_1 = ('0', '0', '0', '1')
```

Pri viac–dimenzných poliach funguje `arr(1,1)`.

### Výčet (enum) ###

`type` je možné použiť aj na tvorbu výčtov (`enum`) zapísaním možných hodnôt do zátvorky:

```vhdl
type bit is ('0', '1');
type bool is (true, false);

type state is (s0, s1, s2);
type color is (blue, red, green);
type mixed is (eq, ne, '-', '+');
```

Rovnako ako v napr. C-čku obsahuje výčet číselné hodnoty — na poradí deklarácií teda záleží!

```vhdl
type rainbow is (red, orange, yellow, green, blue, indigo, violet);
```

```vhdl
red = 000, orange = 001, yellow = 010, green = 011, 
blue = 100, indigo = 101, violet = 110
```

### Alias ###

`alias` dovoľuje prideliť iný identifikátor už existujúcemu objektu (alebo jeho časti), používa sa na zprehľadnenie kódu.

```text
alias new_name [: Datatype] is existing_name [signature];
signature = [Datatype, ... return datatype]
```

```vhdl
signal data    : bit_vector(9 downto 0);
alias startbit : bit is data(9);
alias parity   : bit is data(1);

signal my_float : std_logic_vector(0 to 31);
alias mantissa  : std_logic_vector(23 downto 0) is my_float(8 to 31);
alias exponent is my_float(0 to 7);
```

## Atribúty ##

Atribúty poskytujú informácie o objektu alebo definujú nový objekt.

```text
object_name'attribute_designator
```

### Všeobecné atribúty dátových typov ###

- `T'POS(val)` — pozícia *value* v type *T*
- `T'VAL(pos)` — hodnota v type *T* na pozícií *pos*
- `T'SUCC(val)` — hodnota v type *T* nasledujúca za hodnotou *val*
- `T'PRED(val)` — hodnota v type *T* predchádzajúca hodnotu *val*
- `T'LEFTOF(val)` — hodnota v type *T* na ľavo od hodnoty *val*
- `T'RIGHTOF(val)` — hodnota v type *T* na pravo od hodnoty *val*
- `T'LEFT`, `T'RIGHT`, `T'HIGH`, `T'LOW` — krajné hodnoty typu *T*
- `T'LENGTH` — dĺžka/veľkosť typu *T*
- `T'IMAGE(val)` — reprezentácia hodnoty *val* v type *T* (*VHDL-93+*)
- `T'VALUE(img)` — inverzia `T'IMAGE`

### Atribúty signálu ###

- `S'EVENT` — `true` pokiaľ nastala zmena v signále *S*
- `S'LAST_EVENT` — čas poslednej udalosti signálu *S*
- `S'LAST_VALUE` — hodnota sigálu *S* pred poslednou udalosťou
- `S'DELAYED[(t)]` — vráti signál *S* oneskorený o *t*

## Funkcie a procedúry ##

Funkcie vo VHDL môžu byť volané len v rámci výrazu a mať práve jednu návratovú hodnotu.

Procedúry naopak nemajú návratovú hodnotu, a na rozdiel od funkcií môžu meniť parametre.

Vo VHDL je funkcia je v podstate **výraz** a procedúra je **príkaz**.

### Deklarácia funkcie ###

```text
function designator [(param1; param2; ...)] return datatype;
```

- *designator* môže byť identifikátor (názov) funkcie alebo znak operácie
- *paramN* môže byť konštanta (default), signál alebo súbor
- za názvom parametru môže byť voliteľne režim signálu (in, out,...)

```vhdl
function max(A, B: integer) return integer;
function max(A, B: IN integer) return integer;
function max(constant A, B: IN integer) return integer;
function random return float;
function "+" (L:bit_vector; R: bit_vector) return bit_vector;
```

### Definícia funkcie ###

- Príkazy funkcie sú vyhodnocované **sekvenčne**
- Funkcie nesmú obsahovať `WAIT`
- Funkcie musia obsahovať `RETURN`

```vhdl
function max(A, B: integer) return integer is
begin
	if A > B then
		return A;
	else
		return B;
	end if;
end;
```

```vhdl
function log2(A: integer) return integer is
	variable bits : integer := 0;
	variable b    : integer := 1;
begin
	while (b <= a) loop
		b := b * 2;
		bits := bits + 1;
	end loop;
	return bits;
end function;
```

### Procedúry ###

- Procedúry sa deklarujú obdobne ako funkcie
- Príkazy procedúr sú vyhodnocované taktiež **sekvenčne**
- Procedúry nemajú návratovú hodnotu, ale môžu meniť svoje parametre
- Definícia procedúry môže/nemusí obsahovať `RETURN`

```vhdl
procedure inverter (signal A: IN std_logic; signal B: OUT std_logic) is
begin
	if A = '1' then
		B <= '0';
	elsif A = '0' then
		B <= '1';
	end if;
end procedure;

inverter(A, Q); -- Q <= not A;
```

## Načítanie dát zo súboru ##

`file` je dátový objekt odkazujúci na súbor (na sekvenciu hodnôt určitého dátového typu). Kód obsahujúci `file` je **nesyntetizovateľný**!

```vhdl
file data : text open read_mode is "./data.txt"
```

Manipulácia funkciami:

- `read(file, data)`
- `write(file, data)`
- `endfile(file)`

```vhdl
-- Príklad: načítanie 32b hodnôt z bin. súboru
type integer_file is file of integer;

file testfile : integer_file is in "./data.bin";

variable i : integer;

while not endfile(testfile) loop
	read(testfile, i);
	-- ...
	report integer'image(i);
end loop;
```

## Príklady ##

### Komponenty ###

#### 2–to–1 Multiplexor ####

```vhdl
entity MUX2 is
	port (
		IN0, IN1 : in  std_logic;
		SEL      : in  std_logic;
		OUT      : out std_logic
	);
end MUX2;

architecture dataflow of MUX2 is
begin
	OUT <= IN0 when SEL = '0' else IN1;
end dataflow;
```

#### 1–to–2 Demultiplexor ####

```vhdl
entity DEMUX2 is
	port (
		IN         : in  std_logic;
		SEL        : in  std_logic;
		OUT0, OUT1 : out std_logic
	);
end DEMUX2;

architecture dataflow of DEMUX2 is
begin
	OUT0 <= IN when SEL = '0' else '0';
	OUT1 <= IN when SEL = '1' else '0';
end dataflow;
```

### Logické hradlá ###

#### AND Gate ####

```vhdl
entity ANDGATE is
	port (
		IN1, IN2 : in  std_logic;
		OUT1     : out std_logic
	);
end ANDGATE;

architecture RTL of ANDGATE is
begin
	OUT1 <= IN1 and IN2;
end RTL;
```

#### OR Gate ###

```vhdl
entity ORGATE is
	port (
		IN1, IN2 : in  std_logic;
		OUT1     : out std_logic
	);
end ORGATE;

architecture RTL of ORGATE is
begin
	OUT1 <= IN1 or IN2;
end RTL;
```

#### NOT Gate ###

```vhdl
entity NOTGATE is
	port (
		IN1  : in  std_logic;
		OUT1 : out std_logic
	);
end NOTGATE;

architecture RTL of NOTGATE is
begin
	OUT1 <= not IN1;
end RTL;
```

#### XOR Gate ####

```vhdl
entity XORGATE is
	port (
		IN1, IN2 : in  std_logic;
		OUT1     : out std_logic
	);
end XORGATE;

architecture RTL of XORGATE is
begin
	OUT1 <= IN1 xor IN2;
end RTL;
```

#### NAND Gate ####

```vhdl
entity NANDGATE is
	port (
		IN1, IN2 : in  std_logic;
		OUT1     : out std_logic
	);
end NANDGATE;

architecture RTL of NANDGATE is
begin
	OUT1 <= not (IN1 and IN2);
end RTL;
```

### Analógové konštrukcie ###

#### Rezistor ####

```vhdl
library DISCIPLINES;
use DISCIPLINES.ELECTROMAGNETIC_SYSTEM.ALL;

entity RESISTOR is
	port (
		quantity R : in real:= 1.0e+3;
		terminal P, N : electrical
	);
end RESISTOR;

architecture beh of RESISTOR is
	quantity U across I through P to N;
begin
	U == R * I;
end beh;
```

#### Kondenzátor ####

```vhdl
library DISCIPLINES;
use DISCIPLINES.ELECTROMAGNETIC_SYSTEM.ALL;

entity CAPACITOR is
	port (
		quantity  C : in real:= 1.0e-6;
		terminal P, N : electrical
	);
end CAPACITOR;

architecture beh of CAPACITOR is
	quantity U across I through P to N
begin
	I == C * U'dot;
end beh;
```

## Zdroje ##

- Vojtěch Mrázek & Zdeněk Vašíček (2023). ["Prezentácie na prednášky IVH"](https://moodle.vut.cz/course/view.php?id=231039#section-2).
- Ismail El Badawy (2020). ["VHDL Cheatsheet"](https://github.com/ismailelbadawy).
- Filip Orság (2022). "Prezentácie na predášky ISU".
- [FPGATutorial.com](https://fpgatutorial.com)