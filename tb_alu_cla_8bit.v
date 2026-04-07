// ============================================================
// Testbench : tb_alu_cla_8bit
// Description : Simulation testbench for 8-bit CLA ALU
//               Tests IDENTICAL to RCA for direct comparison
// ============================================================
`timescale 1ns / 1ps

module tb_alu_cla_8bit;

    reg  [7:0] A, B;
    reg  [2:0] opcode;
    wire [7:0] result;
    wire       carry_out, zero_flag, overflow_flag;

    alu_cla_8bit dut (
        .A            (A),
        .B            (B),
        .opcode       (opcode),
        .result       (result),
        .carry_out    (carry_out),
        .zero_flag    (zero_flag),
        .overflow_flag(overflow_flag)
    );

    task print_result;
        input [7:0]  a_in, b_in;
        input [2:0]  op;
        input [7:0]  exp_result;
        input        exp_cout;
        reg   [63:0] op_name;
        begin
            case (op)
                3'b000: op_name = "ADD ";
                3'b001: op_name = "SUB ";
                3'b010: op_name = "AND ";
                3'b011: op_name = "OR  ";
                3'b100: op_name = "XOR ";
                3'b101: op_name = "NOT ";
                3'b110: op_name = "SHL ";
                3'b111: op_name = "SHR ";
            endcase
            $display("[%s] A=%3d B=%3d | result=%3d (exp=%3d) | Cout=%b | Zero=%b | OVF=%b | %s",
                op_name, a_in, b_in, result, exp_result, carry_out, zero_flag, overflow_flag,
                (result === exp_result && carry_out === exp_cout) ? "PASS" : "FAIL <<<");
        end
    endtask

    integer i;

    initial begin
        $display("=== 8-bit CLA ALU Testbench ===");

        // ADD
        A=8'd10;  B=8'd20;  opcode=3'b000; #10; print_result(A,B,opcode,8'd30,  1'b0);
        A=8'd200; B=8'd100; opcode=3'b000; #10; print_result(A,B,opcode,8'd44,  1'b1);
        A=8'd0;   B=8'd0;   opcode=3'b000; #10; print_result(A,B,opcode,8'd0,   1'b0);
        A=8'd255; B=8'd1;   opcode=3'b000; #10; print_result(A,B,opcode,8'd0,   1'b1);

        // SUB
        A=8'd50;  B=8'd30;  opcode=3'b001; #10; print_result(A,B,opcode,8'd20,  1'b1);
        A=8'd30;  B=8'd50;  opcode=3'b001; #10; print_result(A,B,opcode,8'd236, 1'b0);
        A=8'd100; B=8'd100; opcode=3'b001; #10; print_result(A,B,opcode,8'd0,   1'b1);

        // AND
        A=8'hAA;  B=8'hF0;  opcode=3'b010; #10; print_result(A,B,opcode,8'hA0, 1'b0);
        A=8'h0F;  B=8'hF0;  opcode=3'b010; #10; print_result(A,B,opcode,8'h00, 1'b0);

        // OR
        A=8'hAA;  B=8'h55;  opcode=3'b011; #10; print_result(A,B,opcode,8'hFF, 1'b0);
        A=8'h00;  B=8'h00;  opcode=3'b011; #10; print_result(A,B,opcode,8'h00, 1'b0);

        // XOR
        A=8'hFF;  B=8'hFF;  opcode=3'b100; #10; print_result(A,B,opcode,8'h00, 1'b0);
        A=8'hAA;  B=8'h55;  opcode=3'b100; #10; print_result(A,B,opcode,8'hFF, 1'b0);

        // NOT
        A=8'h00;  B=8'hXX;  opcode=3'b101; #10; print_result(A,B,opcode,8'hFF, 1'b0);
        A=8'hFF;  B=8'hXX;  opcode=3'b101; #10; print_result(A,B,opcode,8'h00, 1'b0);

        // SHL
        A=8'b00000001; B=8'hXX; opcode=3'b110; #10; print_result(A,B,opcode,8'b00000010, 1'b0);
        A=8'b10000001; B=8'hXX; opcode=3'b110; #10; print_result(A,B,opcode,8'b00000010, 1'b1);

        // SHR
        A=8'b10000000; B=8'hXX; opcode=3'b111; #10; print_result(A,B,opcode,8'b01000000, 1'b0);
        A=8'b10000001; B=8'hXX; opcode=3'b111; #10; print_result(A,B,opcode,8'b01000000, 1'b1);

        $display("\n--- Stress Test (ADD) ---");
        for (i = 0; i < 16; i = i + 1) begin
            A = $random; B = $random; opcode = 3'b000; #10;
            $display("A=%3d + B=%3d = %3d (Cout=%b)", A, B, result, carry_out);
        end

        $display("\n=== Testbench Complete ===");
        $finish;
    end

    initial begin
        $dumpfile("tb_alu_cla_8bit.vcd");
        $dumpvars(0, tb_alu_cla_8bit);
    end

endmodule
