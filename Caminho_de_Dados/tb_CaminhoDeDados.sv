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

    logic [31:0] WriteDataReg;
    logic [31:0] data1;
    logic [31:0] data2;

    logic Branch;
    logic MemRead;
    logic MemtoReg;
    logic [1:0] ALUOp;
    logic MemWrite;
    logic ALUSrc;

    logic [31:0] SaidaMuxALU;
    logic [31:0] Imediato;

    logic [3:0] controle_alu;

    logic [31:0] resultado;
    logic eh_zero;

    logic [31:0] ReadData;
    
    logic [31:0] PcProximo;

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
        .WriteData(WriteDataReg),
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

     GeradorImediato TBGERADORIMEDIATO(
        .Instrucao(instruction),
        .Imediato(Imediato)
    );

    MuxALU TBMUXALU(
        .ALUSrc(ALUSrc),
        .entrada2(data2),
        .Imediato(Imediato),
        .SaidaMuxALU(SaidaMuxALU)
    );

    controle_alu TBCONTORLE_ALU(
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7b5(funct7),
        .controle_alu(controle_alu)
     );

    ALU TBALU(
        .entrada1(data1),
        .entrada2(SaidaMuxALU),
        .controle_alu(controle_alu),
        .resultado(resultado),
        .eh_zero(eh_zero)
    );

    Memoria TBDATAMEMORY(
        .clk(clk),
        .Endereco(resultado),
        .WriteData(data2),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .ReadData(ReadData)
    );

    MuxDataMemory MUXDATAMEMORY(
        .clk(clk),
        .MemtoReg(MemtoReg),
        .ReadData(ReadData),
        .ResultadoALU(resultado),
        .WriteData(WriteDataReg)
    );

    Pc_modulo TBPCModulo(
        .PcAnterior(pc),
        .Imediato(Imediato),
        .Branch(Branch),
        .eh_zero(eh_zero),
        .PcProximo(PcProximo)
    );

    // Geração do clock
    initial begin
        clk = 0;
        pc = 0;
        forever #5 clk = ~clk; // alterna clk a cada 5ns
    end

    // Apenas para simulação: mostra o valor do clock ao longo do tempo
    always_ff @(posedge clk)begin
        $display("========================================================================");
        $display("Memoria de Intrucao:");
        $display("Tempo: %d |PC: %d", $time,pc);
        $display("Instrucao: %b |Opcode: %b |Rs1: %d |Rs2: %d",instruction,Opcode,Rs1,Rs2);
        $display("RD: %d |Funct3: %b |Funct7: %b\n",RsD,funct3,funct7);

        $display("Controle:");
        $display("Branch %d |MemRead: %d |MemtoReg: %d |ALUOp: %b",Branch,MemRead,MemtoReg,ALUOp);
        $display("MemWrite: %d |AlUSrc: %d |RegWrite %d\n",MemWrite,ALUSrc,RegWrite);

        $display("Registradores:");
        $display("Write Data: %d |DataRs1 %d |DataRs2: %d\n",WriteDataReg,data1,data2);

        $display("Gerador Imediato: %d",Imediato);
        $display("Instrucao: %b",instruction);
        $display("Saida Mux ALU %d",SaidaMuxALU);
        $display("ALU control: %d\n",controle_alu);

        $display("ALU:");
        $display("Resultado ALU: %d |Eh_zero :%d\n",resultado,eh_zero);

        $display("Data Memory:");
        $display("Endereco/Entrada: %d |WriteData/Data2: %b",resultado,data2);
        $display("ReadData/SaidaMemory: %b\n",ReadData);

        $display("Mux Data Memory:");
        $display("0-ResultadoAlu: %d |1-ReadData %d",resultado,ReadData);
        $display("WriteDataFinal: %d",WriteDataReg);
        $display("========================================================================\n");
        pc = PcProximo;
        if (pc > 4 ) begin
            $finish;
        end
    end

endmodule

//Para compilar e rodar
//mingw32-make Teste_ALU