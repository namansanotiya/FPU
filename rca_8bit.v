// ============================================================
// Module : rca_8bit
// Description : 8-bit Ripple Carry Adder
// ============================================================
module rca_8bit (
    input  [7:0] A,
    input  [7:0] B,
    input        Cin,
    output [7:0] Sum,
    output       Cout
);

    wire [8:0] carry;
    assign carry[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : fa_stage
            full_adder fa (
                .a    (A[i]),
                .b    (B[i]),
                .cin  (carry[i]),
                .sum  (Sum[i]),
                .cout (carry[i+1])
            );
        end
    endgenerate

    assign Cout = carry[8];

endmodule
