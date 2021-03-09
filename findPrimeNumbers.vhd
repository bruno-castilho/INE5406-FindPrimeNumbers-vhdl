library ieee;
use ieee.std_logic_1164.all;
use work.Pkg_find_prime_numbers_BC_Estado.all;


-- DESCRIÇAO:
	-- Recebe 1 valor, percorre por todo os números entre dois e esse valor e descobre se ele é primo ou não,
	-- então armazena no endereço da memória deste número, ‘1’ se primo e ‘0’ se não, 
   -- depois percorre pelos endereços da memória e se aquele endereço estiver o valor ‘1’ ele é mostrado na saída.
	
	
-- ALGORITMO:
--Início do algoritmo
	-- // Recebe entradas
	-- int ateN = input()
	-- // Processa
	-- int  i  =  2
	-- for(; i <= ateN; i++){
	-- 	std_logic_vector notPrimo = ‘0’
	-- 	int divisor = 2;
	-- 	for(; divisor < i; divisor++){    
	-- 		dividendo <=  i
	-- 		while (dividendo >= divisor){
	-- 			dividendo -= divisor
	-- 		}
	-- 		if(dividendo == 0){  
	-- 			notPrimo = ‘1’
	-- 			break
	-- 		}
	-- 	}
	-- 	vetor[i] = notPrimo
	-- }
	-- // Apresenta saídas
	-- i = 2
	-- for(; i <= ateN;  i++) {
	--		vetorI = vetor[i](0)
	-- 	if(not vetorI){
	-- 		output(i)
	-- 	}
	-- }
-- Fim do algoritmo

--VARIAVEIS:
	-- int ateN
	-- int  i
	-- int divisor
	-- int dividendo
	-- std_logic notPrimo

-- OPERACOES e COMANDOS/STATUS EQUIVALENTES (==>)  , ordenado por variavel tipo do sinal (comando ou status) e depois por variavel
--		COMANDOS:
-- 	ateN = input()  						 ==> cmdSetAteN;
-- 	i  =  2  								 ==> cmdSetI; cmdSelectI = ‘0’;
--		i++  										 ==> cmdSetI; cmdSelectI = ‘1’;
-- 	notPrimo = ‘0’ 						 ==> cmdResetNotPrimo;
-- 	notPrimo = ‘1’ 						 ==> cmdSetNotPrimo;
-- 	divisor = 2	 							 ==> cmdSetDivisor; cmdSelectDivisor= ‘0’;
-- 	divisor++ 								 ==> cmdSetDivisor; cmdSelectDivisor= ‘1’;
-- 	dividendo = i 							 ==> cmdSetDividendo; cmdSelectDividendo = ‘0’;
-- 	dividendo =  dividendo - divisor  ==> cmdSetDividendo; cmdSelectDividendo = “1”;
-- 	vetor[i] = notPrimo					 ==> cmdSetVetorI;
-- 	Output = i                        ==> cmdSetOutput;

--		STATUS:
-- 	i <= ateN 				==> sttiMenorIgualAteN;
-- 	dividendo >= divisor ==> sttDividendoMaiorIgualDivisor;
-- 	divisor < i 			==> sttDivisorMenorI;
-- 	dividendo == 0 		==> sttDividendoIgualZero;
--    vetorI = vetor[i](0) ==> sttVetorI;

-- FSMD DO BLOCO DE CONTROLE a(a ser refinado apos projeto do Bloco Operativo)
	-- SL01:	// Início do algoritmo
	-- SL02:	Recebe entradas
	-- SL03:	int ateN = input()
	-- SL04:	// Processa
	-- SL05:	int  i  =  2 
	-- SL06:	for(; i <= ateN; i++){
	-- SL07:		std_logic_vector notPrimo = ‘0’
	-- SL08:		int divisor = 2;
	-- SL09:		for(; divisor < i; divisor++){
	-- SL10:			int dividendo <= i;
	-- SL11:			while(dividendo <= divisor){
	-- SL12:				dividendo = dividendo - divisor
	-- SL13:			}
	-- SL14:			if(dividendo == 0){  
	-- SL15:				notPrimo = ‘1’
	-- SL16:				break
	-- SL17:			}
	-- SL18:		}
	-- SL19:		vetor[i] = notPrimo
	-- SL20:	}
	-- SL21:	//Apresenta saídas
	-- SL22:	i = 2
	-- SL23:	for(; i <= ateN;  i++) {
	-- SL24: 	VetorI = vetor[i](0)
	-- SL25:		if(not sttVetor){
	-- SL26:			output(i)
	-- SL27:		}
	-- SL28:	}
	-- SL29:	Fim do algoritmo

