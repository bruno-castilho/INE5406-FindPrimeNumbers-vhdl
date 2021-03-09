library ieee;
use ieee.std_logic_1164.all;
use work.Pkg_find_prime_numbers_BC_Estado.all;

entity bloco_controle_find_prime_numbers is
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
end entity;

architecture behaviouralFSM of bloco_controle_find_prime_numbers is
	signal proximoEstado, estadoAtual: Estado;
begin
	testEstadoAtual <= estadoAtual;
	process(estadoAtual, chipselect, readd, writee, sttIMenorIgualAteN, sttDivisorMenorI,sttDividendoMaiorIgualDivisor, sttDividendoIgualZero, sttVetorI) is
	begin
-- DIAGRAMA DE TRANSICAO DE ESTADOS DO BLOCO DE CONTROL
		proximoEstado <= estadoAtual; -- garante circSeq
		case estadoAtual is
	-- SL01:	Início do algoritmo                                   ----	SL03
			when SL01 => 
				proximoEstado <= SL03;
	-- // Recebe entradas
	-- SL03: int ateN = input()                                    ----	input_read/SL03a
			when SL03 => 
				if chipselect='1' and writee='1' then
						proximoEstado <= SL03a;
				end if;
	-- SL03a:                                                      ----  SL05
			when SL03a => 
					proximoEstado <= SL05;	
	--	// Processa
	-- SL05: int  i  =  2                                          ----	SL06
			when SL05 => 
					proximoEstado <= SL06;	
	-- SL06: for(; i <= ateN: i++){          								----	sttIMenorIgualAteN/SL07; !sttIMenorIgualAteN/SL22
			when SL06 =>
				if sttIMenorIgualAteN='1' then
					proximoEstado <= SL07;
				else
					proximoEstado <= SL22;
				end if;
	-- SL07:     std_logic notPrimo = ‘0’                      		---- 	SL08
				when SL07 => 
					proximoEstado <= SL08;
	-- SL08:     int divisor = 2;                                  ----	SL09
				when SL08 => 
					proximoEstado <= SL09;
	-- SL09:     for(; divisor < i; divisor++){          				---- 	sttDivisorMenorI/SL10; !sttDivisorMenorI/SL19
				when SL09 =>
					if sttDivisorMenorI='1' then
						proximoEstado <= SL10;
					else
						proximoEstado <= SL19;
					end if;
	-- SL10:         int dividendo = i                         		----  SL11
				when SL10 => 
					proximoEstado <= SL11;
	-- SL11:         while(dividendo >= divisor){						----	sttDividendoMaiorIgualDivisor/SL12 !sttDividendoMaiorIgualDivisor/SL14
				when SL11 =>
					if sttDividendoMaiorIgualDivisor='1' then
						proximoEstado <= SL12;
					else
						proximoEstado <= SL14;
					end if;
	-- SL12:              dividendo = dividendo - divisor        	----  SL13
				when SL12 => 
					proximoEstado <= SL13;
	-- SL13:         }    														----  SL11
				when SL13 => 
					proximoEstado <= SL11;
	-- SL14:         if(dividendo == 0)									----  sttDividendoIgualZeroSL15; !sttDividendoIgualZero/SL18
				when SL14 =>
					if sttDividendoIgualZero='1' then
						proximoEstado <= SL15;
					else
						proximoEstado <= SL18;
					end if;
	-- SL15:            notPrimo = ‘1’                        		----  SL16
				when SL15 => 
					proximoEstado <= SL16;
	-- SL16:            break                                		----  SL19
				when SL16 => 
					proximoEstado <= SL19;
	-- SL18:     }                                        			----  SL09
				when SL18 => 
					proximoEstado <= SL09;
	-- SL19:     vetor[i] = notPrimo                           		----  SL20
				when SL19 => 
					proximoEstado <= SL20;
	-- SL20: }                                            			----  SL06
				when SL20 => 
					proximoEstado <= SL06;
	-- // Apresenta saídas	
	-- SL22: i = 2                                        			----  SL23
				when SL22 => 
					proximoEstado <= SL23;
	-- SL23: for(; i <= ateN;  i++) {	----  sttiMenorIgualAteN/SL24; !sttiMenorIgualAteN/SL29
				when SL23 =>
					if sttiMenorIgualAteN='1' then
						proximoEstado <= SL24;
					else
						proximoEstado <= SL29;
					end if;
	--	SL24:		(espera por memória RAM) 									----  SL24a
				when SL24 => 
					proximoEstado <= SL24a;
	-- SL24a: 	vetorI = vetor[i](0)                      			----  SL25
				when SL24a => 
					proximoEstado <= SL25;
	-- SL25: 	if(not VetorI){                     					----	!sttVetorI/SL26; sttVetorI/SL27;
				when SL25 =>
					if sttVetorI='0' then
						proximoEstado <= SL26;
					else
						proximoEstado <= SL27;
					end if;
	-- SL26:       output(i)                       						----  output_read/SL26a
				when SL26 => 
					if chipselect='1' and readd='1' then
						proximoEstado <= SL26a;
					end if;
	-- SL26a:                                             			----  SL27
				when SL26a => 
					proximoEstado <= SL27;
	-- SL27:     }     															----	SL28 
				when SL27 => 
					proximoEstado <= SL28;	
	-- SL28: }                                            			----  SL23
				when SL28 => 
					proximoEstado <= SL23;
	-- SL29: Fim do algoritmo                                    	----  SL01
				when SL29 => 
					proximoEstado <= SL01;
		end case;
	end process;
	
	process(clk, reset_req) is
	begin
		if reset_req = '1' then
			estadoAtual <= SL01;
		elsif rising_edge(clk) then
			estadoAtual <= proximoEstado;
		end if;
	end process;

	-- output logic(s)
	process(estadoAtual) is
	begin
