// ============================================================
// Module : cla_8bit
// Description : 8-bit Carry Lookahead Adder
//               Built from two 4-bit CLA blocks with inter-block CLA
// ============================================================
module cla_8bit (
    input  [7:0] A,
    input  [7:0] B,
    input        Cin,
    output [7:0] Sum,
    output       Cout
);

    wire c4;
    wire pg0, gg0, pg1, gg1;

    cla_4bit block0 (
        .A   (A[3:0]),
        .B   (B[3:0]),
        .Cin (Cin),
        .Sum (Sum[3:0]),
        .Cout(),
        .PG  (pg0),
        .GG  (gg0)
    );

    // Inter-block carry
    assign c4 = gg0 | (pg0 & Cin);

    cla_4bit block1 (
        .A   (A[7:4]),
        .B   (B[7:4]),
        .Cin (c4),
        .Sum (Sum[7:4]),
        .Cout(),
        .PG  (pg1),
        .GG  (gg1)
    );

    assign Cout = gg1 | (pg1 & c4);

endmodule
