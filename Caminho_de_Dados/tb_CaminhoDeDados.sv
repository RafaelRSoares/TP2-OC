`timescale 1ns/1ps

module Display(
        output logic [6:0] displaypc1,
        output logic [6:0] displaypc2,
        output logic [6:0] displayDisplay
    ); 

    reg clk;
    logic [31:0] pc;
    logic Regx;

    caminhodedados Caminhodedados(
        .clk(clk),
        .Pcdisplay(pc),
        .Regx1(Regx1)
    );

    always_ff @(posedge clk)begin
        $display("pc %d",pc);
    end


endmodule


// `timescale 1ns/1ps

//     module Display(
//         output logic [6:0] displaypc1,
//         output logic [6:0] displaypc2,
//         output logic [6:0] displayDisplay,
//     ); 

//     reg clk;
//     input logic [31:0] pc;
//     input logic Regx;

//     caminhodedados Caminhodedados(
//         .clk(clk)
//         .pc(pc)
//         .Regx1(Regx1)
//     );

//     always_ff @(posedge clk)begin
        


//     end


// endmodule
