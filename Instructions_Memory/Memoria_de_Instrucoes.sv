module Memoria_Intrucoes(
    input logic [31:0] pc, // Endereço da instrução (PC)
    output logic [31:0] instruction,  // Instrução lida da memória
    output logic [6:0] Opcode,
    output logic [4:0] Rs1,
    output logic [4:0] Rs2,
    output logic [4:0] RsD,
    output logic [2:0] funct3,
    output logic funct7
);

    parameter TamMEM = 52 ;

    logic [31:0] mem [0:TamMEM - 1];

    assign instruction = mem[pc[31:2]];

    assign Opcode = instruction[6:0];
    assign Rs1 = instruction[19:15];
    assign Rs2 = instruction[24:20];
    assign RsD = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[30];

    initial begin
        $readmemb("Instructions_Memory/Instrucoes.mem", mem);
    end


endmodule       