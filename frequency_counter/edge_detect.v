`default_nettype none
`timescale 1ns/1ps
module edge_detect (
    input wire              clk,
    input wire              signal,
    output wire             leading_edge_detect
    );

reg q0;
reg q1;
reg q2;
wire edge_detect = q1 ^ q2;
assign leading_edge_detect = q1 & (edge_detect);

always @(posedge clk) begin
    q0 <= signal;
    q1 <= q0;
    q2 <= q1;
end

endmodule
