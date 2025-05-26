module CaminhoDeDados(
    input logic clk,
    input logic reset
);

// Exemplo: instrução "sub x5, x1, x2" codificada em binário
assign instrucao = 32'h40B5053;

    logic [31:0] pc_atual;      // Endereço da instrução atual
    logic [31:0] instrucao;     // Instrução que vem da memória
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [4:0] rs1, rs2, rd;

     // Extração dos campos da instrução
    assign opcode = instrucao[6:0];
    assign rd     = instrucao[11:7];
    assign funct3 = instrucao[14:12];
    assign rs1    = instrucao[19:15];
    assign rs2    = instrucao[24:20];
    assign funct7 = instrucao[31:25];


    // Controle
    logic RegWrite, MemRead, MemWrite, ALUSrc, MempraReg, Branch;
    logic [1:0] ALUOp;

    // Unidade de controle
    Control ctrl (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .MempraReg(MempraReg),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );
    
    logic funct7b5;
    assign funct7b5 = funct7[5];


    logic [3:0] sinal_alu;

 
    controle_alu unidade_alu_ctrl (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .controle_alu(sinal_alu)
    );

    logic [31:0] dado_rs1, dado_rs2;

    always_comb begin
        case (rs1)
            5'd1: dado_rs1 = 32'd10;
            5'd2: dado_rs1 = 32'd20;
            5'd3: dado_rs1 = 32'd30;
            default: dado_rs1 = 32'd100;
        endcase

        case (rs2)
            5'd1: dado_rs2 = 32'd5;
            5'd2: dado_rs2 = 32'd10;
            5'd3: dado_rs2 = 32'd15;
            default: dado_rs2 = 32'd0;
        endcase
    end


    logic [31:0] resultado_alu;
    logic eh_zero;

   
    ALU alu_riscv (
        .entrada1(dado_rs1),
        .entrada2(dado_rs2),
        .controle_alu(sinal_alu),
        .resultado(resultado_alu),
        .eh_zero(eh_zero)
    );

endmodule
