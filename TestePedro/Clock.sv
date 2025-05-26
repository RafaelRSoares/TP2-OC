module clock_generator;

  logic clk;

  // Geração do clock
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // alterna clk a cada 5ns
  end

  // Apenas para simulação: mostra o valor do clock ao longo do tempo
  initial begin
    //$monitor("Tempo: %0t | clk = %b", $time, clk);
    #100 $finish; // encerra a simulação após 100ns
  end

endmodule