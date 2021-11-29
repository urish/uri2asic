`default_nettype none
`timescale 1ns/1ns
module encoder (
    input clk,
    input reset,
    input a,
    input b,
    output reg [7:0] value
);

reg old_a;
reg old_b;

wire [3:0] inputs = {a, old_a, b, old_b};
reg [7:0] delta;

always @(*) begin
    case (inputs)
        4'b1000,
        4'b0111: delta <= 8'd1;
        4'b0010,
        4'b1101: delta <= 8'd255;
        default: delta <= 0;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        old_a <= 0;
        old_b <= 0;
        value <= 0;
    end else begin
        value <= value + delta;
        old_a <= a;
        old_b <= b;
    end
end

endmodule
