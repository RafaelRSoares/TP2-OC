module ALU(
    input logic [31:0] entrada1,
    input logic [31:0] entrada2,
    input logic [3:0] controle_alu,
    output logic [31:0] resultado,
    output logic eh_zero //pro beq
);

//operações
logic [4:0] aux; //o compilador deu problema quando tentei usar direto no always_comb
assign aux = entrada2[4:0];
always_comb begin
    case (controle_alu)
        4'b0000: begin
            resultado = entrada1 + entrada2; //ass
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