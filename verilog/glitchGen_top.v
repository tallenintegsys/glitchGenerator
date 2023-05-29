`include "glitchGen.v"

module glitchGen_top (
  input   CLK,      //12MHz oscillator
  output  D3,       //DONE indicator
  output  D4,       //DELAY indicator
  output  D5,       //PLL locked
  input   PMOD2,    //trigger
  output  PMOD4);   //glitch

wire  done_indicator;
wire  delay_indicator;
wire  locked_indicator;
wire  trigger;
wire  glitch;

assign D3 = done_indicator;
assign D4 = delay_indicator;
assign D5 = locked_indicator;
assign trigger = PMOD2;
assign PMOD4 = glitch;

glitchGen #(
  .DELAY(64'd1_000_000_000),    // 1_s
  .GWIDTH(32'd1_000))     // 1000_ns
glitchGen0 (
  .clk(CLK),    //12MHz oscillator in
  .done_indicator(done_indicator),
  .delay_indicator(delay_indicator),
  .locked_indicator(locked_indicator),
  .trigger(trigger),
  .glitch(glitch));

endmodule
