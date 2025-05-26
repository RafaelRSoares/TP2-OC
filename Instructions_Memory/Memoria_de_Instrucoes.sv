module Memoria_Intrucoes(
    input logic [31:0] pc, // Endereço da instrução (PC)
    output logic [31:0] instruction,  // Instrução lida da memória
    output logic [6:0] Opcode,
    output logic [4:0] Reg1,
    output logic [4:0] Reg2,
    output logic [4:0] RegD
);

    parameter TamMEM = 7;

    logic [31:0] mem [0:TamMEM - 1];

    assign instruction = mem[pc[31:2]];

    assign Opcode = instruction[6:0];
    assign Reg1 = instruction[19:15];
    assign Reg2 = instruction[24:20];
    assign RegD = instruction[11:7];

    initial begin
        $readmemb("Instructions_Memory/Instrucoes.mem", mem);
    end


endmodule       