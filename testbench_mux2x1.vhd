library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_mux2x1 is
	generic(	
		latencia: time := 1 ns;
		dataWidth: positive := 4
	);
end entity;

architecture arch of testbench_mux2x1 is

component multiplexador2 is
	generic(
		width: positive := 8
	);
	port(
		inp0, inp1: in std_logic_vector(width-1 downto 0);
		sel: in std_logic;
		outp: out std_logic_vector(width-1 downto 0)
	);
end component;

signal input0, input1, output: std_logic_vector(dataWidth-1 downto 0);
signal selector: std_logic;

begin
	uut: multiplexador2 	
	generic map(4) 
	port map(input0,input1,selector,output);
	
stimulus: process
		begin
			input0 <= "0000";
			input1 <= "1111";
			selector <= '0';
			wait for latencia;
			assert output="0000" report "Ferrou" severity error;
			selector <= '1';
			wait for latencia;
			assert output="1111" report "Ferrou" severity error;
			input1 <= "1010";
			wait for latencia;
			assert output="1010" report "Ferrou" severity error;
			wait;
	end process;
end architecture;