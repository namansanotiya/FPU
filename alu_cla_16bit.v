// ============================================================
// Module : alu_cla_16bit
// Description : 16-bit ALU using Carry Lookahead Adder
//
// ALU Operations (opcode):
//   3'b000 : ADD   (A + B)
//   3'b001 : SUB   (A - B)
//   3'b010 : AND   (A & B)
//   3'b011 : OR    (A | B)
//   3'b100 : XOR   (A ^ B)
//   3'b101 : NOT   (~A)
//   3'b110 : SHL   (A << 1)
//   3'b111 : SHR   (A >> 1)
// ============================================================
module alu_cla_16bit (
    input  [15:0] A,
    input  [15:0] B,
    input  [2:0]  opcode,
    output reg [15:0] result,
    output reg        carry_out,
    output            zero_flag,
    output            overflow_flag
);

    wire [15:0] sum_result, sub_result;
    wire        sum_cout, sub_cout;
    wire [15:0] b_inv = ~B;

    // ADD
    cla_16bit adder (
        .A   (A),
        .B   (B),
        .Cin (1'b0),
        .Sum (sum_result),
        .Cout(sum_cout)
    );

    // SUB via A + (~B) + 1
    cla_16bit subtractor (
        .A   (A),
        .B   (b_inv),
        .Cin (1'b1),
        .Sum (sub_result),
        .Cout(sub_cout)
    );

    always @(*) begin
        carry_out = 1'b0;
        case (opcode)
            3'b000: begin result = sum_result; carry_out = sum_cout; end
            3'b001: begin result = sub_result; carry_out = sub_cout; end
            3'b010: begin result = A & B;      end
            3'b011: begin result = A | B;      end
            3'b100: begin result = A ^ B;      end
            3'b101: begin result = ~A;         end
            3'b110: begin result = A << 1;     carry_out = A[15]; end
            3'b111: begin result = A >> 1;     carry_out = A[0];  end
            default: begin result = 16'b0;     end
        endcase
    end

    assign zero_flag     = (result == 16'b0);
    assign overflow_flag = (opcode == 3'b000) ? (~A[15] & ~B[15] &  result[15]) |
                                                  ( A[15] &  B[15] & ~result[15])
                         : (opcode == 3'b001) ? (~A[15] &  B[15] &  result[15]) |
                                                  ( A[15] & ~B[15] & ~result[15])
                         : 1'b0;

endmodule
