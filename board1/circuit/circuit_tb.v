`include "circuit.v"
`timescale 1ns/1ns

module circuit_tb;

reg a,b,c,d;
wire F;

circuit uut2(.a(a),.b(b),.c(c),.d(d),.F(F));

    initial begin

        $dumpfile("circuit.vcd");
        $dumpvars(0,circuit_tb);

        for(integer i=0; i < 16; i = i+1) begin
            {a,b,c,d} = i; #10;
        end
        $finish;
    end
endmodule