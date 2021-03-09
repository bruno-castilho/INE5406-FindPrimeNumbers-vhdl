library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_subtrator is
	generic(	
		latencia: time := 1 ns;
		dataWidth: positive := 4
	);
end entity;

architecture arch of testbench_subtrator is

component subtrator is
	generic(
		width: positive := 8;
		isSigned: boolean := true
	);
	port(
		inpA,inpB: in std_logic_vector(width-1 downto 0);
		outp: out std_logic_vector(width-1 downto 0)
	);
end component;

signal inputA, inputB, output: std_logic_vector(dataWidth-1 downto 0);

begin
		utt: subtrator
		generic map (dataWidth, false)
		port map (inputA, inputB, output);
	
stimulus: process
		begin
			inputA <= "1000";
			inputB <= "1000";
			wait for latencia;
			assert output="0000" report "Ferrou" severity error;
			inputA <= "1000";
			inputB <= "0111";
			wait for latencia;
			assert output="0001" report "Ferrou" severity error;
			inputA <= "1000";
			inputB <= "0001";
			wait for latencia;
			assert output="0111" report "Ferrou" severity error;
			inputA <= "1000";
			inputB <= "0100";
			wait for latencia;
			assert output="0100" report "Ferrou" severity error;
			wait;
	end process;
end architecture;