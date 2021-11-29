`default_nettype none
`timescale 1ns/1ps
module frequency_counter #(
    // If a module starts with #() then it is parametisable. It can be instantiated with different settings
    // for the localparams defined here. So the default is an UPDATE_PERIOD of 1200 and BITS = 12
    localparam UPDATE_PERIOD = 1200,
    localparam BITS = 12
)(
    input wire              clk,
    input wire              reset,
    input wire              signal,

    input wire [BITS-1:0]   period,
    input wire              period_load,

    output wire [6:0]       segments,
    output wire             digit
    );

    // states
    localparam STATE_COUNT  = 0;
    localparam STATE_TENS   = 1;
    localparam STATE_UNITS  = 2;

    wire leading_edge_detect;

    reg [2:0] state = STATE_COUNT;
    reg [BITS-1:0] update_period;
    reg [BITS-1:0] cycles;
    reg [BITS-1:0] edges;
    reg [3:0] ten_count;
    
    edge_detect edge_detect0 (
        .clk(clk), 
        .signal(signal), 
        .leading_edge_detect(leading_edge_detect)
    );

    seven_segment seven_segment1 (
        .clk(clk),
        .reset(reset),
        .load(state == STATE_UNITS),
        .ten_count(ten_count),
        .unit_count(edges[3:0]),
        .segments(segments),
        .digit(digit)
    );

    always @(posedge clk) begin
        if(reset) begin
            update_period <= UPDATE_PERIOD;
        end else if (period_load) begin
            update_period <= period;
        end
    end;

    always @(posedge clk) begin
        if(reset) begin
            state <= STATE_COUNT;
            cycles <= 0;
            ten_count <= 0;
            edges <= 0;
        end else begin
            case(state)
                STATE_COUNT: begin
                    cycles <= cycles + 1;
                    if (leading_edge_detect == 1) begin
                        edges <= edges + 1;
                    end
                    if (cycles == update_period) begin
                        state <= STATE_TENS;
                    end
                end

                STATE_TENS: begin
                    if (edges > 9) begin
                        ten_count <= ten_count + 1;
                        edges <= edges - 10;
                    end else begin
                        state <= STATE_UNITS;
                    end
                end

                STATE_UNITS: begin
                    edges <= 0;
                    cycles <= 0;
                    ten_count <= 0;
                    state <= STATE_COUNT;
                end

                default:
                    state           <= STATE_COUNT;

            endcase
        end
    end

endmodule
