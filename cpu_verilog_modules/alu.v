module alu (
    input clk,
    input rst,
    input [3:0] opcode,
    input signed [15:0] a,
    input signed [15:0] b,
    output reg signed [15:0] result,
    output reg carry,
    output reg sign,
    output reg overflow
);

    wire signed [15:0] arithmetic_out, logical_out, shift_out;
    wire ac, ao, as;

    alu_arithmetic u_arith (.clk(clk), .rst(rst), .opcode(opcode), .a(a), .b(b), .out(arithmetic_out), .carry(ac), .overflow(ao), .sign(as));
    alu_logical    u_logic (.clk(clk), .rst(rst), .opcode(opcode), .a(a), .b(b), .out(logical_out));
    alu_shift      u_shift (.clk(clk), .rst(rst), .opcode(opcode), .a(a), .out(shift_out));

    always @(posedge clk) begin
        if (rst) begin
            result <= 0; carry <= 0; sign <= 0; overflow <= 0;
        end else begin
            case (opcode)
                4'b0100, 4'b0101: begin result <= arithmetic_out; carry <= ac; sign <= as; overflow <= ao; end
                4'b0110, 4'b0111: begin result <= shift_out; sign <= shift_out[15]; carry <= 0; overflow <= 0; end
                default: begin result <= logical_out; sign <= logical_out[15]; carry <= 0; overflow <= 0; end
            endcase
        end
    end
endmodule