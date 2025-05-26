`timescale 1ns/1ps

module TB_registradores;
    
    logic clk;
    logic write;
    logic [31:0] pc;
    logic [31:0] instruction;
    logic [6:0] Opcode;
    logic [4:0] Reg1;
    logic [4:0] Reg2;
    logic [4:0] RegD;
    logic [31:0] WriteData;
    logic [31:0] data1;
    logic [31:0] data2;

    Memoria_Intrucoes TBMEMORIA(
        .pc(pc),
        .instruction(instruction),
        .Opcode(Opcode),
        .Reg1(Reg1),
        .Reg2(Reg2),
        .RegD(RegD)
    );

    Moduloregistradores TBREGISTRADOR(
        .clk(clk),
        .write(write),
        .Reg1(Reg1),
        .Reg2(Reg2),
        .RegD(RegD),
        .WriteData(WriteData),
        .Data1(data1),
        .Data2(data2)
     );

    // Geração do clock
    initial begin
        clk = 0;
        pc = 0;
        write = 0;
        WriteData = 32'd50;
        forever #5 clk = ~clk; // alterna clk a cada 5ns
    end

    // Apenas para simulação: mostra o valor do clock ao longo do tempo
    always_ff @(posedge clk)begin
        $display("Tempo: %d| clk = %b| PC: %d", $time, clk,pc);
        $display("Intrucao: %b",instruction);
        $display("Opcode[6:0]: %b |Rs1[19:15]: %b |Rs2[24:24]: %b |RD[11:7]: %b",Opcode,Reg1,Reg2,RegD);
        $display("Data1: %d |Data2: %d",data1,data2);
        $display("============================================================");
        pc = pc + 4;
        if (pc > 24) begin
            $finish;
        end
    end

endmodule


//Falta comfirmar se ta escrevendo mas tenho que testar a ALU mas mesmo assim acho que deu bom
//Para Compilar:
//iverilog -g2012 -I Instructions_Memory -o executavel.vvp Instructions_Memory/Memoria_de_Instrucoes.sv Register\Registradores.sv Register\TB_registradores.sv
//vvp executavel.vvp