module reg_b (
    input clk,
    input rst_n,
    input load,
    input signed [15:0] data_in,
    output reg signed [15:0] data_out
);
    always @(posedge clk) begin
        if (!rst_n)
            data_out <= 0;
        else if (load)
            data_out <= data_in;
    end
endmodule