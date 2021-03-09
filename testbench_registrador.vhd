library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_registrador is
	generic(	
		latencia: time := 1 ns;
		dataWidth: positive := 4
	);
end entity;

architecture arch of testbench_registrador is

component registrador is
	generic(
		width: positive := 8
	);
	port(
		-- control inputs
		clk, reset, load: in std_logic;
		-- data inputs
		datain: in std_logic_vector(width-1 downto 0);
		-- data outputs
		dataout: out std_logic_vector(width-1 downto 0)
	);
end component;

signal datain, dataout: std_logic_vector(dataWidth-1 downto 0);
signal clk, reset, load: std_logic;

begin
		utt: registrador
		generic map (dataWidth)
		port map (clk, reset, load, datain, dataout);
		
setClock: process is
begin
	clk <= '0';
	wait for latencia;
	clk <= '1';
	wait for latencia;
end process;
	
stimulus: process
		begin
			reset <= '1';
			load <='0';
			wait for latencia*2;
			assert dataout="0000" report "Ferrou" severity error;
			reset <='0';
			load <='1';
			datain <= "1111";
			wait for latencia*2;
			assert dataout="1111" report "Ferrou" severity error;
			reset <='0';
			load <='1';
			datain <= "0101";
			wait for latencia*2;
			assert dataout="0101" report "Ferrou" severity error;
			reset <='0';
			load <='0';
			datain <= "1000";
			wait for latencia*2;
			assert dataout="0101" report "Ferrou" severity error;
			reset <='0';
			load <='1';
			datain <= "1000";
			wait for latencia*2;
			assert dataout="1000" report "Ferrou" severity error;	
			wait;
	end process;
end architecture;