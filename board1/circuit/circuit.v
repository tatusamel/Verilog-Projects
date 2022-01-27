`include "mux_4x1.v"
`include "decoder_2x4.v"

module circuit( input a, input b, input c, input d, output F);
    wire [3:0] out;
    wire [1:0] x;
    wire [1:0] y;

    assign x = {a,b};
    assign y = {c,d};

    decoder_2x4 DC(.A(x) , .D(out));
    mux_4x1 MX( .i(out), .s(y) ,.F(F));

endmodule