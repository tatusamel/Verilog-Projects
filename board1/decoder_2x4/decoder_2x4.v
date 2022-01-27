module decoder_2x4(input[1:0] A,output[3:0] D);

    assign D[0] = ~A[1] & ~A[0];
    assign D[1] = ~A[1] & A[0];
    assign D[2] = A[1] & ~A[0];
    assign D[3] = A[1] & A[0];
    
endmodule