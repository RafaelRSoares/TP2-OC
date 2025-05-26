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
        .Reg1(Reg1),
        .Reg2(Reg2),
        .RegD(RegD)
    );

    // Geração do clock
    initial begin
        clk = 0;
        pc = 0;
        forever #5 clk = ~clk; // alterna clk a cada 5ns
    end

    // Apenas para simulação: mostra o valor do clock ao longo do tempo
    always_ff @(posedge clk)begin
        $display("Tempo: %d | clk = %b", $time, clk);
        $display("PC %d",pc);
        $display("Intrucao: %b",instruction);
        $display("Opcode[6:0]: %b",Opcode);
        $display("Rs1[19:15]: %b",Reg1);
        $display("Rs2[24:24]: %b",Reg2);
        $display("RD[11:7]: %b",RegD);
        pc = pc + 4;
        if (pc > 24) begin
            $finish;
        end
    end
endmodule

//Para compilar:
//iverilog -g2012 -o executavel.vvp Instructions_Memory/Memoria_de_Instrucoes.sv Instructions_Memory/TB_Memoria_de_Instrucoes.sv 
//vvp executavel.vvp