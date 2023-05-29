`timescale 1ns/1ns
`include "glitchGen_top.v"

module glitchGen_top_tb;

reg	clk;
wire pll_out, div_clk, waiting, locked;
reg trigger;

glitchGen_top uut (
        .CLK(clk),    //12MHz oscillator
        .PMOD1(pll_out),  //pll out
        .PMOD3(div_clk),  //div clk out
        .D4(waiting),     //WAITING
        .D5(locked),      //locked
        .PMOD2(trigger)   //trigger
);

initial begin
	$dumpfile("glitchGen_top_tb.vcd");
	$dumpvars(0, uut);
	#0
	clk = 1'b0;
	trigger = 0;
	#5
	trigger = 1;
	#5
	trigger = 0;
	#1100000
	$finish;
end


always begin
	#1
	clk = !clk;
end
endmodule
