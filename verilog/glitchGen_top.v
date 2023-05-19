`timescale 1ns/1ns

module glitchGen (
        input  CLK,   //12MHz oscillator
        output PMOD1, //pll out
        output PMOD3, //div clk out
        output D5     //locked
);

assign D5 = locked;
assign PMOD1 = pll_clk_out;
assign PMOD3 = my_clk;

reg [31:0] counter = 0;
wire locked;
wire pll_clk_out;
reg my_clk;

always @ (posedge pll_clk_out) begin
        counter = counter + 1;
        if (counter == 32'd500000) begin
                counter <= 0;
                my_clk <= !my_clk;
        end
end

SB_PLL40_CORE #(
        .FEEDBACK_PATH("SIMPLE"),
        .DIVR(4'd0),          // DIVR =  0
        .DIVF(7'd47),         // DIVF = 47
        .DIVQ(3'd3),          // DIVQ =  3
        .FILTER_RANGE(3'd1)   // FILTER_RANGE = 1
) pll (
        .LOCK(locked),
        .RESETB(1'b1),
        .BYPASS(1'b0),
        .REFERENCECLK(CLK),
        .PLLOUTCORE(pll_clk_out)
);
endmodule
