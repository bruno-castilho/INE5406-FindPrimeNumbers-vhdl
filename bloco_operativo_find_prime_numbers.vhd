library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bloco_operativo_find_prime_numbers is
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
end entity;

architecture structuralDatapath of bloco_operativo_find_prime_numbers is

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

component incrementador is
	generic(
		width: positive := 8;
		isSigned: boolean := true
	);
	port(
		inp: in std_logic_vector(width-1 downto 0);
		outp: out std_logic_vector(width-1 downto 0)
	);
end component;

component comparadorMenor is
	generic(
		width: positive := 8;
		isSigned: boolean := true
	);
	port(
		inp0, inp1: in std_logic_vector(width-1 downto 0);
		output: out std_logic
	);
end component;

component comparadorIgual is
	generic(
		width: positive := 8;
		isSigned: boolean := true
	);
	port(
		inp0, inp1: in std_logic_vector(width-1 downto 0);
		output: out std_logic
	);
end component;

component comparadorMenorIgual is
	generic(
		width: positive := 8;
		isSigned: boolean := true
	);
	port(
		inp0, inp1: in std_logic_vector(width-1 downto 0);
		output: out std_logic
	);
end component;

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

component comparadorMaiorIgual is
	generic(
		width: positive := 8;
		isSigned: boolean := true
	);
	port(
		inp0, inp1: in std_logic_vector(width-1 downto 0);
		output: out std_logic
	);
end component;

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

component memoriaRAM IS
	generic(
		dataWidth: positive := 8;
		addressWidth: positive := 8
	);
	PORT(
		address		: IN STD_LOGIC_VECTOR (addressWidth-1 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (dataWidth-1 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (dataWidth-1 DOWNTO 0)
	);
END component;


signal regAteN_out, incI_out, muxI_out, regI_out, incDivisor_out, muxDivisor_out, regDivisor_out, subDividendo_out,
muxDividendo_out, regDividendo_out: std_logic_vector(dataWidth-1 downto 0);
signal NotPrimo_out, NotPrimo_in: std_logic_vector(0 downto 0);
begin
-- OPERACOES e COMANDOS/STATUS EQUIVALENTES (==>)  , ordenado por variavel tipo do sinal (comando ou status) e depois por variavel
--		COMANDOS:
-- 	ateN = input()  						 ==> cmdSetAteN;	
	   RegAteN: registrador 
			generic map (dataWidth)
			port map (clk=>clk, reset=>reset_req, load=>cmdSetAteN, datain=>writedata, dataout=>regAteN_out);
			testAteN <= regAteN_out;
			
-- 	i  =  2  								 ==> cmdSetI; cmdSelectI = ‘0’;
--		i++  										 ==> cmdSetI; cmdSelectI = ‘1’;
		
		IncI:  incrementador
			generic map (dataWidth, true)
			port map (regI_out, incI_out);
				
		MuxI: multiplexador2
			generic map (dataWidth)
			port map (inp0=> std_logic_vector(to_unsigned(2, dataWidth)), inp1=>incI_out, sel=>cmdSelectI, outp=>muxI_out);
			
		RegI: registrador 
			generic map (dataWidth)
			port map (clk=>clk, reset=>reset_req, load=>cmdSetI, datain=>muxI_out, dataout=>regI_out);
		
		testI <= regI_out;
		
-- 	notPrimo = ‘0’ 						 ==> cmdResetNotPrimo;
-- 	notPrimo = ‘1’ 						 ==> cmdSetNotPrimo;
		NotPrimo_in(0) <= '1';
	   RegNotPrimo: registrador
			generic map (1)
			port map (clk=>clk, reset=>cmdResetNotPrimo, load=>cmdSetNotPrimo, datain=>NotPrimo_in, dataout => NotPrimo_out);

-- 	divisor = 2	 							 ==> cmdSetDivisor; cmdSelectDivisor= ‘0’;
-- 	divisor++ 								 ==> cmdSetDivisor; cmdSelectDivisor= ‘1’;
		testNotPrimo <= NotPrimo_out(0);

		IncDivisor:  incrementador
			generic map (dataWidth, true)
			port map (regDivisor_out, incDivisor_out);
		
		MuxDivisor: multiplexador2
			generic map (dataWidth)
			port map (inp0=> std_logic_vector(to_unsigned(2, dataWidth)), inp1=>incDivisor_out, sel=>cmdSelectDivisor, outp=>muxDivisor_out);
			
		RegDivisor: registrador 
			generic map (dataWidth)
			port map (clk=>clk, reset=>reset_req, load=>cmdSetDivisor, datain=>muxDivisor_out, dataout=>regDivisor_out);
		
		testDivisor <= regDivisor_out;

-- 	dividendo = i 							 ==> cmdSetDividendo; cmdSelectDividendo = ‘0’;
-- 	dividendo =  dividendo - divisor  ==> cmdSetDividendo; cmdSelectDividendo = “1”;

		SubDividendo:  subtrator
			generic map (dataWidth, false)
			port map (inpA=> regDividendo_out,inpB =>regDivisor_out, outp => subDividendo_out);
		
		MuxDividendo: multiplexador2
			generic map (dataWidth)
			port map (inp0=>regI_out, inp1=>subDividendo_out, sel=>cmdSelectDividendo, outp=>muxDividendo_out);
			
		RegDividendo: registrador 
			generic map (dataWidth)
			port map (clk=>clk, reset=>reset_req, load=>cmdSetDividendo, datain=>muxDividendo_out, dataout=>regDividendo_out);
		
		testDividendo <= regDividendo_out;


-- 	vetor[i] = notPrimo	==> cmdSetVetorI;
--		vetorI = vetor[i](0) ==> sttVetorI;
		RAM: memoriaRam 
			generic map (1, addressWidth)
			port map(address=>regI_out(addressWidth-1 downto 0), clock=>clk, data=>NotPrimo_out, wren=>cmdSetVetorI, q(0)=>sttVetorI);

--		STATUS:
-- 	i <= ateN 				==> sttiMenorIgualAteN;

		CompIAten: comparadorMenorIgual
			generic map (dataWidth, false) 
			port map (regI_Out, regAteN_Out, sttiMenorIgualAteN);		
-- 	dividendo >= divisor ==> sttDividendoMaiorIgualDivisor;

		CompDividendoDivisor: comparadorMaiorIgual
			generic map (dataWidth, false) 
			port map (regDividendo_out, regDivisor_out, sttDividendoMaiorIgualDivisor);
-- 	divisor < i 			==> sttDivisorMenorI;
		CompDivisorI: comparadorMenor
			generic map (dataWidth, false) 
			port map (regDivisor_out, regI_Out, sttDivisorMenorI);
-- 	dividendo == 0 		==> sttDividendoIgualZero;
		CompDivisorIgualI: comparadorIgual
			generic map (dataWidth, false) 
			port map (regDividendo_out, std_logic_vector(to_unsigned(0, dataWidth)), sttDividendoIgualZero);
			
-- 	Output = i                        ==> cmdOutput;	
		RegOutput: registrador 
			generic map (dataWidth)
			port map (clk=>clk, reset=>reset_req, load=>cmdSetOutput, datain=>regI_out, dataout=>readdata);
			
end architecture;
			
			