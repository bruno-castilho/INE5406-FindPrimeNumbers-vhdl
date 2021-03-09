library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_incrementador is
	generic(	
		latencia: time := 1 ns;
		dataWidth: positive := 4
	);
end entity;

architecture arch of testbench_incrementador is

component incrementador is
	generic(
		width: positive := 8;
		isSigned: boolean := true
	);
	port(
		inp: in std_logic_vector(width-1 downto 0);
		outp: out std_logic_vector(width-1 downto 0)
	);
end component;

signal input, output: std_logic_vector(dataWidth-1 downto 0);

begin
		utt: incrementador
		generic map (dataWidth, false)
		port map (input, output);
	
stimulus: process
		begin
			input <= "0000";
			wait for latencia;
			assert output="0001" report "Ferrou" severity error;
			input <= output;
			wait for latencia;
			assert output="0010" report "Ferrou" severity error;
			input <= output;
			wait for latencia;
			assert output="0011" report "Ferrou" severity error;
			input <= output;
			wait for latencia;
			assert output="0100" report "Ferrou" severity error;
			wait;
	end process;
end architecture;