library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity testbench_BO is
	generic(	
		latencia: time := 1 ns;
		dataWidth: positive := 4;
		addressWidth: positive := 4
	);
end entity;

architecture arch of testbench_BO is

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
		testI, testDividendo, testDivisor, testAteN: out STD_LOGIC_VECTOR (dataWidth-1 DOWNTO 0);
		testNotPrimo : out STD_LOGIC
	);
end component;

signal clk, reset_req: std_logic;
signal sttiMenorIgualAteN, sttDividendoMaiorIgualDivisor, sttDivisorMenorI, sttDividendoIgualZero, sttVetorI:  std_logic;
signal cmdSetAteN, cmdSetI, cmdResetNotPrimo, cmdSetNotPrimo, cmdSetDivisor, cmdSetDividendo, cmdSetVetorI, cmdSetOutput, cmdSelectI, cmdSelectDivisor, cmdSelectDividendo: std_logic;
signal writedata, readdata, testI, testDividendo, testDivisor, testAteN: STD_LOGIC_VECTOR (dataWidth-1 DOWNTO 0);
signal testNotPrimo: std_logic;

begin
		utt: bloco_operativo_find_prime_numbers
		generic map (dataWidth, addressWidth)
		port map (clk, reset_req, writedata, readdata, cmdSetAteN, cmdSetI, cmdResetNotPrimo, cmdSetNotPrimo, cmdSetDivisor, cmdSetDividendo, 
		cmdSetVetorI, cmdSetOutput, cmdSelectI, cmdSelectDivisor, cmdSelectDividendo, sttiMenorIgualAteN, sttDividendoMaiorIgualDivisor, 
		sttDivisorMenorI, sttDividendoIgualZero, sttVetorI, testI, testDividendo, testDivisor, testAteN, testNotPrimo
		);
		
setClock: process is
begin
	clk <= '0';
	wait for latencia*2;
	clk <= '1';
	wait for latencia*2;
end process;
			
