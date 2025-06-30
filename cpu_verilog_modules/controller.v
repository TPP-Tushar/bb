module controller (
    input  [3:0] opcode,
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
            4'b0011: load_reg_c = 1;
            default: ;
        endcase
    end
endmodule