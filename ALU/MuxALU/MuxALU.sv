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