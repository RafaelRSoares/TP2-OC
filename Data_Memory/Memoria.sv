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
        MemExterna[i] = i;
    end
end

always_ff @(posedge clk) begin
    if (MemRead) begin
        dado_lido = MemExterna[endereco_byte];
        ReadData = {{22{dado_lido[7]}}, dado_lido}; // extensão de sinal
        $display("entrou para ler");
    end 
    else if (MemWrite) begin
        MemExterna[endereco_byte] = WriteData[7:0];
    end
end

final begin
            $display("dado_lido: %b |readdata %b",dado_lido,ReadData);

    for (i = 0;i < 40 ;i = i + 1 ) begin
        $display("MemoriaExterna: [%d] = %b",i,MemExterna[i]);
    end
end


endmodule

// module Memoria(
//     input logic clk,
//     input logic [31:0] Endereco,
//     input logic [31:0] WriteData,
//     input logic MemWrite,
//     input logic MemRead,
//     output logic [31:0] ReadData
// );

// parameter EspacoMem = 256;

// logic [7:0] MemExterna [0:EspacoMem - 1];

// integer i;

// initial begin
//     for(i = 0; i < EspacoMem; i = i + 1) begin
//         MemExterna[i] = i[7:0];
//     end
// end

// always_ff @(posedge clk) begin
//     if(MemRead)begin
//         ReadData = {{24{MemExterna[Endereco][7]}},MemExterna[Endereco]};
//     end
//     else if(MemWrite)begin
//         MemExterna[Endereco] = WriteData[7:0];
//     end
// end

// final begin
//     for (i = 0;i < EspacoMem ;i = i + 1 ) begin
//         $display("MemoriaExterna: [%d] = %d",i,MemExterna[i]);
//     end
// end

// endmodule

