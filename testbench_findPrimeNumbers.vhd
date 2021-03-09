library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Pkg_find_prime_numbers_BC_Estado.all;


entity testbench_findPrimeNumbers is
	generic(	
		latencia: time := 4 ns;
		dataWidth: positive := 4;
		addressWidth: positive := 4
	);
end entity;

architecture arch of testbench_findPrimeNumbers is

component findPrimeNumbers is
	generic(
		dataWidth: positive := 8;
		addressWidth: positive := 8
	);
	port(
		-- control inputs
		clk: in std_logic;
		reset_req: in std_logic;
		chipselect: in std_logic;
		readd: in std_logic;
		writee: in std_logic;
		-- data inputs
		writedata: in std_logic_vector(dataWidth-1 downto 0);
		-- control outputs
		interrupt: out std_logic;
		-- data outputs
		readdata: out std_logic_vector(dataWidth-1 downto 0);
		testEstadoAtual: out Estado
	);
end component;

signal clk, reset_req, chipselect, readd, writee, interrupt:std_logic;
signal writedata, readdata:  std_logic_vector(dataWidth-1 downto 0);
signal testEstadoAtual:  Estado;


begin
		utt: findPrimeNumbers
		generic map (dataWidth, addressWidth)
		port map (clk, reset_req, chipselect, readd, writee, writedata, interrupt, readdata, testEstadoAtual);
		

	setClock: process is
	begin
		clk <= '1';
		wait for latencia/2;
		clk <= '0';
		wait for latencia/2;
	end process;
	
	cs: process is
		begin
		wait until interrupt='1';
		chipselect <= '1';
		wait until interrupt='0';
		chipselect <= '0';
	end process;
		
	input: process is
		begin 
		wait until testEstadoAtual = SL03;
		writedata <= "1110";
		writee <= '1';
		wait until testEstadoAtual /= SL03;
		writee <= '0';
	end process;

	output: process is
		begin  
		wait until testEstadoAtual = SL26;
		readd <= '1';
		wait until testEstadoAtual /= SL26;
		readd <= '0';
	end process;
	
	stimulus: process is
		begin
		reset_req <= '1';
		wait for latencia/2;
		reset_req <= '0';
		wait;
	end process;

end architecture;