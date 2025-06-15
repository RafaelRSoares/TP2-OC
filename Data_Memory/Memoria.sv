module Memoria(
    input logic clk,
    input logic [31:0] Endereco,
    input logic [31:0] WriteData,
    input logic MemWrite,
    input logic MemRead,
    output logic [31:0] ReadData,
    input logic reset
);
    parameter EspacoMem = 256;
    localparam AddrWidth = $clog2(EspacoMem);

    reg [7:0] MemExterna [0:EspacoMem-1];
    
    reg [31:0] ReadData_reg;
    
    wire [AddrWidth-1:0] endereco_byte = Endereco[AddrWidth-1:0];
    
    assign ReadData = ReadData_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            for (int i = 0; i < EspacoMem; i = i + 1) begin
                MemExterna[i] <= 8'h0;
            end
            ReadData_reg <= 32'b0;
        end
        else begin
            if (MemWrite) begin
                MemExterna[endereco_byte] <= WriteData[7:0];
            end
            
             if (MemRead) begin
                ReadData_reg <= {{24{MemExterna[endereco_byte][7]}},MemExterna[endereco_byte]};
            end
        end
    end

endmodule