-- OPERACOES e COMANDOS/STATUS EQUIVALENTES (==>)  , ordenado por variavel tipo do sinal (comando ou status) e depois por variavel
--		COMANDOS:
-- 	ateN = input()  						 ==> cmdSetAteN;
		cmdSetAteN <= '0' after 1ns;
-- 	i  =  2  								 ==> cmdSetI; cmdSelectI = ‘0’;
--		i++  										 ==> cmdSetI; cmdSelectI = ‘1’;
		cmdSetI <= '0' after 1ns;
		cmdSelectI <= '0' after 1ns;
-- 	notPrimo = ‘0’ 						 ==> cmdResetNotPrimo;
		cmdResetNotPrimo <= '0' after 1ns;
-- 	notPrimo = ‘1’ 						 ==> cmdSetNotPrimo;
		cmdSetNotPrimo <= '0' after 1ns;		
-- 	divisor = 2	 							 ==> cmdSetDivisor; cmdSelectDivisor= ‘0’;
-- 	divisor++ 								 ==> cmdSetDivisor; cmdSelectDivisor= ‘1’;
		cmdSetDivisor <= '0' after 1ns;
		cmdSelectDivisor <= '0' after 1ns;
-- 	dividendo = i 							 ==> cmdSetDividendo; cmdSelectDividendo = ‘0’;
-- 	dividendo =  dividendo - divisor  ==> cmdSetDividendo; cmdSelectDividendo = “1”;
		cmdSetDividendo <= '0' after 1ns;
		cmdSelectDividendo <= '0' after 1ns;
-- 	vetor[i] = notPrimo					 ==> cmdSetVetorI;
		cmdSetVetorI <= '0' after 1ns;
-- 	Output = i                        ==> cmdSetOutput;	
		cmdSetOutput <= '0' after 1ns;
--		interrupt
		interrupt <= '0' after 1ns;

		
	case estadoAtual is	
