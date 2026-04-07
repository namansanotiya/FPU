// ============================================================
// Module : cla_16bit
// Description : 16-bit Carry Lookahead Adder
//               Built from four 4-bit CLA blocks with inter-block CLA
// ============================================================
module cla_16bit (
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] Sum,
    output        Cout
);

    wire c4, c8, c12;
    wire pg0, gg0, pg1, gg1, pg2, gg2, pg3, gg3;

    // Block 0: bits [3:0]
    cla_4bit block0 (
        .A   (A[3:0]),
        .B   (B[3:0]),
        .Cin (Cin),
        .Sum (Sum[3:0]),
        .Cout(),
        .PG  (pg0),
        .GG  (gg0)
    );

    // Block 1: bits [7:4]
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

    // Block 2: bits [11:8]
    assign c8 = gg1 | (pg1 & gg0) | (pg1 & pg0 & Cin);

    cla_4bit block2 (
        .A   (A[11:8]),
        .B   (B[11:8]),
        .Cin (c8),
        .Sum (Sum[11:8]),
        .Cout(),
        .PG  (pg2),
        .GG  (gg2)
    );

    // Block 3: bits [15:12]
    assign c12 = gg2 | (pg2 & gg1) | (pg2 & pg1 & gg0) | (pg2 & pg1 & pg0 & Cin);

    cla_4bit block3 (
        .A   (A[15:12]),
        .B   (B[15:12]),
        .Cin (c12),
        .Sum (Sum[15:12]),
        .Cout(),
        .PG  (pg3),
        .GG  (gg3)
    );

    assign Cout = gg3 | (pg3 & gg2) | (pg3 & pg2 & gg1) | (pg3 & pg2 & pg1 & gg0)
                      | (pg3 & pg2 & pg1 & pg0 & Cin);

endmodule
