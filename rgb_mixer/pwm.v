`default_nettype none
`timescale 1ns/1ns
module pwm 
#(parameter WIDTH = 8, parameter INVERT = 1'b0) (
    input wire clk,
    input wire reset,
    output wire out,
    input wire [WIDTH-1:0] level
    );

reg [WIDTH-1:0]count;

assign out = INVERT ^ (!reset & (count < level));

always @(posedge clk) begin
    if (reset) begin
        count <= 0;
    end else begin
        count = count + 1;
    end
end

endmodule
