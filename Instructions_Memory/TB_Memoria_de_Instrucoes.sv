`timescale 1ns/1ps

module TB_Memoria_Intrucoes;

    logic clk;
    logic [31:0] pc;
    logic [31:0] instruction;
    logic [6:0] Opcode;
    logic [4:0] Reg1;
    logic [4:0] Reg2;
    logic [4:0] RegD;

    Memoria_Intrucoes tb(
        .pc(pc),
        .instruction(instruction),
        .Opcode(Opcode),
        .Rs1(Reg1),
        .Rs2(Reg2),
        .RsD(RegD)
    );

    // Geração do clock
    initial begin
        clk = 0;
        pc = 0;
        forever #5 clk = ~clk; // alterna clk a cada 5ns
    end

    // Apenas para simulação: mostra o valor do clock ao longo do tempo
    always_ff @(posedge clk)begin
        $display("Tempo: %d ", $time, clk);
        $display("PC %d |Opcode: %b |Instrucao[31:0]: %b",pc,Opcode,instruction);
        $display("Opcode[6:0]: %b|Rs1: %b|Rs2: %b|RD: %b\n",Opcode,Reg1,Reg2,RegD);
        pc = pc + 4;
        if (pc > 24) begin
            $finish;
        end
    end
endmodule

// Para compilar e rodar
//mingw32-make Teste_Intrucoes