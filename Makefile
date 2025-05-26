Teste_Intrucoes:
	iverilog -g2012 -I TP2_OC -o executavel.vvp Instructions_Memory/Memoria_de_Instrucoes.sv Instructions_Memory\TB_Memoria_de_Instrucoes.sv && vvp executavel.vvp

Teste_Registradores:
	iverilog -g2012 -I TP2_OC -o executavel.vvp Instructions_Memory/Memoria_de_Instrucoes.sv Register\Registradores.sv Register\TB_registradores.sv && vvp executavel.vvp
