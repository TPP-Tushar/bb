module top_wrapper (
    input  [15:0] data_in_from_pad,
    input         clk_from_pad,
    input         rst_n_from_pad,
    input  [3:0]  bidir_inputs_from_pad,

    output [15:0] pu_data_in,
    output [15:0] pd_data_in,
    output        pu_clk,
    output        pd_clk,
    output        pu_rst_n,
    output        pd_rst_n,

    output [14:0] oe_bidir,
    output [14:0] ie_bidir,
    output [14:0] pu_bidir,
    output [14:0] pd_bidir,

    output [10:0] bidir_output_data
);

    wire [15:0] pad_data_in     = data_in_from_pad;
    wire        pad_clk         = clk_from_pad;
    wire        pad_rst_n       = rst_n_from_pad;
    wire [3:0]  bidir_inputs    = bidir_inputs_from_pad;
    wire [10:0] bidir_outputs;

    assign pu_data_in   = 16'b0;
    assign pd_data_in   = 16'b0;
    assign pu_clk       = 1'b0;
    assign pd_clk       = 1'b0;
    assign pu_rst_n     = 1'b0;
    assign pd_rst_n     = 1'b0;

    assign pu_bidir     = 15'b0;
    assign pd_bidir     = 15'b0;

    assign ie_bidir[3:0]   = 4'b1111;
    assign oe_bidir[3:0]   = 4'b0000;
    assign ie_bidir[14:4]  = 11'b00000000000;
    assign oe_bidir[14:4]  = 11'b11111111111;

    top_rtl u_top_rtl (
        .pad_data_in           (pad_data_in),
        .pad_clk               (pad_clk),
        .pad_rst_n             (pad_rst_n),
        .bidir_inputs_from_pad (bidir_inputs),
        .bidir_output_data     (bidir_outputs)
    );

    assign bidir_output_data = bidir_outputs;
endmodule