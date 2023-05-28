`timescale 1ns/1ns

module glitchGen #(
  parameter DELAY  = 64'd100_000_000,   //100_s
  parameter GWIDTH = 32'd200) (   //200_ns
  input      clk,               //12MHz oscillator
  output     done_indicator,    //DONE
  output     delay_indicator,   //DELAY
  output     locked_indicator,  //locked
  input      trigger,           //trigger
  output     glitch);           //glitch

localparam READY = 0;
localparam DELAY = 1;
localparam PULSE = 2;
localparam DONE  = 3;

localparam DELAY_COUNT = DELAY / 64'd5 * 64'd204_000_000;
localparam GWIDTH_COUNT = GWIDTH / 64'd5 * 64'd204_000_000;

reg   [63:0] delay_counter = 0;
reg   [31:0] width_counter = 0;
reg   [1:0] state = READY;
wire  pll_clk_out;
reg   done_indicator = 0;
reg   delay_indicator = 0;
wire  trigger; 
reg   glitch = 1'b0;

always @ (posedge pll_clk_out) begin
  case (state)
    READY: begin
      delay_counter <= 64'd0;
      width_counter <= 32'd0;
      if (trigger == 1'b1) state <= DELAY;
    end
    DELAY: begin
      delay_counter <= delay_counter + 64'd1;
      done_indicator <= 1'd0;
      delay_indicator <= 1'b1;
      if (delay_counter == DELAY_COUNT) state <= PULSE;
    end
    PULSE: begin
      width_counter <= width_counter + 32'd1;
      delay_indicator <= 1'b0;
      glitch <= 1'd1;
      if (width_counter == GWIDTH_COUNT) state <= DONE;
    end
    DONE: begin
      done_indicator <= 1'b1;
      glitch <= 1'd0;
      if (trigger == 1'b0) state <= READY;
    end
  endcase
end //always

// Lattice PLL Primitive @ 204_MHz
SB_PLL40_CORE #(
        .FEEDBACK_PATH("SIMPLE"),
        .DIVR(4'd0),              // DIVR = 0
        .DIVF(7'd33),             // DIVF = 33
        .DIVQ(3'd1),              // DIVQ = 1 
        .FILTER_RANGE(3'd1))      // FILTER_RANGE = 1
pll ( // clk * (DIVF + 1) / 2^DIVQ * (DIVR + 1)
        .LOCK(locked_indicator),
        .RESETB(1'b1),
        .BYPASS(1'b0),
        .REFERENCECLK(clk),
        .PLLOUTCORE(pll_clk_out));

endmodule
