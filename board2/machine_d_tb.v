`include "machine_d.v"
`timescale 1ns/1ps

module machine_d_tb;

    reg x,rst,clk;
    wire F;

    machine_d UUT(.x(x), .rst(rst), .clk(clk), .F(F));

    initial begin

        $dumpfile("machine_d.vcd");
        $dumpvars(0, machine_d_tb);

        // initializing x as 0
        x = 1'b0;
        // these are random values
        rst=1'b1;#23;
        rst=1'b0;#97;
        rst=1'b1;#2;
        rst=1'b0;#138;

        $finish;
    end

    initial begin
        clk = 1'b0;
        forever begin
            #5;
            clk = ~clk;
        end
    end

    always @(posedge clk) begin
        x = {$random} % 2;
    end

endmodule
