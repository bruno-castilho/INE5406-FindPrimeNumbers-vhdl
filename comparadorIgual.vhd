library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparadorIgual is
	generic(
		width: positive := 8;
		isSigned: boolean := true
	);
	port(
		inp0, inp1: in std_logic_vector(width-1 downto 0);
		output: out std_logic
	);
end entity;

architecture behavioural of comparadorIgual is
signal ehIgual: std_logic;
begin
	sig: if isSigned generate
		ehIgual <= '1' when signed(inp0) = signed(inp1) else '0'; 
	end generate;
	
	unsig: if not isSigned generate
		ehIgual <= '1' when unsigned(inp0) = unsigned(inp1) else '0';
	end generate;
	
	output <= ehIgual after 1ns;
	
end;