-- DIAGRAMA DE SAIDAS DO BLOCO DE CONTROLE
	-- SL01:	Início do algoritmo                                   ----	
	-- SL02: // Recebe entradas
	-- SL03: int ateN = input()                                    ----	interrupt
			when SL03 =>
				interrupt <= '1' after 1ns;
	-- SL03a:                                                      ----  cmdSetAten
			when SL03a =>
				cmdSetAten <= '1' after 1ns;
	--	SL04: // Processa
	-- SL05: int  i  =  2                                          ----	cmdSetI; cmdSelectI = ‘0’;
			when SL05 =>
				cmdSetI <= '1' after 1ns;
				cmdSelectI <= '0' after 1ns;
	-- SL06: for(; i <= ateN: i++){          								----	
	-- SL07:     std_logic notPrimo = ‘0’                      		---- 	cmdResetNotPrimo;
			when SL07 =>
				cmdResetNotPrimo <= '1' after 1ns;
	-- SL08:     int divisor = 2;                                  ----	cmdSetDivisor; cmdSelectDivisor= ‘0’;
			when SL08 =>
				cmdSetDivisor <= '1' after 1ns;
				cmdSelectDivisor <= '0' after 1ns;
	-- SL09:     for(; divisor < i; divisor++){          				---- 	
	-- SL10:         int dividendo = i                         		----  cmdSetDividendo; cmdSelectDividendo = ‘0’;
			when SL10 =>
				cmdSetDividendo <= '1' after 1ns;
				cmdSelectDividendo <= '0' after 1ns;
	-- SL11:         while(dividendo >= divisor){						----	
	-- SL12:              dividendo = dividendo - divisor        	----  cmdSetDividendo; cmdSelectDividendo = ‘1’;
			when SL12 =>
				cmdSetDividendo <= '1' after 1ns;
				cmdSelectDividendo <= '1' after 1ns;
	-- SL13:         }    														----  
	-- SL14:         if(dividendo == 0){									----  
	-- SL15:            notPrimo = ‘1’                        		----  cmdSetNotPrimo;
			when SL15 =>
				cmdSetNotPrimo <= '1' after 1ns;

	-- SL16:            break                                		----  
	-- SL17:         }                                					----  
	-- SL18:     }                                        			----  cmdSetDivisor; cmdSelectDivisor= ‘1’;
			when SL18 =>
				cmdSetDivisor <= '1' after 1ns;
				cmdSelectDivisor <= '1' after 1ns;
	-- SL19:     vetor[i] = notPrimo           cmdSelectDivisor <= '0'                		----  cmdSetVetorI
			when SL19 =>
				cmdSetVetorI <= '1' after 1ns;
	-- SL20: }                                            			----  cmdSetI; cmdSelectI = ‘1’;
			when SL20 =>
				cmdSetI <= '1' after 1ns;
				cmdSelectI <= '1' after 1ns;
	-- SL21: // Apresenta saídas
	-- SL22: i = 2                                        			----  cmdSetI; cmdSelectI = ‘0’;
			when SL22 =>
				cmdSetI <= '1' after 1ns;
				cmdSelectI <= '0' after 1ns;
	-- SL23: for(; i <= ateN;  i++) {    									----  
	-- SL24:   	(espera por memória RAM)                      		----  
	--	SL24a:	vetorI = vetor[i](0) 										----	
	-- SL25:    if(not VetorI){                     					----  
	-- SL26:        output(i)                       					----  cmdSetOutput = '1'; interrupt
			when SL26 =>
				cmdSetOutput <= '1' after 1ns;
				interrupt <= '1' after 1ns;
	-- SL26a:                                             			----  
	-- SL27:     }     															----	                               
	-- SL28: }                                            			----  cmdSetI; cmdSelectI = ‘1’;
			when SL28 =>
				cmdSetI <= '1' after 1ns;
				cmdSelectI <= '1' after 1ns;
	-- SL29: Fim do algoritmo                                    	---- 
	
			when others =>
				null;
		end case;
	end process;

end architecture;