stimulus: process
		begin	
			writedata <= "1110";
			cmdSetAten <= '1';
			cmdSetI <= '0';
			cmdResetNotPrimo <= '0';
			cmdSetDivisor <= '0';
			cmdSetDividendo <= '0';
			cmdSetNotPrimo <= '0';
			cmdSetVetorI <= '0';
			cmdSetOutput <= '0';
			wait for latencia*4;
			cmdSelectI <= '0';
			cmdSetAten <= '0';
			cmdSetI <= '1';
			cmdResetNotPrimo <= '0';
			cmdSetDivisor <= '0';
			cmdSetDividendo <= '0';
			cmdSetNotPrimo <= '0';
			cmdSetVetorI <= '0';
			cmdSetOutput <= '0';
			wait for latencia*4;
			while (sttiMenorIgualAteN = '1') loop  
					cmdSetAten <= '0';
					cmdSetI <= '0';
					cmdResetNotPrimo <= '1';
					cmdSetDivisor <= '0';
					cmdSetDividendo <= '0';
					cmdSetNotPrimo <= '0';
					cmdSetVetorI <= '0';
					cmdSetOutput <= '0';
					wait for latencia*4;
					cmdSelectDivisor <= '0';
					cmdSetAten <= '0';
					cmdSetI <= '0';
					cmdResetNotPrimo <= '0';
					cmdSetDivisor <= '1';
					cmdSetDividendo <= '0';
					cmdSetNotPrimo <= '0';
					cmdSetVetorI <= '0';
					cmdSetOutput <= '0';
					wait for latencia*4;
					while (sttDivisorMenorI = '1') loop
							cmdSelectDividendo <= '0';
							cmdSetAten <= '0';
							cmdSetI <= '0';
							cmdResetNotPrimo <= '0';
							cmdSetDivisor <= '0';
							cmdSetDividendo <= '1';
							cmdSetNotPrimo <= '0';
							cmdSetVetorI <= '0';
							cmdSetOutput <= '0';
							wait for latencia*4;
							while (sttDividendoMaiorIgualDivisor = '1') loop
								cmdSelectDividendo <= '1';
								cmdSetAten <= '0';
								cmdSetI <= '0';
								cmdResetNotPrimo <= '0';
								cmdSetDivisor <= '0';
								cmdSetDividendo <= '1';
								cmdSetNotPrimo <= '0';
								cmdSetVetorI <= '0';
								cmdSetOutput <= '0';
								wait for latencia*4;
							end loop;
							if (sttDividendoIgualZero = '1') then
								cmdSetAten <= '0';
								cmdSetI <= '0';
								cmdResetNotPrimo <= '0';
								cmdSetDivisor <= '0';
								cmdSetDividendo <= '0';
								cmdSetNotPrimo <= '1';
								cmdSetVetorI <= '0';
								cmdSetOutput <= '0';
								wait for latencia*4;
								exit;
							end if;
							cmdSelectDivisor <= '1';
							cmdSetAten <= '0';
							cmdSetI <= '0';
							cmdResetNotPrimo <= '0';
							cmdSetDivisor <= '1';
							cmdSetDividendo <= '0';
							cmdSetNotPrimo <= '0';
							cmdSetVetorI <= '0';
							cmdSetOutput <= '0';
							wait for latencia*4;
					end loop;
					cmdSetAten <= '0';
					cmdSetI <= '0';
					cmdResetNotPrimo <= '0';
					cmdSetDivisor <= '0';
					cmdSetDividendo <= '0';
					cmdSetNotPrimo <= '0';
					cmdSetVetorI <= '1';
					cmdSetOutput <= '0';
					wait for latencia*4;
					cmdSelectI <= '1';
					cmdSetAten <= '0';
					cmdSetI <= '1';
					cmdResetNotPrimo <= '0';
					cmdSetDivisor <= '0';
					cmdSetDividendo <= '0';
					cmdSetNotPrimo <= '0';
					cmdSetVetorI <= '0';
					cmdSetOutput <= '0';
					wait for latencia*4;		
			end loop;
			cmdSelectI <= '0';
			cmdSetAten <= '0';
			cmdSetI <= '1';
			cmdResetNotPrimo <= '0';
			cmdSetDivisor <= '0';
			cmdSetDividendo <= '0';
			cmdSetNotPrimo <= '0';
			cmdSetVetorI <= '0';
			cmdSetOutput <= '0';
			wait for latencia*4;
			while (sttiMenorIgualAteN = '1') loop	
					cmdSetAten <= '0';
					cmdSetI <= '0';
					cmdResetNotPrimo <= '0';
					cmdSetDivisor <= '0';
					cmdSetDividendo <= '0';
					cmdSetNotPrimo <= '0';
					cmdSetVetorI <= '0';
					cmdSetOutput <= '0';
					wait for latencia*4;
					if(sttVetorI = '0') then
						cmdSetAten <= '0';
						cmdSetI <= '0';
						cmdResetNotPrimo <= '0';
						cmdSetDivisor <= '0';
						cmdSetDividendo <= '0';
						cmdSetNotPrimo <= '0';
						cmdSetVetorI <= '0';
						cmdSetOutput <= '1';
					end if;
					wait for latencia*4;					
					cmdSelectI <= '1';
					cmdSetAten <= '0';
					cmdSetI <= '1';
					cmdResetNotPrimo <= '0';
					cmdSetDivisor <= '0';
					cmdSetDividendo <= '0';
					cmdSetNotPrimo <= '0';
					cmdSetVetorI <= '0';
					cmdSetOutput <= '0';
					wait for latencia*4;
			end loop;
			cmdSetAten <= '0';          
			cmdSetI <= '0';
			cmdResetNotPrimo <= '0';
			cmdSetDivisor <= '0';
			cmdSetDividendo <= '0';
			cmdSetNotPrimo <= '0';
			cmdSetVetorI <= '0';
			cmdSetOutput <= '0';
			wait for latencia*4;
			wait;
	end process;
end architecture;