module instruction_register (
    input clk,
    input rst_n,
    input [19:0] data_in,
    output reg [3:0] opcode,
    output reg [15:0] operand
);
    always @(posedge clk) begin
        if (!rst_n) begin
            opcode <= 4'd0;
            operand <= 16'd0;
        end else begin
            opcode <= data_in[19:16];
            operand <= data_in[15:0];
        end
    end
endmodule