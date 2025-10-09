module Moduloregistradores(
    input logic clk,
    input logic RegWrite,
    input logic [4:0] Rs1,
    input logic [4:0] Rs2,
    input logic [4:0] RsD,
    input logic [31:0] WriteData,
    output logic [31:0] Data1,
    output logic [31:0] Data2,
    output logic [31:0] DisplayX1,
    input logic reset
);

    logic [31:0] registradores [31:0];
    
    always_ff @(posedge clk) begin
        if (reset) begin
            for (int i = 0; i < 32; i = i + 1) begin
                registradores[i] <= i; 
            end
        end
        else if (RegWrite && RsD != 0) begin
            registradores[RsD] <= WriteData;
        end
    end

    assign Data1 = (Rs1 != 0) ? registradores[Rs1] : 32'b0;
    assign Data2 = (Rs2 != 0) ? registradores[Rs2] : 32'b0;
    assign DisplayX1 = registradores[1];

endmodule

module Pc_modulo(
    input logic clk,
    input logic [31:0] Imediato,
    input logic Branch,
    input logic eh_zero,
    output logic [31:0] PcProximo,
    input logic reset
);

always_ff @(posedge clk) begin
    if(reset) begin
        PcProximo = 32'd0;
    end
    else if(Branch && eh_zero) begin
        PcProximo = PcProximo + Imediato;
    end
    else begin
        PcProximo = PcProximo + 4;
    end
end

endmodule

module Memoria_Intrucoes(
    input logic [31:0] pc,
    output logic [31:0] Pcdisplay,
    output logic [31:0] instruction,
    output logic [6:0] Opcode,
    output logic [4:0] Rs1,
    output logic [4:0] Rs2,
    output logic [4:0] RsD,
    output logic [2:0] funct3,
    output logic funct7
);

    parameter TamMEM = 256;

    logic [31:0] mem [0:TamMEM - 1];

    assign instruction = mem[pc[31:2]];

    assign Opcode = instruction[6:0];
    assign Rs1 = instruction[19:15];
    assign Rs2 = instruction[24:20];
    assign RsD = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[30];

    initial begin
        mem[0]  = 32'b00000000000101110101000100110011; // srl x2, x14, x1
        mem[1]  = 32'b00000000001000000000001000100011; // sb x2, 4(x0)
        mem[2]  = 32'b00000000010000000000000010000011; // lb x1, 4(x0)
        mem[3]  = 32'b01000000000000001000000100110011; // sub x2, x1, x0
        mem[4]  = 32'b01000000000001110000000010110011; // sub x1, x14, x0
        mem[5]  = 32'b01000000001011100000000010110011; // sub x1, x28, x0
        mem[6]  = 32'b01000000001000001000000010110011; // sub x1, x1, x2
        mem[7]  = 32'b01000000001000001000000010110011; // sub x1, x1, x2
        mem[8]  = 32'b00000000000100001000011001100011; // beq x1, x1, 12
        mem[9]  = 32'b01000000000001110000000010110011; // sub x1, x14, x0
        mem[10] = 32'b00000000000100000000000000100011; // sb x1, 0(x0)
        mem[11] = 32'b00000000001000001111000010110011; // and x1, x1, x2
        mem[12] = 32'b00000000000000001110000010010011; // ori x1 , x1, 0
        mem[13] = 32'b00000000000100000000000000100011; // sb x1, 0(x0)

        //NOPs pra completar os espaços
        mem[14] = 32'b00000000000000000000000000010011; // NOP
        mem[15] = 32'b00000000000000000000000000010011; // NOP
    end


endmodule       

