library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_comparadorMaiorIgual is
	generic(	
		latencia: time := 1 ns;
		dataWidth: positive := 4
	);
end entity;

architecture arch of testbench_comparadorMaiorIgual is

component comparadorMaiorIgual is
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
signal MaiorIgual: std_logic;

begin
		utt: comparadorMaiorIgual
		generic map (dataWidth, false)
		port map (input0, input1, MaiorIgual);
	
stimulus: process
		begin
			input0 <= "1000";
			input1 <= "1000";
			wait for latencia;
			assert MaiorIgual='1' report "Ferrou" severity error;
			input1 <= "1001";
			wait for latencia;
			assert MaiorIgual='0' report "Ferrou" severity error;
			input1 <= "0111";
			wait for latencia;
			assert MaiorIgual='1' report "Ferrou" severity error;
			wait;
	end process;
end architecture;