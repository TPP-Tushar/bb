module top_rtl (
    input  [15:0] pad_data_in,
    input         pad_clk,
    input         pad_rst_n,
    input  [3:0]  bidir_inputs_from_pad,
    output [10:0] bidir_output_data
);
    wire [19:0] full_instruction = {bidir_inputs_from_pad, pad_data_in};
    wire [7:0] data_out;
    wire flag_carry, flag_sign, flag_overflow;

    core_cpu u_core_cpu (
        .clk(pad_clk),
        .rst_n(pad_rst_n),
        .data_in(full_instruction),
        .data_out(data_out),
        .flag_carry(flag_carry),
        .flag_sign(flag_sign),
        .flag_overflow(flag_overflow)
    );

    assign bidir_output_data = {flag_carry, flag_sign, flag_overflow, 5'b00000, data_out[2:0]};
endmodule