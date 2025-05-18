`timescale 1ns/1ps

module tb_ALU;

    // Sinais para conectar à ALU
    logic [31:0] entrada1;
    logic [31:0] entrada2;
    logic [3:0]  controle_alu;
    logic [31:0] resultado;
    logic        eh_zero;

    // Instanciando a ALU
    ALU uut (
        .entrada1(entrada1),
        .entrada2(entrada2),
        .controle_alu(controle_alu),
        .resultado(resultado),
        .eh_zero(eh_zero)
    );

    // Procedimento de teste
    initial begin
        $display("\n==== Início dos Testes da ALU ====\n");

        // Teste 1: ADD
        entrada1 = 32'd10;
        entrada2 = 32'd20;
        controle_alu = 4'b0000; // add
        #1; // espera 1 unidade de tempo
        $display("ADD: %0d + %0d = %0d | eh_zero = %b", entrada1, entrada2, resultado, eh_zero);

        // Teste 2: SUB (resultado diferente de zero)
        entrada1 = 32'd30;
        entrada2 = 32'd10;
        controle_alu = 4'b0001; // sub
        #1;
        $display("SUB: %0d - %0d = %0d | eh_zero = %b", entrada1, entrada2, resultado, eh_zero);

        // Teste 3: SUB (resultado zero)
        entrada1 = 32'd50;
        entrada2 = 32'd50;
        controle_alu = 4'b0001; // sub
        #1;
        $display("SUB-ZERO: %0d - %0d = %0d | eh_zero = %b", entrada1, entrada2, resultado, eh_zero);

        // Teste 4: AND
        entrada1 = 32'b1100;
        entrada2 = 32'b1010;
        controle_alu = 4'b0010; // and
        #1;
        $display("AND: %b & %b = %b | eh_zero = %b", entrada1, entrada2, resultado, eh_zero);

        // Teste 5: OR
        entrada1 = 32'b1100;
        entrada2 = 32'b1010;
        controle_alu = 4'b0011; // or
        #1;
        $display("OR: %b | %b = %b | eh_zero = %b", entrada1, entrada2, resultado, eh_zero);

        // Teste 6: SRL
        entrada1 = 32'b10000000000000000000000000000000; // bit alto na esquerda
        entrada2 = 32'd2; // desloca 2 bits à direita
        controle_alu = 4'b0100; // srl
        #1;
        $display("SRL: %b >> %0d = %b | eh_zero = %b", entrada1, entrada2[4:0], resultado, eh_zero);

        // Teste 7: Operação inválida
        entrada1 = 32'd0;
        entrada2 = 32'd0;
        controle_alu = 4'b1111;
        #1;
        $display("INVÁLIDO: controle_alu = %b | resultado = %h | eh_zero = %b", controle_alu, resultado, eh_zero);

        $display("\n==== Fim dos Testes da ALU ====\n");
        $finish; // encerra simulação
    end

endmodule