-- BLOCO OPERATIVO - Circuitos COMBINACIONAIS para implementaçao das operaçoes 
--		Comparador Menor ou Igual :	i <= ateN    			==>     sttIMenorIgualAteN;
--		Comparador Menor: 				divisor < i  			==>  sttDivisorMenorI;
--		Comparador Maior ou igual: 	dividendo >= divisor ==> sttDividendoMaiorIgualDivisor
--		Comparador Igual: 				dividendo == 0 		==>  sttDividendoIgualZero;
--		Incrementador:  					i++  						==> cmdSetI;
--		Incrementador:  					divisor++  				==> cmdSetDivisor;
--		Subtrator: 							dividendo - divisor  ==>  cmdSetDividendo
--		Multiplexador: 					dividendo [0: i; 1: dividendo - divisor] ==> cmdSelectDividendo
--		Multiplexador: 					i = [ 0: 2; 1: i++] 							  ==> cmdSelectI
--		Multiplexador: 					divisor = [ 0: 2 ; 1: ii++]              ==> cmdSelectIi

-- BLOCO OPERATIVO - Circuitos SEQUENCIAIS para implementaçao das operaçoes 
-- 	Registrador (carga):    		  		ateN = input()   			==> cmdSetAteN
--		Registrador (reset):  			  		notPrimo = ‘0’ 			==> cmdResetNotPrimo
--		Registrador (reset):                output = '0'				== cmdResetOutput
--		Registrador (carga/resetdata): 	 	i = 2    					==> cmdSetI2
--		Registrador (carga/resetdata):  		divisor = 2    			==> cmdSetDivisor2
--		Registrador(carga/resetdata):   		dividendo =  i  			==> cmdSetDividendoI
--		MemoriaRAM
--	   	(write):   								vetor[i] = notPrimo   			  ==>  cmdSetVetorI
--			(read):   								vetorI = vetor[i](0)    		  ==>  sttVetorI

-- DIAGRAMA DE TRANSICAO DE ESTADOS DO BLOCO DE CONTROLE
	-- SL01:	Início do algoritmo                                   ----	SL03
	-- SL02: // Recebe entradas
	-- SL03: int ateN = input()                                    ----	input_read/SL03a
	-- SL03a:                                                      ----  SL05
	--	SL04: // Processa
	-- SL05: int  i  =  2                                          ----	SL06
	-- SL06: for(; i <= ateN: i++){          								----	sttIMenorIgualAteN/SL07; !sttIMenorIgualAteN/SL22
	-- SL07:     std_logic notPrimo = ‘0’                      		---- 	SL08
	-- SL08:     int divisor = 2;                                  ----	SL09
	-- SL09:     for(; divisor < i; divisor++){          				---- 	sttDivisorMenorI/SL10; !sttDivisorMenorI/SL19
	-- SL10:         int dividendo = i                         		----  SL11
	-- SL11:         while(dividendo >= divisor){						----	sttDividendoMaiorIgualDivisor/SL12 !sttDividendoMaiorIgualDivisor/SL14
	-- SL12:              dividendo = dividendo - divisor        	----  SL13
	-- SL13:         }    														----  SL11
	-- SL14:         if(dividendo == 0){									----  sttDividendoIgualZero/SL15; !sttDividendoIgualZero/SL18
	-- SL15:            notPrimo = ‘1’                        		----  SL16
	-- SL16:            break                                		----  SL19
	-- SL17:         }                                					----  SL18
	-- SL18:     }                                        			----  SL09
	-- SL19:     vetor[i] = notPrimo                           		----  SL20
	-- SL20: }                                            			----  SL06
	-- SL21: // Apresenta saídas
	-- SL22: i = 2                                        			----  SL23
	-- SL23: for(; i <= ateN;  i++) {	----  sttiMenorIgualAteN/SL24; !sttiMenorIgualAteN/SL29
	--	SL24:		(espera por memória RAM) 									----  SL24a
	-- SL24a: 	vetorI = vetor[i](0)                      			----  SL25
	-- SL25: 	if(not VetorI){                     					----	!sttVetorI/SL26; sttVetorI/SL27;
	-- SL26:       output(i)                       						----  output_read/SL26a
	-- SL26a:                                             			----  SL27
	-- SL27:     }     															----	SL28                                   
	-- SL28: }                                            			----  SL23
	-- SL29: Fim do algoritmo                                    	----  SL01

