Teste_Final:
	iverilog -g2012 -I TP2_OC -o executavel.vvp Caminho_de_Dados/CaminhoFinal.sv && vvp executavel.vvp

Teste_Caminho_de_Dados:
	iverilog -g2012 -I TP2_OC -o executavel.vvp Instructions_Memory/Memoria_de_Instrucoes.sv ImmGen\GeradorImediato.sv Register\Registradores.sv Control\Controle.sv ALU\MuxALU\MuxALU.sv ALU\ALU_Control\controladorALU.sv ALU\ALU.sv Data_Memory\Memoria.sv Data_Memory\MuxDataMemory\MuxDataMemory.sv PC\PC.sv Caminho_de_Dados\caminhoDeDados.sv Caminho_de_Dados\Display.sv && vvp executavel.vvp


iverilog -o sim teshbach cont   vvp sim gtkwave dump.vcd