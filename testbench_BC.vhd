library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Pkg_find_prime_numbers_BC_Estado.all;

entity testbench_BC is
	generic(	
		latencia: time := 1 ns;
		dataWidth: positive := 4;
		addressWidth: positive := 4
	);
end entity;

architecture arch of testbench_BC is

component bloco_controle_find_prime_numbers is
	port (
		-- control inputs
		clk: in std_logic;
		reset_req: in std_logic;
		chipselect: in std_logic;
		readd: in std_logic;
		writee: in std_logic;
		-- status from OperativeBlock
		sttiMenorIgualAteN, sttDividendoMaiorIgualDivisor, sttDivisorMenorI, sttDividendoIgualZero, sttVetorI: in std_logic;
		-- control outputs
		interrupt: out std_logic;
		-- commands to OperativeBlock
		cmdSetAteN, cmdSetI, cmdResetNotPrimo, cmdSetNotPrimo, cmdSetDivisor, cmdSetDividendo, 
		cmdSetVetorI, cmdSetOutput, cmdSelectI, cmdSelectDivisor, cmdSelectDividendo: out std_logic;
		testEstadoAtual: out Estado
	);
end component;

signal clk, reset_req, chipselect, readd, writee, interrupt: std_logic;
signal sttiMenorIgualAteN, sttDividendoMaiorIgualDivisor, sttDivisorMenorI, sttDividendoIgualZero, sttVetorI:  std_logic;
signal cmdSetAteN, cmdSetI, cmdResetNotPrimo, cmdSetNotPrimo, cmdSetDivisor, cmdSetDividendo, cmdSetVetorI, cmdSetOutput, cmdSelectI, cmdSelectDivisor, cmdSelectDividendo: std_logic;
signal testEstadoAtual: Estado;
begin
		utt: bloco_controle_find_prime_numbers
		port map (clk, reset_req, chipselect, readd, writee, sttiMenorIgualAteN, sttDividendoMaiorIgualDivisor, 
						sttDivisorMenorI, sttDividendoIgualZero, sttVetorI, interrupt, cmdSetAteN, cmdSetI, cmdResetNotPrimo, 
						cmdSetNotPrimo, cmdSetDivisor, cmdSetDividendo, cmdSetVetorI, cmdSetOutput, cmdSelectI, cmdSelectDivisor, 
						cmdSelectDividendo, testEstadoAtual
					);
setClock: process is
begin
	clk <= '1';
	wait for latencia/2;
	clk <= '0';
	wait for latencia/2;
end process;
			
