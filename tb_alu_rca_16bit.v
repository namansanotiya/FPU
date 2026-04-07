// ============================================================
// Testbench : tb_alu_rca_16bit
// Description : Simulation testbench for 16-bit RCA ALU
// ============================================================
`timescale 1ns / 1ps

module tb_alu_rca_16bit;

    reg  [15:0] A, B;
    reg  [2:0]  opcode;
    wire [15:0] result;
    wire        carry_out, zero_flag, overflow_flag;

    alu_rca_16bit dut (
        .A            (A),
        .B            (B),
        .opcode       (opcode),
        .result       (result),
        .carry_out    (carry_out),
        .zero_flag    (zero_flag),
        .overflow_flag(overflow_flag)
    );

    integer i;

    initial begin
        $display("=== 16-bit RCA ALU Testbench ===");

        // ADD
        A=16'd1000;  B=16'd2000;  opcode=3'b000; #10;
        $display("[ADD] %5d + %5d = %5d | Cout=%b Zero=%b OVF=%b",A,B,result,carry_out,zero_flag,overflow_flag);

        A=16'd65535; B=16'd1;     opcode=3'b000; #10;
        $display("[ADD] %5d + %5d = %5d | Cout=%b Zero=%b OVF=%b",A,B,result,carry_out,zero_flag,overflow_flag);

        A=16'd0;     B=16'd0;     opcode=3'b000; #10;
        $display("[ADD] %5d + %5d = %5d | Cout=%b Zero=%b OVF=%b",A,B,result,carry_out,zero_flag,overflow_flag);

        // SUB
        A=16'd5000;  B=16'd3000;  opcode=3'b001; #10;
        $display("[SUB] %5d - %5d = %5d | Cout=%b Zero=%b OVF=%b",A,B,result,carry_out,zero_flag,overflow_flag);

        A=16'd100;   B=16'd200;   opcode=3'b001; #10;
        $display("[SUB] %5d - %5d = %5d | Cout=%b Zero=%b OVF=%b",A,B,result,carry_out,zero_flag,overflow_flag);

        // AND
        A=16'hAAAA;  B=16'hF0F0;  opcode=3'b010; #10;
        $display("[AND] %4h & %4h = %4h | Zero=%b",A,B,result,zero_flag);

        // OR
        A=16'hAAAA;  B=16'h5555;  opcode=3'b011; #10;
        $display("[OR ] %4h | %4h = %4h | Zero=%b",A,B,result,zero_flag);

        // XOR
        A=16'hFFFF;  B=16'hFFFF;  opcode=3'b100; #10;
        $display("[XOR] %4h ^ %4h = %4h | Zero=%b",A,B,result,zero_flag);

        // NOT
        A=16'h0000;  B=16'hXXXX;  opcode=3'b101; #10;
        $display("[NOT] ~%4h = %4h | Zero=%b",A,result,zero_flag);

        // SHL
        A=16'b1000000000000001; B=16'hXXXX; opcode=3'b110; #10;
        $display("[SHL] %4h << 1 = %4h | Cout=%b",A,result,carry_out);

        // SHR
        A=16'b1000000000000001; B=16'hXXXX; opcode=3'b111; #10;
        $display("[SHR] %4h >> 1 = %4h | Cout=%b",A,result,carry_out);

        // Stress
        $display("\n--- Stress Test (16-bit ADD) ---");
        for (i = 0; i < 16; i = i + 1) begin
            A = {$random} % 16'hFFFF; B = {$random} % 16'hFFFF; opcode = 3'b000; #10;
            $display("A=%5d + B=%5d = %5d (Cout=%b)", A, B, result, carry_out);
        end

        $display("\n=== Testbench Complete ===");
        $finish;
    end

    initial begin
        $dumpfile("tb_alu_rca_16bit.vcd");
        $dumpvars(0, tb_alu_rca_16bit);
    end

endmodule
