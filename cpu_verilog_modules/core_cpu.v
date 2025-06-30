module core_cpu (
    input         clk,
    input         rst_n,
    input  [19:0] data_in,
    output [7:0]  data_out,
    output        flag_carry,
    output        flag_sign,
    output        flag_overflow
);

    wire [3:0]  opcode;
    wire [15:0] operand;
    wire signed [15:0] reg_a_out, reg_b_out, alu_result, reg_c_out;
    wire load_reg_a, load_reg_b, load_reg_c;
    wire carry, sign, overflow;

    instruction_register u_instruction_register (
        .clk(clk), .rst_n(rst_n), .data_in(data_in),
        .opcode(opcode), .operand(operand)
    );

    controller u_controller (
        .opcode(opcode), .load_reg_a(load_reg_a),
        .load_reg_b(load_reg_b), .load_reg_c(load_reg_c)
    );

    reg_a u_reg_a (
        .clk(clk), .rst_n(rst_n), .load(load_reg_a),
        .data_in(operand), .data_out(reg_a_out)
    );

    reg_b u_reg_b (
        .clk(clk), .rst_n(rst_n), .load(load_reg_b),
        .data_in(operand), .data_out(reg_b_out)
    );

    reg_c u_reg_c (
        .clk(clk), .rst_n(rst_n), .load(load_reg_c),
        .data_in(alu_result), .data_out(reg_c_out)
    );

    alu u_alu (
        .clk(clk), .rst(~rst_n), .opcode(opcode),
        .a(reg_a_out), .b(reg_b_out),
        .result(alu_result), .carry(carry),
        .sign(sign), .overflow(overflow)
    );

    assign data_out = reg_c_out[7:0];
    assign flag_carry = carry;
    assign flag_sign = sign;
    assign flag_overflow = overflow;

endmodule