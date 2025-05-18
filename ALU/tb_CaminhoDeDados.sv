`timescale 1ns/1ps

module tb_CaminhoDeDados;

    // Sinais de clock e reset
    logic clk;
    logic reset;

    // Instanciação do módulo a ser testado
    CaminhoDeDados uut (
        .clk(clk),
        .reset(reset)
    );

    // Geração de clock (período de 10ns)
    always #5 clk = ~clk;

    initial begin
        // Inicialização
        $display("=== Teste do Caminho de Dados ===");
        clk = 0;
        reset = 1;

        #10;
        reset = 0;

        #10;
        $display("Instrução simulada: SUB x5, x1, x2");
        $display("rs1 = x1 => valor esperado: 10");
        $display("rs2 = x2 => valor esperado: 5");
        $display("Resultado ALU = %0d", uut.resultado_alu);
        $display("Eh_zero = %0d", uut.eh_zero);

        #10;
        $finish;
    end

endmodule
