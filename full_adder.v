// ============================================================
// Module : full_adder
// Description : 1-bit Full Adder (primitive for RCA and CLA)
// ============================================================
module full_adder (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);

    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);

endmodule
