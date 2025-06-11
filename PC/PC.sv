module Pc_modulo(
    input logic [31:0] PcAnterior,
    input logic [31:0] Imediato,
    input logic Branch,
    input logic eh_zero,
    output logic [31:0] PcProximo
);



always_comb begin
    if (Branch && eh_zero) begin
        PcProximo = PcAnterior + Imediato;
        //PcAnterior  = PcProximo;
    end
    else begin
        PcProximo = PcAnterior + 4;
        //PcAnterior  = PcProximo;
    end
end

endmodule