`timescale 1ns/1ns

module test_tb;

reg [63:0] count = 0;

//localparam TIME = 64'd100_000_000_000; //100_s
localparam TIME = 64'd65; //65_ns

localparam COUNT = TIME / 64'd1_000_000_000 * 64'd204_000_000;

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
