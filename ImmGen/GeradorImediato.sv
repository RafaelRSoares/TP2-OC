module GeradorImediato(
    input logic [31:0] Instrucao,
    output logic [31:0] Imediato
);

logic [11:0] aux;

always_comb begin

    case (Instrucao[6:0])
        // 7'b0110011: begin //tipo-R (pro nosso é sub, and e a 'srl')
        //     RegWrite=1; ALUSrc=0; ALUOp=2'b10;
        // end
        7'b0000011: begin //lb
            aux = Instrucao[31:20];
        end
        7'b0100011: begin //sb
            aux[4:0] = Instrucao[11:7];
            aux[11:5] = Instrucao[31:25];
        end
        7'b0010011: begin //tipo-I (ori, pra gente)
            aux = Instrucao[31:20];
        end
        7'b1100011: begin //beq
            aux[3:0] = Instrucao[11:8];
            aux[9:4] = Instrucao[30:25];
            aux[10] = Instrucao[7];
            aux[11] = Instrucao[30];
        end

        
    endcase
    Imediato = {{20{aux[11]}},aux};
end

endmodule