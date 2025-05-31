module Moduloregistradores(
    input logic clk,RegWrite,
    input logic [4:0] Rs1,
    input logic [4:0] Rs2,
    input logic [4:0] RsD,
    input logic [31:0] WriteData,
    output logic [31:0] Data1,
    output logic [31:0] Data2
);

logic [31:0] registradores [31:0];

integer i;
initial begin
    for (i = 0;i < 32;i = i + 1) begin
        registradores[i] = i;
    end
end
    
assign Data1 = (Rs1 != 0) ? registradores[Rs1] : 32'b0;
assign Data2 = (Rs2 != 0) ? registradores[Rs2] : 32'b0;

always_ff @(posedge clk)begin
    if (RegWrite == 1 && RsD != 0) begin
        registradores[RsD] = WriteData;
    end
end

endmodule