stimulus: process
		begin
			reset_req <= '1';
			sttIMenorIgualAteN <= '0';
			sttDivisorMenorI <= '0';
			sttDividendoMaiorIgualDivisor <='0';
			sttDividendoIgualZero <= '0';
			chipselect <='0';
			writee <='0';
			readd <='0';
			sttVetorI <='0';
			wait for latencia + 0.1ns ;
			assert 
			testEstadoAtual=SL01 and cmdSetAteN = '0' and cmdSetI = '0' and cmdResetNotPrimo = '0' and cmdSetNotPrimo = '0'  
			and cmdSetDivisor = '0' and cmdSetDividendo = '0' and cmdSetVetorI = '0' and cmdSetOutput = '0'
			report "Ferrou" severity error;	
			reset_req <= '0';
			sttIMenorIgualAteN <= '0';
			sttDivisorMenorI <= '0';
			sttDividendoMaiorIgualDivisor <='0';
			sttDividendoIgualZero <= '0';
			chipselect <='0'; 
			writee <='0';
			readd <='0';
			sttVetorI <='0';
			wait for latencia;
			assert 
			testEstadoAtual=SL03 and interrupt = '1' and cmdSetAteN = '0' and cmdSetI = '0' and cmdResetNotPrimo = '0' and cmdSetNotPrimo = '0'  
			and cmdSetDivisor = '0' and cmdSetDividendo = '0' and cmdSetVetorI = '0' and cmdSetOutput = '0'
			report "Ferrou" severity error;
			reset_req <= '0';
			sttIMenorIgualAteN <= '0';
			sttDivisorMenorI <= '0';
			sttDividendoMaiorIgualDivisor <='0';
			sttDividendoIgualZero <= '0';
			chipselect <='1';
			writee <='1';
			readd <='0';
			sttVetorI <='0';
			wait for latencia;
			assert 
			testEstadoAtual=SL03a and cmdSetAteN = '1' and cmdSetI = '0' and cmdResetNotPrimo = '0' and cmdSetNotPrimo = '0'  
			and cmdSetDivisor = '0' and cmdSetDividendo = '0' and cmdSetVetorI = '0' and cmdSetOutput = '0'	
			report "Ferrou" severity error;
			wait for latencia;
			assert 
			testEstadoAtual=SL05 and cmdSelectI = '0' and cmdSetAteN = '0' and cmdSetI = '1' and cmdResetNotPrimo = '0' and cmdSetNotPrimo = '0'  
			and cmdSetDivisor = '0' and cmdSetDividendo = '0' and cmdSetVetorI = '0' and cmdSetOutput = '0'
			report "Ferrou" severity error;
			wait for latencia;
			assert testEstadoAtual=SL06 report "Ferrou" severity error;
			reset_req <= '0';
			sttIMenorIgualAteN <= '1';
			sttDivisorMenorI <= '0';
			sttDividendoMaiorIgualDivisor <='0';
			sttDividendoIgualZero <= '0';
			chipselect <='0';
			writee <='0';
			readd <='0';
			sttVetorI <='0';
			wait for latencia;
			assert 
			testEstadoAtual=SL07 and cmdSetAteN = '0' and cmdSetI = '0' and cmdResetNotPrimo = '1' and cmdSetNotPrimo = '0'  
			and cmdSetDivisor = '0' and cmdSetDividendo = '0' and cmdSetVetorI = '0' and cmdSetOutput = '0'
			report "Ferrou" severity error;
			wait for latencia;
			assert 
			testEstadoAtual=SL08 and cmdSelectDivisor <= '0' and cmdSetAteN = '0' and cmdSetI = '0' and cmdResetNotPrimo = '0' and cmdSetNotPrimo = '0'  
			and cmdSetDivisor = '1' and cmdSetDividendo = '0' and cmdSetVetorI = '0' and cmdSetOutput = '0'
			report "Ferrou" severity error;
			wait for latencia;
			assert testEstadoAtual=SL09 report "Ferrou" severity error;
			reset_req <= '0';
			sttIMenorIgualAteN <= '0';
			sttDivisorMenorI <= '1';
			sttDividendoMaiorIgualDivisor <='0';
			sttDividendoIgualZero <= '0';
			chipselect <='0'; 
			writee <='0';
			readd <='0';
			sttVetorI <='0';
			wait for latencia;
			assert 
			testEstadoAtual=SL10 and cmdSelectDividendo = '0' and cmdSetAteN = '0' and cmdSetI = '0' and cmdResetNotPrimo = '0' and cmdSetNotPrimo = '0'  
			and cmdSetDivisor = '0' and cmdSetDividendo = '1' and cmdSetVetorI = '0' and cmdSetOutput = '0'
			report "Ferrou" severity error;
			wait for latencia;
			assert testEstadoAtual=SL11 report "Ferrou" severity error;
			reset_req <= '0';
			sttIMenorIgualAteN <= '0';
			sttDivisorMenorI <= '0';
			sttDividendoMaiorIgualDivisor <='1';
			sttDividendoIgualZero <= '0';
			chipselect <='0';
			writee <='0';	
			readd <='0';
			sttVetorI <='0';
			wait for latencia;
			assert 
			testEstadoAtual=SL12 and cmdSelectDividendo = '1' and cmdSetAteN = '0' and cmdSetI = '0' and cmdResetNotPrimo = '0' and cmdSetNotPrimo = '0'  
			and cmdSetDivisor = '0' and cmdSetDividendo = '1' and cmdSetVetorI = '0' and cmdSetOutput = '0'
			report "Ferrou" severity error;
			wait for latencia;
			assert testEstadoAtual=SL13 report "Ferrou" severity error;
			wait for latencia;
			assert testEstadoAtual=SL11 report "Ferrou" severity error;
			reset_req <= '0';
			sttIMenorIgualAteN <= '0';
			sttDivisorMenorI <= '0';
			sttDividendoMaiorIgualDivisor <='0';
			sttDividendoIgualZero <= '0';
			chipselect <='0'; 
			writee <='0';
			readd <='0';
			sttVetorI <='0';
			wait for latencia;
			assert testEstadoAtual=SL14 report "Ferrou" severity error;
			reset_req <= '0';
			sttIMenorIgualAteN <= '0';
			sttDivisorMenorI <= '0';
			sttDividendoMaiorIgualDivisor <='0';
			sttDividendoIgualZero <= '0';
			chipselect <='0'; 
			writee <='0';
			readd <='0';
			sttVetorI <='0';
			wait for latencia;
			assert 
			testEstadoAtual=SL18 and cmdSelectDivisor = '1' and cmdSetAteN = '0' and cmdSetI = '0' and cmdResetNotPrimo = '0' and cmdSetNotPrimo = '0'  
			and cmdSetDivisor = '1' and cmdSetDividendo = '0' and cmdSetVetorI = '0' and cmdSetOutput = '0'
			report "Ferrou" severity error;
			wait for latencia;
			assert testEstadoAtual=SL09 report "Ferrou" severity error;
			reset_req <= '0';
			sttIMenorIgualAteN <= '0';
			sttDivisorMenorI <= '1';
			sttDividendoMaiorIgualDivisor <='0';
			sttDividendoIgualZero <= '0';
			chipselect <='0';
			writee <='0';	
			readd <='0';
			sttVetorI <='0';
			wait for latencia;
			assert 
			testEstadoAtual=SL10 and cmdSelectDividendo = '0' and cmdSetAteN = '0' and cmdSetI = '0' and cmdResetNotPrimo = '0' and cmdSetNotPrimo = '0'  
			and cmdSetDivisor = '0' and cmdSetDividendo = '1' and cmdSetVetorI = '0' and cmdSetOutput = '0' 
			report "Ferrou" severity error;
			wait for latencia;
			assert testEstadoAtual=SL11 report "Ferrou" severity error;
			reset_req <= '0';
			sttIMenorIgualAteN <= '0';
			sttDivisorMenorI <= '0';
			sttDividendoMaiorIgualDivisor <='0';
			sttDividendoIgualZero <= '0';
			chipselect <='0';
			writee <='0';
			readd <='0';
			sttVetorI <='0';
			wait for latencia;
			assert testEstadoAtual=SL14 report "Ferrou" severity error;
			reset_req <= '0';
			sttIMenorIgualAteN <= '0';
			sttDivisorMenorI <= '0';
			sttDividendoMaiorIgualDivisor <='0';
			sttDividendoIgualZero <= '1';
			chipselect <='0'; 
			writee <='0';
			readd <='0';
			sttVetorI <='0';
			wait for latencia;
			assert testEstadoAtual=SL15 and cmdSetAteN = '0' and cmdSetI = '0' and cmdResetNotPrimo = '0' and cmdSetNotPrimo = '1'  
			and cmdSetDivisor = '0' and cmdSetDividendo = '0' and cmdSetVetorI = '0' and cmdSetOutput = '0' report "Ferrou" severity error;
			wait for latencia;
			assert testEstadoAtual=SL16 report "Ferrou" severity error;
			wait for latencia;
			assert 
			testEstadoAtual=SL19 and cmdSetAteN = '0' and cmdSetI = '0' and cmdResetNotPrimo = '0' and cmdSetNotPrimo = '0'  
			and cmdSetDivisor = '0' and cmdSetDividendo = '0' and cmdSetVetorI = '1' and cmdSetOutput = '0'
			report "Ferrou" severity error;
			wait for latencia;
			assert 
			testEstadoAtual=SL20 and cmdSelectI = '1' and cmdSetAteN = '0' and cmdSetI = '1' and cmdResetNotPrimo = '0' and cmdSetNotPrimo = '0'  
			and cmdSetDivisor = '0' and cmdSetDividendo = '0' and cmdSetVetorI = '0' and cmdSetOutput = '0'
			report "Ferrou" severity error;
			wait for latencia;
			assert testEstadoAtual=SL06 report "Ferrou" severity error;
			reset_req <= '0';
			sttIMenorIgualAteN <= '0';
			sttDivisorMenorI <= '0';
			sttDividendoMaiorIgualDivisor <='0';
			sttDividendoIgualZero <= '0';
			chipselect <='0';
			writee <='0';
			readd <='0';
			sttVetorI <='0';
			wait for latencia;
			assert 
			testEstadoAtual=SL22 and cmdSelectI = '0' and cmdSetAteN = '0' and cmdSetI = '1' and cmdResetNotPrimo = '0' and cmdSetNotPrimo = '0'  
			and cmdSetDivisor = '0' and cmdSetDividendo = '0' and cmdSetVetorI = '0' and cmdSetOutput = '0'
			report "Ferrou" severity error;
			wait for latencia;
			assert testEstadoAtual=SL23 report "Ferrou" severity error;
			reset_req <= '0';
			sttIMenorIgualAteN <= '1';
			sttDivisorMenorI <= '0';
			sttDividendoMaiorIgualDivisor <='0';
			sttDividendoIgualZero <= '0';
			chipselect <='0'; 
			writee <='0';
			readd <='0';
			sttVetorI <='0';
			wait for latencia;
			assert testEstadoAtual=SL24 report "Ferrou" severity error;
			wait for latencia;
			assert testEstadoAtual=SL24a report "Ferrou" severity error;
			wait for latencia;
			assert testEstadoAtual=SL25 report "Ferrou" severity error;
			reset_req <= '0';
			sttIMenorIgualAteN <= '1';
			sttDivisorMenorI <= '0';
			sttDividendoMaiorIgualDivisor <='0';
			sttDividendoIgualZero <= '0';
			chipselect <='0';
			writee <='0';	
			readd <='0';
			sttVetorI <='0';
			wait for latencia;
			assert 
			testEstadoAtual=SL26 and interrupt = '1' and cmdSelectI = '0' and cmdSetAteN = '0' and cmdSetI = '0' and cmdResetNotPrimo = '0' and cmdSetNotPrimo = '0'  
			and cmdSetDivisor = '0' and cmdSetDividendo = '0' and cmdSetVetorI = '0' and cmdSetOutput = '1'
			report "Ferrou" severity error;
			reset_req <= '0';
			sttIMenorIgualAteN <= '1';
			sttDivisorMenorI <= '0';
			sttDividendoMaiorIgualDivisor <='0';
			sttDividendoIgualZero <= '0';
			chipselect <='1';
			writee <='0';	
			readd <='1';
			sttVetorI <='0';
			wait for latencia;
			assert testEstadoAtual=SL26a report "Ferrou" severity error;
			wait for latencia;
			assert testEstadoAtual=SL27 report "Ferrou" severity error;
			wait for latencia;
			assert 
			testEstadoAtual=SL28 and cmdSelectI = '1'  and cmdSelectI = '0' and cmdSetAteN = '0' and cmdSetI = '1' and cmdResetNotPrimo = '0' and cmdSetNotPrimo = '0'  
			and cmdSetDivisor = '0' and cmdSetDividendo = '0' and cmdSetVetorI = '0' and cmdSetOutput = '0'
			report "Ferrou" severity error;
			wait for latencia;
			assert testEstadoAtual=SL23 report "Ferrou" severity error;
			reset_req <= '0';
			sttIMenorIgualAteN <= '0';
			sttDivisorMenorI <= '0';
			sttDividendoMaiorIgualDivisor <='0';
			sttDividendoIgualZero <= '0';
			chipselect <='0';
			writee <='0';
			readd <='0';
			sttVetorI <='0';
			wait for latencia;
			assert testEstadoAtual=SL29 report "Ferrou" severity error;	
			wait for latencia;
			assert testEstadoAtual=SL01 report "Ferrou" severity error;		
			wait;

	end process;
end architecture;