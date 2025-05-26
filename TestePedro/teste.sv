module Teste(
    input logic clk
);
    always_ff @(posedge clk) begin
        $display("DUT: Subiu o clock em %0t", $time);
    end
    
    always_ff @(negedge clk) begin
        $display("DUT: Desceu o clock em %0t", $time);
    end

endmodule