module Pc_modulo(
    input logic [31:0] PcAnterior,
    input logic [31:0] Imediato,
    input logic Branch,
    input logic eh_zero,
    output logic [31:0] PcProximo,
    input logic reset
);

always_comb begin
    if (reset) begin
        PcProximo = 32'd0;
        //PcAnterior = 32'd0;
    end
end

always_comb begin
    integer aux;
    if (Branch && eh_zero) begin
        aux = PcAnterior + Imediato;
        PcProximo = aux;
    end
    else begin
        PcProximo = PcAnterior + 4;
        //PcAnterior  = PcProximo;
    end
end

endmodule