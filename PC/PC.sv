module Pc_modulo(
    input logic clk,
    input logic [31:0] Imediato,
    input logic Branch,
    input logic eh_zero,
    output logic [31:0] PcProximo,
    input logic reset
);

// always_comb begin
//     if (reset) begin
//         PcProximo = 32'd0;
//         //PcAnterior = 32'd0;
//     end
// end

// always_comb begin
//     integer aux;
//     $display("PC%d",PcAnterior);
//     if (Branch && eh_zero) begin
//         aux = PcAnterior + Imediato;
//         PcProximo = aux;
//     end
//     else begin
//         PcProximo = PcAnterior + 4;
//         //PcAnterior  = PcProximo;
//     end
// end

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