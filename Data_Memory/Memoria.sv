module Memoria(
    input  logic clk,
    input  logic [31:0] Endereco,
    input  logic [31:0] WriteData,
    input  logic MemWrite,
    input  logic MemRead,
    output logic [31:0] ReadData
);
    parameter EspacoMem = 256;

    logic [7:0] MemExterna [0:EspacoMem - 1];
    logic [7:0] endereco_byte;
    logic [7:0] dado_lido;
    integer i;

    assign endereco_byte = Endereco[7:0];

    initial begin
        for (i = 0; i < EspacoMem; i = i + 1) begin
            MemExterna[i] = 8'h0;
        end
    end
//esse trem de assíncrona que eu usei na alu antes, ver se funciona melhor aqui, já não está dando certo mesmo, quem sabe
    // Leitura combinacional (assíncrona)
    always_comb begin
        if (MemRead && !MemWrite) begin
            dado_lido = MemExterna[endereco_byte];
            ReadData = {{24{dado_lido[7]}}, dado_lido}; //aqui estava 22 antes, mas parce que o ccerto é 24, vamos ver se vai
            $display("entrou para ler: byte[%h] = %h", endereco_byte, dado_lido);
        end
        else begin
            ReadData = 32'b0;
        end
    end

    // Escrita síncrona
    always_ff @(posedge clk) begin
        if (MemWrite) begin
            MemExterna[endereco_byte] = WriteData[7:0];
            $display("escreveu: byte[%h] = %h", endereco_byte, WriteData[7:0]);
        end
    end

    final begin
        $display("dado_lido final: %h | ReadData: %h", dado_lido, ReadData);
        for (i = 0; i < 40; i = i + 1) begin
            $display("MemoriaExterna[%d] = %h", i, MemExterna[i]);
        end
    end
endmodule