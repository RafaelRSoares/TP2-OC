module GeradorImediato (
    input  logic [31:0] Instrucao,
    output logic [31:0] Imediato
);

    logic [31:0] imm;

    always_comb begin
        unique case (Instrucao[6:0])
            7'b0000011, // lb (tipo I)
            7'b0010011: // ori (tipo I)
                imm = {{20{Instrucao[31]}}, Instrucao[31:20]};

            7'b0100011: // sb (tipo S)
                imm = {{20{Instrucao[31]}}, Instrucao[31:25], Instrucao[11:7]};

            7'b1100011: // beq (tipo B)
                imm = {{19{Instrucao[31]}}, Instrucao[31], Instrucao[7], Instrucao[30:25], Instrucao[11:8], 1'b0};

            7'b0110111, // lui (tipo U)
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