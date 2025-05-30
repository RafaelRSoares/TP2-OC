module Memoria(
    input logic clk,
    input logic [31:0] Endereco,
    input logic [31:0] WriteData,
    input logic MemWrite,
    input logic MemRead,
    output logic [31:0] ReadData
);

parameter EspacoMem = 256;

logic [7:0] EnderecoPalavra;

assign EnderecoPalavra = Endereco[9:2];

logic [31:0] MemExterna [0:EspacoMem - 1];

integer i;

initial begin
    for(i = 0; i < EspacoMem; i = i + 1) begin
        MemExterna[i] = 0;
    end
end


always_ff @(posedge clk) begin
    if(MemRead)begin
        ReadData = MemExterna[Endereco];
    end
    else if(MemWrite)begin
        MemExterna[Endereco] = WriteData;
    end
end

// final begin
//     for(i = 0; i < EspacoMem; i = i + 1) begin
//         $display("memoria %d = %d",i,MemExterna[i]);
//     end
// end



endmodule

