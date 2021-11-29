`default_nettype none
`timescale 1ns/1ns
module rgb_mixer (
    input clk,
    input reset,
    input enc0_a,
    input enc0_b,
    input enc1_a,
    input enc1_b,
    input enc2_a,
    input enc2_b,
    output pwm0_out,
    output pwm1_out,
    output pwm2_out
);

genvar j;
wire [2:0]enc_a = {enc2_a, enc1_a, enc0_a};
wire [2:0]enc_b = {enc2_b, enc1_b, enc0_b};
wire [2:0]de_enc_a;
wire [2:0]de_enc_b;
wire [7:0]enc[2:0];
wire [7:0]enc0 = enc[0];
wire [7:0]enc1 = enc[1];
wire [7:0]enc2 = enc[2];
wire [2:0]pwm_out;

assign {pwm2_out, pwm1_out, pwm0_out} = pwm_out;

generate 
    for (j = 0; j <= 2; j++) begin
        debounce de_enc0_a(clk, reset, enc_a[j], de_enc_a[j]);
        debounce de_enc0_b(clk, reset, enc_b[j], de_enc_b[j]);
        encoder encoder0(clk, reset, de_enc_a[j], de_enc_b[j], enc[j]);
        pwm pwm0(clk, reset, pwm_out[j], enc[j]);        
    end
endgenerate

endmodule
