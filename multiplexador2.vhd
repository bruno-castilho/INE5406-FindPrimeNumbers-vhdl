library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplexador2 is
	generic(
		width: positive := 8
	);
	port(
		inp0, inp1: in std_logic_vector(width-1 downto 0);
		sel: in std_logic;
		outp: out std_logic_vector(width-1 downto 0)
	);
end entity;

architecture behavioural of multiplexador2 is

signal tmp: std_logic_vector(width-1 downto 0);

begin
	tmp <= inp1 when sel='1' else inp0;
	
	outp <= tmp after 1ns;
end;