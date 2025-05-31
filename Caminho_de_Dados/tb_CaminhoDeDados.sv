`timescale 1ns/1ps

    module tb_CaminhoDeDados; 

    reg clk, pc;

    caminhodedados caminhodedados(
        logic clk
    );

    // Geração do clock
    initial begin
        clk = 0;
        pc = 0;
        forever #5 clk = ~clk; // alterna clk a cada 5ns
    end

    // Apenas para simulação: mostra o valor do clock ao longo do tempo
    always_ff @(posedge clk)begin
        $display("========================================================================");
        $display("Memoria de Intrucao:");
        $display("Tempo: %d |PC: %d", $time,pc);
        $display("Instrucao: %b |Opcode: %b |Rs1: %d |Rs2: %d",instruction,Opcode,Rs1,Rs2);
        $display("RD: %d |Funct3: %b |Funct7: %b\n",RsD,funct3,funct7);

        $display("Controle:");
        $display("Branch %d |MemRead: %d |MemtoReg: %d |ALUOp: %b",Branch,MemRead,MemtoReg,ALUOp);
        $display("MemWrite: %d |AlUSrc: %d |RegWrite %d\n",MemWrite,ALUSrc,RegWrite);

        $display("Registradores:");
        $display("Write Data: %d |DataRs1 %d |DataRs2: %d\n",WriteDataReg,data1,data2);

        $display("Gerador Imediato: %d",Imediato);
        $display("Instrucao: %b",instruction);
        $display("Saida Mux ALU %d",SaidaMuxALU);
        $display("ALU control: %d\n",controle_alu);

        $display("ALU:");
        $display("Resultado ALU: %d |Eh_zero :%d\n",resultado,eh_zero);

        $display("Data Memory:");
        $display("Endereco/Entrada: %d |WriteData/Data2: %b",resultado,data2);
        $display("ReadData/SaidaMemory: %b\n",ReadData);

        $display("Mux Data Memory:");
        $display("0-ResultadoAlu: %d |1-ReadData %d",resultado,ReadData);
        $display("WriteDataFinal: %d",WriteDataReg);
        $display("========================================================================\n");
        pc = PcProximo;
        if (pc > 64 ) begin
            $finish;
        end
    end

endmodule
