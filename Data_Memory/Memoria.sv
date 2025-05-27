module Memoria(
    input logic clk,
    input logic [31:0] Endereco,
    input logic [31:0] WriteData,
    input logic MemWrite,
    input logic MemRead,
    output logic [31:0] ReadData
);

parameter EspacoMem = 256;

logic [31:0] MemExterna [0:EspacoMem - 1];

logic [7:0] EnderecoPalavra;

assign EnderecoPalavra = Endereco[9:2];

always_ff @(posedge clk) begin
    if(MemRead)begin
        ReadData = MemExterna[EnderecoPalavra];
    end
end

always_ff @(posedge clk) begin
    if(MemWrite)begin
        MemExterna[EnderecoPalavra] = WriteData;
    end
end

final begin
    integer file,i;
    file = $fopen("MEmoriaExterna.txt","w");
    if (file == 0) begin
        $display("Erro em abrir o arquivo\n");
        $finish;
    end

    for (i = 0;i < 256 ; i = i + 1) begin
        $fdisplay(file, "%08x",MemExterna[i]);
    end

    $fclose(file);
end

endmodule