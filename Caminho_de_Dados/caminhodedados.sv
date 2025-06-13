module caminhodedados(
    input logic clk,
    input logic reset,
    output logic [31:0] Pcdisplay,
    output logic [31:0] Regx1
);

    
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
        .Pcdisplay(Pcdisplay),
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
        .Data2(data2),
        .DisplayX1(Regx1),
        .reset(reset)
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
        .ReadData(ReadData),
        .reset(reset)
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
        .PcProximo(PcProximo),
        .reset(reset)
    );
endmodule


// module display(
//     input [31:0] pc,
//     input signed [31:0] reg1,
//     output reg [6:0] display1,
//     output reg [6:0] display2,
//     output reg [6:0] display3,
//     output reg [6:0] display4,
//     output reg [6:0] display5,
//     output reg [6:0] display6
// );

//     always@(*)begin
    
//         case((pc/4)%10)
//         4'd0: display1 = 7'b1000000;
//         4'd1: display1 = 7'b1111001;
//         4'd2: display1 = 7'b0100100;
//         4'd3: display1 = 7'b0110000;
//         4'd4: display1 = 7'b0011001;
//         4'd5: display1 = 7'b0010010;
//         4'd6: display1 = 7'b0000010;
//         4'd7: display1 = 7'b1111000;
//         4'd8: display1 = 7'b0000000;
//         4'd9: display1 = 7'b0010000;
//         default: display1 = 7'b1111111; //display apagado
//     endcase
//         case((pc/4)/10)
//         4'd0: display2 = 7'b1000000;
//         4'd1: display2 = 7'b1111001;
//         4'd2: display2 = 7'b0100100;
//         4'd3: display2 = 7'b0110000;
//         4'd4: display2 = 7'b0011001;
//         4'd5: display2 = 7'b0010010;
//         4'd6: display2 = 7'b0000010;
//         4'd7: display2 = 7'b1111000;
//         4'd8: display2 = 7'b0000000;
//         4'd9: display2 = 7'b0010000;
//         default: display2 = 7'b1111111; //display apagado
//         endcase
//     if (reg1 == -7) begin
//     display3 = 7'b1111111;
//     display4 = 7'b1111111;
//     display5 = 7'b0111111;
//     display6 = 7'b1111000;
// end else begin
//     case(reg1/1000)
//         4'd0: display3 = 7'b1000000;
//         4'd1: display3 = 7'b1111001;
//         4'd2: display3 = 7'b0100100;
//         4'd3: display3 = 7'b0110000;
//         4'd4: display3 = 7'b0011001;
//         4'd5: display3 = 7'b0010010;
//         4'd6: display3 = 7'b0000010;
//         4'd7: display3 = 7'b1111000;
//         4'd8: display3 = 7'b0000000;
//         4'd9: display3 = 7'b0010000;
//         default: display3 = 7'b1111111;
//     endcase
//     case((reg1/100)%10)
//         4'd0: display4 = 7'b1000000;
//         4'd1: display4 = 7'b1111001;
//         4'd2: display4 = 7'b0100100;
//         4'd3: display4 = 7'b0110000;
//         4'd4: display4 = 7'b0011001;
//         4'd5: display4 = 7'b0010010;
//         4'd6: display4 = 7'b0000010;
//         4'd7: display4 = 7'b1111000;
//         4'd8: display4 = 7'b0000000;
//         4'd9: display4 = 7'b0010000;
//         default: display4 = 7'b1111111;
//     endcase
//     case((reg1/10)%10)
//         4'd0: display5 = 7'b1000000;
//         4'd1: display5 = 7'b1111001;
//         4'd2: display5 = 7'b0100100;
//         4'd3: display5 = 7'b0110000;
//         4'd4: display5 = 7'b0011001;
//         4'd5: display5 = 7'b0010010;
//         4'd6: display5 = 7'b0000010;
//         4'd7: display5 = 7'b1111000;
//         4'd8: display5 = 7'b0000000;
//         4'd9: display5 = 7'b0010000;
//         default: display5 = 7'b1111111;
//     endcase
//     case(reg1%10)
//         4'd0: display6 = 7'b1000000;
//         4'd1: display6 = 7'b1111001;
//         4'd2: display6 = 7'b0100100;
//         4'd3: display6 = 7'b0110000;
//         4'd4: display6 = 7'b0011001;
//         4'd5: display6 = 7'b0010010;
//         4'd6: display6 = 7'b0000010;
//         4'd7: display6 = 7'b1111000;
//         4'd8: display6 = 7'b0000000;
//         4'd9: display6 = 7'b0010000;
//         default: display6 = 7'b1111111;
//     endcase
//     end
//     end
// endmodule