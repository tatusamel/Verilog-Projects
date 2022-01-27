`timescale 1ns / 1ns
`include "mux_4x1.v"

module mux_4x1_tb;

reg [3:0] i;
reg [1:0] s;
wire F;

mux_4x1 uut(.i(i), .s(s), .F(F));

    initial begin
        $dumpfile("mux_4x1.vcd");
        $dumpvars(0,mux_4x1_tb);


        for(integer j=0; j < 64; j = j+1) begin

            {s,i} = j; #10;

        end

        $finish;
    end

endmodule