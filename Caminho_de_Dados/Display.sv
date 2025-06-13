`timescale 1ns/1ps

module Display(
        input logic clk,
        input logic reset,
        output logic [6:0] displaypc1,
        output logic [6:0] displaypc2,
        output logic [6:0] displayx1
    ); 

    logic [31:0] pc;
    logic [31:0] Regx;

    caminhodedados Caminhodedados(
        .clk(clk),
        .Pcdisplay(pc),
        .Regx1(Regx),
        .reset(reset)
    );

    always_ff @(posedge clk)begin
        case((pc/4)%10)
        4'd0: displaypc2 = 7'b1000000;
        4'd1: displaypc2 = 7'b1111001;
        4'd2: displaypc2 = 7'b0100100;
        4'd3: displaypc2 = 7'b0110000;
        4'd4: displaypc2 = 7'b0011001;
        4'd5: displaypc2 = 7'b0010010;
        4'd6: displaypc2 = 7'b0000010;
        4'd7: displaypc2 = 7'b1111000;
        4'd8: displaypc2 = 7'b0000000;
        4'd9: displaypc2 = 7'b0010000;
        default: displaypc2 = 7'b1111111; //display apagado
    endcase
        case((pc/4)/10)
        4'd0: displaypc1 = 7'b1000000;
        4'd1: displaypc1 = 7'b1111001;
        4'd2: displaypc1 = 7'b0100100;
        4'd3: displaypc1 = 7'b0110000;
        4'd4: displaypc1 = 7'b0011001;
        4'd5: displaypc1 = 7'b0010010;
        4'd6: displaypc1 = 7'b0000010;
        4'd7: displaypc1 = 7'b1111000;
        4'd8: displaypc1 = 7'b0000000;
        4'd9: displaypc1 = 7'b0010000;
        default: displaypc1 = 7'b1111111; //display apagado
        endcase

    case(Regx/1000)
        4'd0: displayx1 = 7'b1000000;
        4'd1: displayx1 = 7'b1111001;
        4'd2: displayx1 = 7'b0100100;
        4'd3: displayx1 = 7'b0110000;
        4'd4: displayx1 = 7'b0011001;
        4'd5: displayx1 = 7'b0010010;
        4'd6: displayx1 = 7'b0000010;
        4'd7: displayx1 = 7'b1111000;
        4'd8: displayx1 = 7'b0000000;
        4'd9: displayx1 = 7'b0010000;
        default: displayx1 = 7'b1111111;
    endcase

    end


endmodule
