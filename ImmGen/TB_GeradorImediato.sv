`timescale 1ns/1ps

module TB_GeradorImediato;

    logic clk;
    logic [31:0] pc;
    logic [31:0] instruction;
    logic [6:0] Opcode;
    logic [4:0] Reg1;
    logic [4:0] Reg2;
    logic [4:0] RegD;
    logic [2:0] funct3;
    logic funct7;

    logic [31:0] Imediato;

    Memoria_Intrucoes tb(
        .pc(pc),
        .instruction(instruction),
        .Opcode(Opcode),
        .Rs1(Reg1),
        .Rs2(Reg2),
        .RsD(RegD),
        .funct3(funct3),
        .funct7(funct7)
    );

    GeradorImediato TBGERADORIMEDIATO(
        .Instrucao(instruction),
        .Imediato(Imediato)
    );

    // Geração do clock
    initial begin
        clk = 0;
        pc = 0;
        forever #5 clk = ~clk; // alterna clk a cada 5ns
    end

    // Apenas para simulação: mostra o valor do clock ao longo do tempo
    always_ff @(posedge clk)begin
        $display("Tempo: %d ", $time);
        $display("PC %d |Opcode: %b |Instrucao[31:0]: %b",pc,Opcode,instruction);
        $display("Imediato: %d\n",Imediato);
        pc = pc + 4;
        if (pc > 52) begin
            $finish;
        end
    end
endmodule

//Compilar e rodar:
// mingw32-make Teste_ImmGen