module GeradorImediato (
    input  logic [31:0] Instrucao,
    output logic [31:0] Imediato
);

    logic [31:0] imm;

    always_comb begin
        case (Instrucao[6:0])
            7'b0000011: // lb (tipo I)
                imm = {{20{Instrucao[31]}}, Instrucao[31:20]};
            7'b0010011: // ori (tipo I)
                imm = {{20{Instrucao[31]}}, Instrucao[31:20]};

            7'b0100011: // sb (tipo S)
                imm = {{20{Instrucao[31]}}, Instrucao[31:25], Instrucao[11:7]};

            7'b1100011: // beq (tipo B)
                imm = {{19{Instrucao[31]}}, Instrucao[31], Instrucao[7], Instrucao[30:25], Instrucao[11:8], 1'b0};

            7'b0110111: // lui (tipo U)
                imm = {Instrucao[31:12], 12'b0};
            7'b0010111: // auipc (tipo U)
                imm = {Instrucao[31:12], 12'b0};

            7'b1101111: // jal (tipo J)
                imm = {{11{Instrucao[31]}}, Instrucao[31], Instrucao[19:12], Instrucao[20], Instrucao[30:21], 1'b0};

            default:
                imm = 32'd0;
        endcase

        Imediato = imm;
    end

endmodule


module Memoria(
    input logic clk,
    input logic [31:0] Endereco,
    input logic [31:0] WriteData,
    input logic MemWrite,
    input logic MemRead,
    output logic [31:0] ReadData,
    input logic reset
);
    parameter EspacoMem = 256;
    localparam AddrWidth = $clog2(EspacoMem);

    reg [7:0] MemExterna [0:EspacoMem-1];
    
    reg [31:0] ReadData_reg;
    
    wire [AddrWidth-1:0] endereco_byte = Endereco[AddrWidth-1:0];
    
    assign ReadData = ReadData_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            for (int i = 0; i < EspacoMem; i = i + 1) begin
                MemExterna[i] <= 8'h0;
            end
            ReadData_reg <= 32'b0;
        end
        else begin
            if (MemWrite) begin
                MemExterna[endereco_byte] <= WriteData[7:0];
            end
            
             if (MemRead) begin
                ReadData_reg <= {{24{MemExterna[endereco_byte][7]}},MemExterna[endereco_byte]};
            end
        end
    end

endmodule

module MuxDataMemory (
    input logic MemtoReg,clk,
    input logic [31:0] ReadData,
    input logic [31:0] ResultadoALU,
    output logic [31:0] WriteData
);

always_comb begin
    case (MemtoReg)
        1'b0: begin
            WriteData = ResultadoALU;
        end 
        1'b1: begin
            WriteData = ReadData;
        end 
    endcase
end

    
endmodule

module Controle (
    input logic [6:0] opcode, //7 bits
    output logic RegWrite, MemRead, MemWrite, ALUSrc, MempraReg, Branch,
    output logic [1:0] ALUOp //2 bits pra definir o tipo de operação
);

always_comb begin
    RegWrite   = 0;
    MemRead    = 0;
    MemWrite   = 0;
    ALUSrc     = 0;
    MempraReg  = 0;
    Branch     = 0;
    ALUOp      = 2'b00;

    case (opcode)
        7'b0110011: begin //tipo-R (pro nosso é sub, and e a 'srl')
            RegWrite=1; ALUSrc=0; ALUOp=2'b10;
        end
        7'b0000011: begin //lb
            RegWrite=1; ALUSrc=1; MemRead=1; MempraReg=1; ALUOp=2'b00;
        end
        7'b0100011: begin //sb
            MemWrite=1; ALUSrc=1; ALUOp=2'b00;
        end
        7'b0010011: begin //tipo-I (ori, pra gente)
            ALUSrc=1; RegWrite=1; ALUOp=2'b11;
        end
        7'b1100011: begin //beq
            Branch=1; ALUOp=2'b01;
        end
        default: begin
            `ifdef SIMULATION
            `endif
        end
    endcase
    
end
    
endmodule

module ALU(
    input logic [31:0] entrada1,
    input logic [31:0] entrada2,
    input logic [3:0] controle_alu,
    output logic [31:0] resultado,
    output logic eh_zero
);

logic [4:0] aux;
assign aux = entrada2[4:0];
always_comb begin
    case (controle_alu)
        4'b0000: begin
            resultado = entrada1 + entrada2; 
        end
        4'b0001: begin
            resultado = entrada1 - entrada2; //sub
        end
        4'b0010: begin
            resultado  = entrada1 & entrada2; //and
        end
        4'b0011: begin
            resultado  = entrada1 | entrada2; //or
        end
        4'b0100: begin
            resultado  = entrada1 >> aux; //srl
        end
        default: begin
            resultado = 32'bxxxxxxxx; //uma operação ou valor que não temos
        end
    endcase

if (resultado == 32'b0) //define se o resultado é 0, pro beq
    eh_zero =1; //sendo 0, eh_zero é =1, se não, é igual a 0.
else
    eh_zero=0;
end
endmodule

module MuxALU(
    input logic ALUSrc,
    input logic [31:0] entrada2,
    input logic[31:0] Imediato,
    output logic [31:0] SaidaMuxALU 
);

always_comb begin
    case (ALUSrc)
        1'b0: begin
            SaidaMuxALU = entrada2;
        end 
        1'b1: begin
            SaidaMuxALU = Imediato;
        end 
    endcase
end

endmodule


module controle_alu(
    input logic [1:0] ALUOp, //do Controle
    input logic [2:0] funct3, //os 3 bits da funct3, 14 a 12
    input logic funct7b5,      //o sexto bit (da esquerda pra direita) da funct7
    output logic [3:0] controle_alu
);

//esses valores da ALU que estou usando são com base nisso, pedro
// 0000: add
// 0001: sub
// 0010: and
// 0011: or
// 0100: srl
// 1111: operação inválida (default)

always_comb begin
    case (ALUOp)
        2'b00: begin //load e store (lb, sb), soma
            controle_alu = 4'b0000;
        end
        2'b01: begin //beq, subtrai pra compaar
            controle_alu = 4'b0001;
        end
        2'b10: begin //tipo-R, pra diferenciar precisa da funct3 e da 7b5
            case(funct3)
            3'b000: begin 
                if (funct7b5==1)
                    controle_alu = 4'b0001; //sub
                else
                    controle_alu = 4'b0000; //add
            end
            3'b111: begin
                controle_alu = 4'b0010; //and
            end
            3'b101: begin
                controle_alu = 4'b0100; //srl
            end
            default:
            controle_alu = 4'b1111; //não existe aqui
        endcase
        end
        2'b11: begin //tipo-I (só o ori pra gente)
            case (funct3)
                3'b110: begin
                    controle_alu = 4'b0011; //ori
                end
                default:
                    controle_alu = 4'b1111;
        endcase
        end

        default: 
            controle_alu = 4'b1111; //inválido
    endcase
end

endmodule
        

module caminhodedados(
    input logic clk,
    input logic reset,
    output logic [31:0] Pcdisplay,
    output logic [31:0] Regx1
);

    logic RegWrite;
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
        .pc(PcProximo),
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
        .clk(clk),
        .Imediato(Imediato),
        .Branch(Branch),
        .eh_zero(eh_zero),
        .PcProximo(PcProximo),
        .reset(reset)
    );
endmodule

module Display(
        input logic clk,
        input logic reset,
        output logic [6:0] displaypc1,
        output logic [6:0] displaypc2,
        output logic [6:0] displayx1bit1,
        output logic [6:0] displayx1bit2
    ); 

    logic [31:0] pc;
    logic [31:0] Regx;

    caminhodedados Caminhodedados(
        .clk(clk),
        .Pcdisplay(pc),
        .Regx1(Regx),
        .reset(reset)
    );

    always_ff @(posedge clk)begin
        case((pc/4)%10)
        4'd0: displaypc2 = 7'b1000000;
        4'd1: displaypc2 = 7'b1111001;
        4'd2: displaypc2 = 7'b0100100;
        4'd3: displaypc2 = 7'b0110000;
        4'd4: displaypc2 = 7'b0011001;
        4'd5: displaypc2 = 7'b0010010;
        4'd6: displaypc2 = 7'b0000010;
        4'd7: displaypc2 = 7'b1111000;
        4'd8: displaypc2 = 7'b0000000;
        4'd9: displaypc2 = 7'b0010000;
        default: displaypc2 = 7'b1111111;
    endcase
        case((pc/4)/10)
        4'd0: displaypc1 = 7'b1000000;
        4'd1: displaypc1 = 7'b1111001;
        4'd2: displaypc1 = 7'b0100100;
        4'd3: displaypc1 = 7'b0110000;
        4'd4: displaypc1 = 7'b0011001;
        4'd5: displaypc1 = 7'b0010010;
        4'd6: displaypc1 = 7'b0000010;
        4'd7: displaypc1 = 7'b1111000;
        4'd8: displaypc1 = 7'b0000000;
        4'd9: displaypc1 = 7'b0010000;
        default: displaypc1 = 7'b1111111; 
        endcase

    case(Regx/10)
        4'd0: displayx1bit1 = 7'b1000000;
        4'd1: displayx1bit1 = 7'b1111001;
        4'd2: displayx1bit1 = 7'b0100100;
        4'd3: displayx1bit1 = 7'b0110000;
        4'd4: displayx1bit1 = 7'b0011001;
        4'd5: displayx1bit1 = 7'b0010010;
        4'd6: displayx1bit1 = 7'b0000010;
        4'd7: displayx1bit1 = 7'b1111000;
        4'd8: displayx1bit1 = 7'b0000000;
        4'd9: displayx1bit1 = 7'b0010000;
        default: displayx1bit1 = 7'b1111111;
    endcase

    case(Regx%10)
        4'd0: displayx1bit2 = 7'b1000000;
        4'd1: displayx1bit2 = 7'b1111001;
        4'd2: displayx1bit2 = 7'b0100100;
        4'd3: displayx1bit2 = 7'b0110000;
        4'd4: displayx1bit2 = 7'b0011001;
        4'd5: displayx1bit2 = 7'b0010010;
        4'd6: displayx1bit2 = 7'b0000010;
        4'd7: displayx1bit2 = 7'b1111000;
        4'd8: displayx1bit2 = 7'b0000000;
        4'd9: displayx1bit2 = 7'b0010000;
        default: displayx1bit2 = 7'b1111111;
    endcase

    end

endmodule