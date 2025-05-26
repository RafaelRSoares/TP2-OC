Teste_Intrucoes:
	iverilog -g2012 -I TP2_OC -o executavel.vvp Instructions_Memory/Memoria_de_Instrucoes.sv Instructions_Memory\TB_Memoria_de_Instrucoes.sv && vvp executavel.vvp

Teste_Registradores:
	iverilog -g2012 -I TP2_OC -o executavel.vvp Instructions_Memory/Memoria_de_Instrucoes.sv Register\Registradores.sv Register\TB_registradores.sv && vvp executavel.vvp

Teste_Controle:
	iverilog -g2012 -I TP2_OC -o executavel.vvp Instructions_Memory/Memoria_de_Instrucoes.sv Register\Registradores.sv Control\Controle.sv Control\tb_Controle.sv && vvp executavel.vvp

Teste_controladorALU:
	iverilog -g2012 -I TP2_OC -o executavel.vvp Instructions_Memory/Memoria_de_Instrucoes.sv Register\Registradores.sv Control\Controle.sv ALU\controladorALU.sv ALU\TB_controladorALU.sv && vvp executavel.vvp

Teste_ALU:
	iverilog -g2012 -I TP2_OC -o executavel.vvp Instructions_Memory/Memoria_de_Instrucoes.sv Register\Registradores.sv Control\Controle.sv ALU\controladorALU.sv ALU\ALU.sv ALU\tb_ALU.sv && vvp executavel.vvp
