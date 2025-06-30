module alu_arithmetic (
    input clk,
    input rst,
    input [3:0] opcode,
    input signed [15:0] a,
    input signed [15:0] b,
    output reg signed [15:0] out,
    output reg carry,
    output reg overflow,
    output reg sign
);
    reg signed [15:0] tmp_out;
    reg tmp_carry;

    always @(posedge clk) begin
        if (rst) begin out <= 0; carry <= 0; overflow <= 0; sign <= 0; end
        else begin
            {tmp_carry, tmp_out} = 0;
            case (opcode)
                4'b0100: begin {tmp_carry, tmp_out} = a + b;
                    overflow <= (~a[15] & ~b[15] & tmp_out[15]) | (a[15] & b[15] & ~tmp_out[15]); end
                4'b0101: begin {tmp_carry, tmp_out} = a - b;
                    overflow <= (a[15] & ~b[15] & ~tmp_out[15]) | (~a[15] & b[15] & tmp_out[15]); end
            endcase
            out <= tmp_out;
            sign <= tmp_out[15];
            carry <= tmp_out[15] ? 0 : tmp_carry;
        end
    end
endmodule