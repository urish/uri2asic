`default_nettype none
`timescale 1ns/1ns
module debounce 
#(parameter BITS = 3) (
    input wire clk,
    input wire reset,
    input wire button,
    output reg debounced
);

reg [BITS-1:0]counter;
reg prev_input;

always @(posedge clk) begin
    if (reset) begin
        counter <= 0;
        debounced <= 0;
        prev_input <= 0;
    end else if (prev_input != button) begin
        counter <= 0;
        prev_input <= button;
    end else if (counter != (1 << BITS) - 1) begin
        counter <= counter + 1;
    end else begin
        debounced = prev_input;
    end
end

endmodule
