`timescale 1ns/1ps

module TB_pc;

    logic clk;
    logic [31:0] pc;
    logic [31:0] PcProximo;
    logic [31:0] Imediato;
    logic Branch;
    logic eh_zero;
    
    Pc_modulo TBPCMODULO (
        .PcAnterior(pc),
        .Imediato(Imediato),
        .Branch(Branch),
        .eh_zero(eh_zero),
        .PcProximo(PcProximo)
    );

    // Geração do clock
    initial begin
        pc = 0;
        clk = 0;
        Branch = 1;
        eh_zero = 1;
        Imediato = 8;
        forever #5 clk = ~clk; // alterna clk a cada 5ns
    end

    // Apenas para simulação: mostra o valor do clock ao longo do tempo
    always_ff @(posedge clk)begin
        $display("Tempo: %d ", $time);
        $display("PC %b |imdeiato: %d |branch: %b |Eh_zero %b",pc,Imediato,Branch,eh_zero);
        $display("PC Proximo: %b",pc);
        pc = PcProximo;
        if (pc > 24) begin
            $finish;
        end
    end
endmodule

// Para compilar e rodar
//mingw32-make Teste_Intrucoes