// ============================================================
// Module : rca_16bit
// Description : 16-bit Ripple Carry Adder
// ============================================================
module rca_16bit (
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] Sum,
    output        Cout
);

    wire [16:0] carry;
    assign carry[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : fa_stage
            full_adder fa (
                .a    (A[i]),
                .b    (B[i]),
                .cin  (carry[i]),
                .sum  (Sum[i]),
                .cout (carry[i+1])
            );
        end
    endgenerate

    assign Cout = carry[16];

endmodule
