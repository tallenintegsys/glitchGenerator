//`timescale 1ns/1ns

module glitchGen #(
  parameter DELAY_TIME  = 64'd1_000_000,  //1_s
  parameter GLITCH_TIME = 64'd5) (        //5_ns
  input  logic  clk,                //12MHz oscillator
  output logic  done_indicator,     //DONE
  output logic  delay_indicator,    //DELAY
  output logic  locked_indicator,   //locked
  input  logic  trigger,            //trigger
  output logic  glitch);            //glitch

enum logic [1:0] {READY, DELAY, PULSE, DONE} state;

localparam DELAY_COUNT = DELAY_TIME / 64'd5;
localparam GLITCH_COUNT = GLITCH_TIME * 64'd100000 / 64'd490150;

reg   [63:0] delay_counter = 0;
reg   [63:0] width_counter = 0;
wire  pll_clk;

initial begin
    done_indicator = 0;
    delay_indicator = 0;
    glitch = 1'b0;
    state = READY;
end

always @ (posedge pll_clk) begin
  case (state)
    READY: begin
      delay_counter <= 64'd0;
      width_counter <= 64'd0;
      if (trigger == 1'b1) state <= DELAY;
    end
    DELAY: begin
      delay_counter <= delay_counter + 64'd1;
      done_indicator <= 1'd0;
      delay_indicator <= 1'b1;
      if (delay_counter == DELAY_COUNT) state <= PULSE;
    end
    PULSE: begin
      width_counter <= width_counter + 64'd1;
      delay_indicator <= 1'b0;
      glitch <= 1'd1;
      if (width_counter == GLITCH_COUNT) state <= DONE;
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
        .PLLOUTCORE(pll_clk));

endmodule