-- DIAGRAMA DE SAIDAS DO BLOCO DE CONTROLE
	-- SL01:	Início do algoritmo                                   ----	
	-- SL02: // Recebe entradas
	-- SL03: int ateN = input()                                    ----	interrupt
	-- SL03a:                                                      ----  cmdSetAten
	--	SL04: // Processa
	-- SL05: int  i  =  2                                          ----	cmdSetI; cmdSelectI = ‘0’;
	-- SL06: for(; i <= ateN: i++){          								----	
	-- SL07:     std_logic notPrimo = ‘0’                      		---- 	cmdResetNotPrimo;
	-- SL08:     int divisor = 2;                                  ----	cmdSetDivisor; cmdSelectDivisor= ‘0’;
	-- SL09:     for(; divisor < i; divisor++){          				---- 	
	-- SL10:         int dividendo = i                         		----  cmdSetDividendo; cmdSelectDividendo = ‘0’;
	-- SL11:         while(dividendo >= divisor){						----	
	-- SL12:              dividendo = dividendo - divisor        	----  cmdSetDividendo; cmdSelectDividendo = ‘1’;
	-- SL13:         }    														----  
	-- SL14:         if(dividendo == 0){									----  
	-- SL15:            notPrimo = ‘1’                        		----  cmdSetNotPrimo;
	-- SL16:            break                                		----  
	-- SL17:         }                                					----  
	-- SL18:     }                                        			----  cmdSetDivisor; cmdSelectDivisor= ‘1’;
	-- SL19:     vetor[i] = notPrimo                           		----  cmdSetVetorI
	-- SL20: }                                            			----  cmdSetI; cmdSelectI = ‘1’;
	-- SL21: // Apresenta saídas
	-- SL22: i = 2                                        			----  cmdSetI; cmdSelectI = ‘0’;
	-- SL23: for(; i <= ateN;  i++) {    									----  
	-- SL24:   	(espera por memória RAM)                      		----  
	--	SL24a:	vetorI = vetor[i](0) 										----	
	-- SL25:    if(not VetorI){                     					----  
	-- SL26:        output(i)                       					----  cmdSetOutput; interrupt
	-- SL26a:                                             			----  
	-- SL27:     }     															----	                               
	-- SL28: }                                            			----  cmdSetI; cmdSelectI = ‘1’;
	-- SL29: Fim do algoritmo                                    	----  
	
entity findPrimeNumbers is
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
end entity;


architecture structural of findPrimeNumbers is

component bloco_operativo_find_prime_numbers is
	generic(
		dataWidth: positive := 32;
		addressWidth: positive := 8
	);
	port (
		-- control inputs
		clk		: in std_logic;
		reset_req: in std_logic;
		-- data inputs
		writedata: IN STD_LOGIC_VECTOR (dataWidth-1 DOWNTO 0);
		-- data outputs
		readdata	: OUT STD_LOGIC_VECTOR (dataWidth-1 DOWNTO 0);
		-- commands from OperativeBlock
		cmdSetAteN, cmdSetI, cmdResetNotPrimo, cmdSetNotPrimo, cmdSetDivisor, cmdSetDividendo, 
		cmdSetVetorI, cmdSetOutput, cmdSelectI, cmdSelectDivisor, cmdSelectDividendo: in std_logic;
		-- status to OperativeBlock
		sttiMenorIgualAteN, sttDividendoMaiorIgualDivisor, sttDivisorMenorI, sttDividendoIgualZero, sttVetorI: out std_logic;
		testI, testDividendo, testDivisor, testAteN : out STD_LOGIC_VECTOR (dataWidth-1 DOWNTO 0);
		testNotPrimo : out STD_LOGIC
	);
end component;

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

signal cmdSetAteN, cmdSetI, cmdResetNotPrimo, cmdSetNotPrimo, cmdSetDivisor, cmdSetDividendo, 
		cmdSetVetorI, cmdSetOutput, cmdSelectI, cmdSelectDivisor, cmdSelectDividendo: std_logic;	
signal sttiMenorIgualAteN, sttDividendoMaiorIgualDivisor, sttDivisorMenorI, sttDividendoIgualZero, sttVetorI: std_logic;

signal testI, testDividendo, testDivisor, testAteN: STD_LOGIC_VECTOR (dataWidth-1 DOWNTO 0);

signal testNotPrimo: STD_LOGIC;


begin
	   BO: bloco_operativo_find_prime_numbers 
			generic map (dataWidth, addressWidth)
			port map (clk, reset_req, writedata, readdata, cmdSetAteN, cmdSetI, cmdResetNotPrimo, cmdSetNotPrimo, cmdSetDivisor, cmdSetDividendo, 
		cmdSetVetorI, cmdSetOutput, cmdSelectI, cmdSelectDivisor, cmdSelectDividendo, sttiMenorIgualAteN, sttDividendoMaiorIgualDivisor, sttDivisorMenorI, 
		sttDividendoIgualZero, sttVetorI, testI, testDividendo, testDivisor, testAteN, testNotPrimo);
		
		BC: bloco_controle_find_prime_numbers
		port map(clk, reset_req, chipselect, readd, writee, sttiMenorIgualAteN, sttDividendoMaiorIgualDivisor, sttDivisorMenorI, sttDividendoIgualZero, 
		sttVetorI, interrupt, cmdSetAteN, cmdSetI, cmdResetNotPrimo, cmdSetNotPrimo, cmdSetDivisor, cmdSetDividendo, 
		cmdSetVetorI, cmdSetOutput, cmdSelectI, cmdSelectDivisor, cmdSelectDividendo, testEstadoAtual );

				
end architecture;

	