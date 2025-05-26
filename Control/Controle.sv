module Control (
    input logic [6:0] opcode, //7 bits
    output logic RegWrite, MemRead, MemWrite, ALUSrc, MempraReg, Branch,
    output logic [1:0] ALUOp //2 bits pra definir o tipo de operação
);

always_comb begin

    // valor base das variáveis, é o default, só que antes ao invés de no final, pra poder escrever só as mudanças de valor
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
    endcase
    
end
    
endmodule