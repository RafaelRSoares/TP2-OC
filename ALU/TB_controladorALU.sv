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

    logic Branch;
    logic MemRead;
    logic MemtoReg;
    logic [1:0] ALUOp;
    logic MemWrite;
    logic ALUSrc;

    logic [3:0] controle_alu;
    
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

     Controle TBCONTROLE(
        .opcode(Opcode),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .MempraReg(MemtoReg),
        .Branch(Branch),
        .ALUOp(ALUOp)
     );

     controle_alu TBCONTORLE_ALU(
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7b5(funct7),
        .controle_alu(controle_alu)
     );

    // Geração do clock
    initial begin
        clk = 0;
        pc = 0;
        WriteData = 32'd999;
        forever #5 clk = ~clk; // alterna clk a cada 5ns
    end

    // Apenas para simulação: mostra o valor do clock ao longo do tempo
    always_ff @(posedge clk)begin
        $display("Tempo: %d ", $time);
        $display("PC %d |ALUOp: %b |funct3: %b |funct7: %b",pc,ALUOp,funct3,funct7);
        $display("controle_alu: %b\n",controle_alu);
        pc = pc + 4;
        if (pc > 24) begin
            $finish;
        end
    end

endmodule

//Para compilar e rodar
//mingw32-make Teste_Controle