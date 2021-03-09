library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_comparadorMenorIgual is
	generic(	
		latencia: time := 1 ns;
		dataWidth: positive := 4
	);
end entity;

architecture arch of testbench_comparadorMenorIgual is

component comparadorMenorIgual is
	generic(
		width: positive := 8;
		isSigned: boolean := true
	);
	port(
		inp0, inp1: in std_logic_vector(width-1 downto 0);
		output: out std_logic
	);
end component;

signal input0, input1: std_logic_vector(dataWidth-1 downto 0);
signal Menorigual: std_logic;

begin
		utt: comparadorMenorIgual
		generic map (dataWidth, false)
		port map (input0, input1, Menorigual);
	
stimulus: process
		begin
			input0 <= "1000";
			input1 <= "1000";
			wait for latencia;
			assert Menorigual='1' report "Ferrou" severity error;
			input1 <= "1001";
			wait for latencia;
			assert Menorigual='1' report "Ferrou" severity error;
			input1 <= "0111";
			wait for latencia;
			assert Menorigual='0' report "Ferrou" severity error;
			wait;
	end process;
end architecture;