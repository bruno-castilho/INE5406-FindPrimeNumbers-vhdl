library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_memoriaRAM is
	generic(	
		latencia: time := 1 ns;
		dataWidth: positive := 4;
		addressWidth: positive := 4
	);
end entity;

architecture arch of testbench_memoriaRAM is

component memoriaRAM is
	generic(
		dataWidth: positive := 8;
		addressWidth: positive := 8
	);
	PORT(
		address		: IN STD_LOGIC_VECTOR (addressWidth-1 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (dataWidth-1 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (dataWidth-1 DOWNTO 0)
	);
end component;

signal input, output: std_logic_vector(dataWidth-1 downto 0);
signal address: std_logic_vector(addressWidth-1 downto 0);
signal clock, wren: std_logic;

begin
		utt: memoriaRAM
		generic map (dataWidth, addressWidth)
		port map (address, clock, input, wren, output);
		
setClock: process is
begin
	clock <= '0';
	wait for latencia/2;
	clock <= '1';
	wait for latencia/2;
end process;
	
stimulus: process
		begin
			wait for latencia/2;
			for i in ((addressWidth ** 2) - 1)  downto 0 loop
					input <= std_logic_vector(to_unsigned(((dataWidth ** 2 - 1) - abs(i)), dataWidth));
					address <= std_logic_vector(to_unsigned(i, dataWidth));
					wren <= '1';
					wait for latencia;
			end loop;		
			for i in ((addressWidth ** 2) - 1) downto 0 loop
					address <= std_logic_vector(to_unsigned(i, dataWidth));
					wren <= '0';
					wait for latencia;
					assert output= std_logic_vector(to_unsigned(((dataWidth ** 2 - 1) - abs(i)), dataWidth))report "Ferrou" severity error;
			end loop;
			wait;
	end process;
end architecture;