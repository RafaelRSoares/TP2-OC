module Moduloregistradores(
    input logic clk,write,
    input logic [4:0] Reg1,
    input logic [4:0] Reg2,
    input logic [4:0] RegD,
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

assign Data1 = (Reg1 != 0) ? registradores[Reg1] : 32'b0;
assign Data2 = (Reg2 != 0) ? registradores[Reg2] : 32'b0;

always @(posedge clk)begin
    if (write != 1 && RegD != 0) begin
        registradores[RegD] = WriteData;
    end
end


endmodule