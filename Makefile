Teste_Intrucoes:
	iverilog -g2012 -I TP2_OC -o executavel.vvp Instructions_Memory/Memoria_de_Instrucoes.sv Instructions_Memory\TB_Memoria_de_Instrucoes.sv && vvp executavel.vvp

Teste_ImmGen:
	iverilog -g2012 -I TP2_OC -o executavel.vvp Instructions_Memory/Memoria_de_Instrucoes.sv ImmGen\GeradorImediato.sv ImmGen\TB_GeradorImediato.sv && vvp executavel.vvp

Teste_Registradores:
	iverilog -g2012 -I TP2_OC -o executavel.vvp Instructions_Memory/Memoria_de_Instrucoes.sv Register\Registradores.sv Register\TB_registradores.sv && vvp executavel.vvp

Teste_Controle:
	iverilog -g2012 -I TP2_OC -o executavel.vvp Instructions_Memory/Memoria_de_Instrucoes.sv Register\Registradores.sv Control\Controle.sv Control\tb_Controle.sv && vvp executavel.vvp

Teste_controladorALU:
	iverilog -g2012 -I TP2_OC -o executavel.vvp Instructions_Memory/Memoria_de_Instrucoes.sv Register\Registradores.sv Control\Controle.sv ALU\ALU_Control\controladorALU.sv ALU\ALU_Control\TB_controladorALU.sv && vvp executavel.vvp

Teste_ALU:
	iverilog -g2012 -I TP2_OC -o executavel.vvp Instructions_Memory/Memoria_de_Instrucoes.sv ImmGen\GeradorImediato.sv Register\Registradores.sv Control\Controle.sv ALU\MuxALU\MuxALU.sv ALU\ALU_Control\controladorALU.sv ALU\ALU.sv ALU\tb_ALU.sv && vvp executavel.vvp

Teste_Mux:
	iverilog -g2012 -I TP2_OC -o executavel.vvp Instructions_Memory/Memoria_de_Instrucoes.sv Register\Registradores.sv Control\Controle.sv ALU\MuxALU\MuxALU.sv ALU\MuxALU\TB_MuxALU.sv && vvp executavel.vvp

Teste_Data_Memory:
	iverilog -g2012 -I TP2_OC -o executavel.vvp Instructions_Memory/Memoria_de_Instrucoes.sv ImmGen\GeradorImediato.sv Register\Registradores.sv Control\Controle.sv ALU\MuxALU\MuxALU.sv ALU\ALU_Control\controladorALU.sv ALU\ALU.sv Data_Memory\Memoria.sv Data_Memory\TB_Memoria.sv && vvp executavel.vvp

Teste_Mux_Data_Memory:
	iverilog -g2012 -I TP2_OC -o executavel.vvp Instructions_Memory/Memoria_de_Instrucoes.sv ImmGen\GeradorImediato.sv Register\Registradores.sv Control\Controle.sv ALU\MuxALU\MuxALU.sv ALU\ALU_Control\controladorALU.sv ALU\ALU.sv Data_Memory\Memoria.sv Data_Memory\MuxDataMemory\MuxDataMemory.sv Data_Memory\MuxDataMemory\TB_MuxDataMemory.sv && vvp executavel.vvp

Teste_PC:
	iverilog -g2012 -I TP2_OC -o executavel.vvp PC\PC.sv PC\TB_PC.sv && vvp executavel.vvp

Teste_Caminho_de_Dados:
	iverilog -g2012 -I TP2_OC -o executavel.vvp Instructions_Memory/Memoria_de_Instrucoes.sv ImmGen\GeradorImediato.sv Register\Registradores.sv Control\Controle.sv ALU\MuxALU\MuxALU.sv ALU\ALU_Control\controladorALU.sv ALU\ALU.sv Data_Memory\Memoria.sv Data_Memory\MuxDataMemory\MuxDataMemory.sv PC\PC.sv Caminho_de_Dados\CaminhoDeDados.sv Caminho_de_Dados\tb_CaminhoDeDados.sv && vvp executavel.vvp
