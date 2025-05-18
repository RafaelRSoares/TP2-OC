module controle_alu(
    input logic [1:0] ALUOp, //do Controle
    input logic [2:0] funct3, //os 3 bits da funct3, 14 a 12
    input logic funct7b5,      //o sexto bit (da esquerda pra direita) da funct7, o único que muda nas nossas instruções
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
            3'b000: begin //pra gente, pode ser add ou sub
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
            controle_alu = 4'b1111; //inválido aqui tbm
    endcase
end

endmodule
        


        