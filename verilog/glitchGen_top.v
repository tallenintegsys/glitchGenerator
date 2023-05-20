//`timescale 1ns/1ns

module glitchGen_top (
  input   CLK,    //12MHz oscillator
  output  D3,     //DONE
  output  D4,     //DELAY
  output  D5,     //locked
  input   PMOD2,  //trigger
  output  PMOD4   //glitch
);
parameter DELAY_COUNT  = 32'd300; //600_000_000;
parameter PWIDTH_COUNT = 32'd300;

localparam READY = 0;
localparam DELAY = 1;
localparam PULSE = 2;
localparam DONE = 3;

assign D5 = locked_indicator;
assign D4 = delay_indicator;
assign D3 = done_indicator;
assign trigger = PMOD2;
assign PMOD4 = glitch;

reg   [31:0] delay_counter = 0;
reg   [31:0] width_counter = 0;
wire  locked_indicator;
reg   delay_indicator = 0;
reg   glitch = 0;
wire  trigger;
reg   [1:0] state = READY;

always @ (posedge pll_clk_out) begin
  case (state)
    READY: begin
      delay_counter <= 32'd0;
      width_counter <= 32'd0;
      glitch <= 1'd0;
      if (trigger == 1'b1) state <= DELAY;
    end
    DELAY: begin
      done_indicator = 1'd0;
      delay_counter <= delay_counter + 32'd1;
      delay_indicator <= 1'b1;
      if (delay_counter == DELAY_COUNT) state <= PULSE;
    end
    PULSE: begin
      width_counter <= width_counter + 32'd1;
      delay_indicator <= 1'b0;
      glitch <= 1'd1;
      if (width_counter == PWIDTH_COUNT) state <= DONE;
    end
    DONE: begin
      done_indicator = 1'b1;
      glitch <= 1'd0;
      if (trigger == 1'b0) state <= READY;
    end
    default:
      state <= READY;
  endcase
end //always

//`ifndef __ICARUS__
// Lattice PLL Primitive 
SB_PLL40_CORE #( // 300MHz
        .FEEDBACK_PATH("SIMPLE"),
        .DIVR(4'd0),              // DIVR =  0
        .DIVF(7'd49),             // DIVF = 49
        .DIVQ(3'd1),              // DIVQ = 1 
        .FILTER_RANGE(3'd1)       // FILTER_RANGE = 1
) pll ( // CLK * (DIVF + 1) / 2^DIVQ * (DIVR + 1)
        .LOCK(locked_indicator),
        .RESETB(1'b1),
        .BYPASS(1'b0),
        .REFERENCECLK(CLK),
        .PLLOUTCORE(pll_clk_out)
);
/*
`else
always begin
	#1
	pll_clk_out = !pll_clk_out;
end
`endif
*/
endmodule
