`timescale 1ns / 1ps

// ================= ALU Submodule: Arithmetic =================
module alu_arithmetic (
    input signed [15:0] a,
    input signed [15:0] b,
    input [3:0] opcode,
    output reg signed [15:0] result,
    output reg carry,
    output reg overflow
);
    reg signed [15:0] temp;
    always @(*) begin
        result = 0;
        carry = 0;
        overflow = 0;

        case (opcode)
            4'b0100: begin // ADD
                temp = a + b;
                result = temp;
                overflow = (~a[15] & ~b[15] & temp[15]) | (a[15] & b[15] & ~temp[15]);
            end
            4'b0101: begin // SUB
                temp = a - b;
                result = temp;
                overflow = (a[15] & ~b[15] & ~temp[15]) | (~a[15] & b[15] & temp[15]);
            end
        endcase
    end
endmodule

// ================= ALU Submodule: Logical =================
module alu_logical (
    input signed [15:0] a,
    input signed [15:0] b,
    input [3:0] opcode,
    output reg signed [15:0] result
);
    always @(*) begin
        case (opcode)
            4'b1000: result = a & b;
            4'b1001: result = a | b;
            4'b1010: result = ~(a & b);
            4'b1011: result = ~(a | b);
            4'b1100: result = ~a;
            4'b1101: result = a ^ b;
            default: result = 0;
        endcase
    end
endmodule

// ================= ALU Submodule: Shift =================
module alu_shift (
    input signed [15:0] a,
    input [3:0] opcode,
    output reg signed [15:0] result,
    output reg carry_out
);
    always @(*) begin
        carry_out = 0;
        case (opcode)
            4'b0110: begin // SHL
                carry_out = a[15];
                result = a <<< 1;
            end
            4'b0111: begin // SHR
                carry_out = a[0];
                result = a >>> 1;
            end
            default: result = 0;
        endcase
    end
endmodule

// ================= ALU Top =================
module alu (
    input clk,
    input rst_n,
    input [3:0] opcode,
    input signed [15:0] a,
    input signed [15:0] b,
    output reg signed [15:0] result,
    output reg carry,
    output reg sign,
    output reg overflow
);
    wire signed [15:0] arith_result, logic_result, shift_result;
    wire arith_carry, arith_overflow, shift_carry;

    alu_arithmetic u_arith (
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(arith_result),
        .carry(arith_carry),
        .overflow(arith_overflow)
    );

    alu_logical u_logic (
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(logic_result)
    );

    alu_shift u_shift (
        .a(a),
        .opcode(opcode),
        .result(shift_result),
        .carry_out(shift_carry)
    );

    always @(posedge clk) begin
        if (!rst_n) begin
            result   <= 0;
            carry    <= 0;
            sign     <= 0;
            overflow <= 0;
        end else begin
            case (opcode)
                4'b0100, 4'b0101: begin
                    result   <= arith_result;
                    carry    <= arith_carry;
                    overflow <= arith_overflow;
                end
                4'b0110, 4'b0111: begin
                    result   <= shift_result;
                    carry    <= shift_carry;
                    overflow <= 0;
                end
                4'b1000, 4'b1001, 4'b1010, 4'b1011, 4'b1100, 4'b1101: begin
                    result   <= logic_result;
                    carry    <= 0;
                    overflow <= 0;
                end
                default: begin
                    result   <= 0;
                    carry    <= 0;
                    overflow <= 0;
                end
            endcase
            sign <= result[15];
        end
    end
endmodule

// ================= Instruction Register =================
module instruction_register (
    input clk,
    input rst_n,
    input [19:0] data_in,
    output reg [3:0] opcode,
    output reg signed [15:0] operand
);
    always @(posedge clk) begin
        if (!rst_n) begin
            opcode <= 0;
            operand <= 0;
        end else begin
            opcode <= data_in[19:16];
            operand <= data_in[15:0];
        end
    end
endmodule

// ================= Controller =================
module controller (
    input [3:0] opcode,
    output reg load_reg_a,
    output reg load_reg_b,
    output reg load_reg_c
);
    always @(*) begin
        load_reg_a = 0;
        load_reg_b = 0;
        load_reg_c = 0;
        case (opcode)
            4'b0001: load_reg_a = 1;
            4'b0010: load_reg_b = 1;
            4'b0100, 4'b0101, 4'b0110, 4'b0111,
            4'b1000, 4'b1001, 4'b1010, 4'b1011,
            4'b1100, 4'b1101: load_reg_c = 1;
        endcase
    end
endmodule

// ================= Registers =================
module reg_a (
    input clk,
    input rst_n,
    input load,
    input signed [15:0] data_in,
    output reg signed [15:0] data_out
);
    always @(posedge clk) begin
        if (!rst_n) data_out <= 0;
        else if (load) data_out <= data_in;
    end
endmodule

module reg_b (
    input clk,
    input rst_n,
    input load,
    input signed [15:0] data_in,
    output reg signed [15:0] data_out
);
    always @(posedge clk) begin
        if (!rst_n) data_out <= 0;
        else if (load) data_out <= data_in;
    end
endmodule

module reg_c (
    input clk,
    input rst_n,
    input load,
    input signed [15:0] data_in,
    output reg signed [15:0] data_out
);
    always @(posedge clk) begin
        if (!rst_n) data_out <= 0;
        else if (load) data_out <= data_in;
    end
endmodule

// ================= Core CPU =================
module core_cpu (
    input         clk,
    input         rst_n,
    input  [19:0] data_in,
    output [7:0]  data_out,
    output        flag_carry,
    output        flag_sign,
    output        flag_overflow
);
    wire [3:0] opcode;
    wire signed [15:0] operand;
    wire signed [15:0] reg_a_out, reg_b_out, alu_result, reg_c_out;
    wire load_reg_a, load_reg_b, load_reg_c;

    instruction_register u_instruction_register (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .opcode(opcode),
        .operand(operand)
    );

    controller u_controller (
        .opcode(opcode),
        .load_reg_a(load_reg_a),
        .load_reg_b(load_reg_b),
        .load_reg_c(load_reg_c)
    );

    reg_a u_reg_a (
        .clk(clk),
        .rst_n(rst_n),
        .load(load_reg_a),
        .data_in(operand),
        .data_out(reg_a_out)
    );

    reg_b u_reg_b (
        .clk(clk),
        .rst_n(rst_n),
        .load(load_reg_b),
        .data_in(operand),
        .data_out(reg_b_out)
    );

    reg_c u_reg_c (
        .clk(clk),
        .rst_n(rst_n),
        .load(load_reg_c),
        .data_in(alu_result),
        .data_out(reg_c_out)
    );

    assign data_out = reg_c_out[7:0];

    alu u_alu (
        .clk(clk),
        .rst_n(rst_n),
        .opcode(opcode),
        .a(reg_a_out),
        .b(reg_b_out),
        .result(alu_result),
        .carry(flag_carry),
        .sign(flag_sign),
        .overflow(flag_overflow)
    );
endmodule

module tb_core_cpu;
    reg clk;
    reg rst_n;
    reg [19:0] data_in;
    wire [7:0] data_out;
    wire flag_carry, flag_sign, flag_overflow;

    core_cpu uut (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .data_out(data_out),
        .flag_carry(flag_carry),
        .flag_sign(flag_sign),
        .flag_overflow(flag_overflow)
    );

    // Clock generation
    always #5 clk = ~clk;

    function string bin16;
        input [15:0] val;
        begin
            bin16 = $sformatf("%04b_%04b_%04b_%04b",
                val[15:12], val[11:8], val[7:4], val[3:0]);
        end
    endfunction

task execute_and_display;
    input [19:0] instr;
    input string note;
    begin
        @(posedge clk); // let clock advance
        data_in = instr;

        @(posedge clk); // latch instruction
        @(posedge clk); // execute
        #1;

        $display("| %4t | %4b | %6d/%s | %6d/%s | %6d/%s | %6d/%s | %b %b %b | %s |",
            $time,
            instr[19:16],
            $signed(instr[15:0]), bin16(instr[15:0]),
            $signed(uut.u_reg_a.data_out), bin16(uut.u_reg_a.data_out),
            $signed(uut.u_reg_b.data_out), bin16(uut.u_reg_b.data_out),
            $signed(uut.u_reg_c.data_out), bin16(uut.u_reg_c.data_out),
            flag_carry, flag_sign, flag_overflow,
            note);

        // Small delay to show different timestamps
        #10;
    end
endtask

    initial begin
        clk = 0;
        rst_n = 0;
        data_in = 0;

        $display("\n");
        $display("==============================================================================================");
        $display("|Time| Op  | Operand (Dec/Bin) |   REG_A (Dec/Bin) |   REG_B (Dec/Bin) | RESULT (Dec/Bin) | C S O | Note |");
        $display("----------------------------------------------------------------------------------------------");

        // Reset
        #5 rst_n = 1;
        @(posedge clk);  // Wait one clock cycle after reset

        // === Arithmetic ===
        execute_and_display({4'b0001, 16'd10}, "LD A");
        execute_and_display({4'b0010, 16'd5},  "LD B");
        execute_and_display({4'b0100, 16'd0},  "ADD");
        execute_and_display({4'b0101, 16'd0},  "SUB");

        // === Overflow ===
        execute_and_display({4'b0001, 16'h7FFF}, "LD A");
        execute_and_display({4'b0010, 16'd1},    "LD B");
        execute_and_display({4'b0100, 16'd0},    "ADD (Overflow)");

        // === Negative Arithmetic ===
        execute_and_display({4'b0001, -16'sd3}, "LD A");
        execute_and_display({4'b0010, -16'sd5}, "LD B");
        execute_and_display({4'b0100, 16'd0},   "ADD");

        // === Logical ===
        execute_and_display({4'b0001, 16'h00FF}, "LD A");
        execute_and_display({4'b0010, 16'hFF00}, "LD B");
        execute_and_display({4'b1000, 16'd0},    "AND");
        execute_and_display({4'b1001, 16'd0},    "OR");
        execute_and_display({4'b1010, 16'd0},    "NAND");
        execute_and_display({4'b1011, 16'd0},    "NOR");
        execute_and_display({4'b1100, 16'd0},    "NOT A");
        execute_and_display({4'b1101, 16'd0},    "XOR");

        // === Shift ===
        execute_and_display({4'b0001, 16'b0000_0000_0000_1010}, "LD A");  // 10
        execute_and_display({4'b0110, 16'd0}, "SHL");  // 10 << 1 = 20
        execute_and_display({4'b0111, 16'd0}, "SHR");  // 20 >>> 1 = 10

        $display("==============================================================================================");
        $finish;
    end
endmodule
