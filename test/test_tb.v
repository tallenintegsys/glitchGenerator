`timescale 1ns/1ns

module test_tb;

reg [63:0] count = 0;
real d = 4.901960784;

//localparam TIME = 64'd100_000_000_000; //100_s
//localparam TIME = 64'd65; //65_ns
localparam TIME = 64'd5; //1_s

localparam COUNT = TIME * 64'd2045 / 64'd10000;
//localparam GLITCH_COUNT = GLITCH_TIME / 128'd10000 * 128'd2045;


initial begin
	$dumpfile("test.vcd");
    $display("TIME %d %x", TIME, TIME);
    $display("COUNT %d %x", COUNT, COUNT);
	#0
    count <= COUNT;
	#5
    $display("count %d %x", count, count);
	#5
	$finish;
end

endmodule
