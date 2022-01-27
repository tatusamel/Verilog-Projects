`include "decoder_2x4.v"
`timescale 1ns/1ns

module decoder_2x4_tb;

    reg [1:0] A;
    wire [3:0] D;

    decoder_2x4 uut(.A(A),.D(D));

        initial begin

        $dumpfile("decoder_2x4.vcd");
        $dumpvars(0,decoder_2x4_tb);

        A = 2'b00; #20
        A = 2'b01; #20
        A = 2'b10; #20
        A = 2'b11; #20
        $finish;
        end 
endmodule