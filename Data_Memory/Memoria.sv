module Memoria(
    input  logic clk,
    input  logic [31:0] Endereco,
    input  logic [31:0] WriteData,
    input  logic MemWrite,
    input  logic MemRead,
    output logic [31:0] ReadData
);
    parameter EspacoMem = 256;
    localparam AddrWidth = $clog2(EspacoMem);

    logic [7:0] MemExterna [0:EspacoMem-1];
    logic [AddrWidth-1:0] endereco_byte;
    integer i;

    assign endereco_byte = Endereco[AddrWidth-1:0];

    // Inicialização (apenas para simulação)
    initial begin
        for (i = 0; i < EspacoMem; i = i + 1)
            MemExterna[i] = 8'h0;
    end

    // Leitura combinacional (sem latch)
    always_comb begin
        if (MemRead) begin
            ReadData = {{24{MemExterna[endereco_byte][7]}}, MemExterna[endereco_byte]};
        end else begin
            ReadData = 32'b0;
        end
    end

    // Escrita síncrona
    always_ff @(posedge clk) begin
        if (MemWrite) begin
            MemExterna[endereco_byte] <= WriteData[7:0];
        end
    end
endmodule