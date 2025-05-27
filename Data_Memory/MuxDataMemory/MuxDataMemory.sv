module MuxDataMemory (
    input logic MemtoReg,
    input logic [31:0] ReadData,
    input logic [31:0] ResultadoALU,
    output logic [31:0] WriteData
);

always_comb begin
    case (MemtoReg)
        1'b0: begin
            WriteData = ResultadoALU;
        end 
        1'b1: begin
            WriteData = ReadData;
        end 
    endcase
end

    
endmodule