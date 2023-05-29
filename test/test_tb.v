`timescale 1ns/1ns

module test_tb;

reg [63:0] count = 0;
real d = 4.901960784;

//localparam TIME = 64'd100_000_000_000; //100_s
//localparam TIME = 64'd65; //65_ns
localparam TIME = 64'd1_000_000_000; //1_s

localparam COUNT = TIME * 64'd1000 / 64'd4901;
//localparam GLITCH_COUNT = (GLITCH_TIME / 64'd5) + 64'd1;

initial begin
	$dumpfile("test.vcd");
	#0
    count <= COUNT;
	#5
    $display("count %d %x", count, count);
	#5
	$finish;
end

endmodule
