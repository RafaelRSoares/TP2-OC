`timescale 1ns/1ps

module TB_registradores;
    
    logic clk;
    logic RegWrite;
    logic [31:0] pc;
    logic [31:0] instruction;
    logic [6:0] Opcode;
    logic [4:0] Rs1;
    logic [4:0] Rs2;
    logic [4:0] RsD;
    logic [2:0] funct3;
    logic funct7;

    logic [31:0] WriteData;
    logic [31:0] data1;
    logic [31:0] data2;

    Memoria_Intrucoes TBMEMORIA(
        .pc(pc),
        .instruction(instruction),
        .Opcode(Opcode),
        .Rs1(Rs1),
        .Rs2(Rs2),
        .RsD(RsD),
        .funct3(funct3),
        .funct7(funct7)
    );

    Moduloregistradores TBREGISTRADOR(
        .clk(clk),
        .RegWrite(RegWrite),
        .Rs1(Rs1),
        .Rs2(Rs2),
        .RsD(RsD),
        .WriteData(WriteData),
        .Data1(data1),
        .Data2(data2)
     );

    // Geração do clock
    initial begin
        clk = 0;
        pc = 0;
        RegWrite = 0;
        WriteData = 32'd153;
        forever #5 clk = ~clk; // alterna clk a cada 5ns
    end

    // Apenas para simulação: mostra o valor do clock ao longo do tempo
    always_ff @(posedge clk)begin
        $display("Tempo: %d ", $time);
        $display("PC %d |Opcode: %b |Instrucao[31:0]: %b",pc,Opcode,instruction);
        $display("Rs1: %b|Rs2: %b|RD: %b |WriteData %d",Rs1,Rs2,RsD,WriteData);
        $display("Data1: %d |Data2: %d\n",data1,data2);
        pc = pc + 4;
        if (pc > 24) begin
            $finish;
        end
    end

endmodule

//Para compilar e rodar
//mingw32-make Teste_Registradores