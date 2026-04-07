// ============================================================
// Module : cla_4bit
// Description : 4-bit Carry Lookahead Adder block
//               Computes P, G per bit; resolves carries in parallel
// ============================================================
module cla_4bit (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout,
    output       PG,    // Group Propagate
    output       GG     // Group Generate
);

    wire [3:0] p, g;
    wire [4:0] c;

    // Bit-level Propagate and Generate
    assign p = A ^ B;
    assign g = A & B;

    // Carry lookahead logic
    assign c[0] = Cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0])
                       | (p[3] & p[2] & p[1] & p[0] & c[0]);

    assign Sum  = p ^ c[3:0];
    assign Cout = c[4];

    // Group signals for cascading
    assign PG = p[3] & p[2] & p[1] & p[0];
    assign GG = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);

endmodule
