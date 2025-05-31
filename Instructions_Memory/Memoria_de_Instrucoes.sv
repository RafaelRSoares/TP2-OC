module Memoria_Intrucoes(
    input logic [31:0] pc,          // Endereço da instrução (PC)
    output logic [31:0] instruction, // Instrução lida da memória
    output logic [6:0] Opcode,
    output logic [4:0] Rs1,
    output logic [4:0] Rs2,
    output logic [4:0] RsD,
    output logic [2:0] funct3,
    output logic funct7
);

    parameter TamMEM = 16;          // Tamanho da memória (16 palavras)
    logic [31:0] mem [0:TamMEM-1];  // Memória de instruções

    // Inicialização da memória com as instruções em binário pq o quartus não aceita o .mem
    initial begin
        mem[0]  = 32'b00000000000101110101000100110011; // srl x2, x14, x1
        mem[1]  = 32'b00000000001000000000001000100011; // sb x2, 4(x0)
        mem[2]  = 32'b00000000010000000000000010000011; // lb x1, 4(x0)
        mem[3]  = 32'b01000000000000001000000100110011; // sub x2, x1, x0
        mem[4]  = 32'b01000000000001110000000010110011; // sub x1, x14, x0
        mem[5]  = 32'b01000000001011100000000010110011; // sub x1, x28, x0
        mem[6]  = 32'b01000000001000001000000010110011; // sub x1, x1, x2
        mem[7]  = 32'b01000000001000001000000010110011; // sub x1, x1, x2
        mem[8]  = 32'b00000000000100001000011001100011; // beq x1, x1, 12
        mem[9]  = 32'b01000000000001110000000010110011; // sub x1, x14, x0
        mem[10] = 32'b00000000000100000000000000100011; // sb x1, 0(x0)
        mem[11] = 32'b00000000001000001111000010110011; // and x1, x1, x2
        mem[12] = 32'b00000000000000001110000010010011; // ori x1 , x1, 0
        mem[13] = 32'b00000000000100000000000000100011; // sb x1, 0(x0)
        
        //NOPs pra completar os espaços
        mem[14] = 32'b00000000000000000000000000010011; // NOP
        mem[15] = 32'b00000000000000000000000000010011; // NOP
    end

    // Leitura da instrução
    assign instruction = mem[pc[31:2]]; // Divisão por 4 (word-aligned)

    // Decodificação da instrução
    assign Opcode = instruction[6:0];
    assign Rs1 = instruction[19:15];
    assign Rs2 = instruction[24:20];
    assign RsD = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[30];

endmodule