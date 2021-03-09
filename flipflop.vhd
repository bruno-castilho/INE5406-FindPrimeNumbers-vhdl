library ieee;
use ieee.std_logic_1164.all;


entity flipflop is
	port(
		-- control inputs
		clk, reset, load: in std_logic;
		-- data inputs
		datain: in std_logic;
		-- data outputs
		dataout: out std_logic
	);
end entity;

architecture behavioural of flipflop is
	subtype Estado is std_logic;
	signal estadoAtual, proximoEstado: Estado;
begin
	-- net-state logic
	proximoEstado <= datain when load='1' else estadoAtual 
		;--after 2.740 ns; -- :-( for gate-level simulation
	
	-- internal state
	process(clk, reset) is
	begin
		if reset='1' then
			estadoAtual <= (others=>'0');
		elsif rising_edge(clk) then
			estadoAtual <= proximoEstado;
		end if;
	end process;
	
	-- output logic(s)
	dataout <= estadoAtual after 1ns;
end;