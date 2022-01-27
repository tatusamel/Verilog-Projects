`timescale 1ns / 1ns
`include "dff.v"

module machine_d(input x, input rst, input clk, output F);

    // prs_st means present state
    // prs_st[2] = A
    // prs_st[1] = B
    // prs_st[0] = C
    reg [2:0] prs_st = 3'b000;
    wire [2:0] next_st;
    // next_st[2] = D_A
    // next_st[1] = D_B
    // next_st[0] = D_C

    dff D_A(
        .d( prs_st[2] | ( prs_st[1] & x ) ),
        .rst(rst),
        .clk(clk),
        .q(next_st[2])
    );

    dff D_B(

        .d( ( (~prs_st[2] & ~prs_st[1]) & x ) | (prs_st[1] & ~x ) ),
        .rst(rst),
        .clk(clk),
        .q(next_st[1])
    );

    dff D_C(

        .d( ~(prs_st[0] ^ x) ),
        .rst(rst),
        .clk(clk),
        .q(next_st[0])

    );

    always @(next_st or rst) begin
        if (rst) begin prs_st <= 3'b000; end
        else begin prs_st <= next_st; end
    end

    assign F = prs_st[2] & prs_st[0];

endmodule
