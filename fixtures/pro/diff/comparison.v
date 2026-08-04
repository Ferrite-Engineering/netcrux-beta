// Comparison-side Verilog source for the §5.2.3 Diff View verification.
//
// Differs from baseline.v in three structural ways:
//   1. `in_a` widened from [7:0] to [15:0] → modified port (width).
//   2. New `dma_inst` instance → added instance.
//   3. The `u_alu` cell stays unchanged.
//
// Expected diff vs. baseline.v: see expected_diff.json.

module top(
    input  [15:0] in_a,
    input         in_clk,
    output        out_y
);

    u_alu alu_inst (
        .a(in_a[7:0]),
        .clk(in_clk),
        .y(out_y)
    );

    // New cell added in this revision.
    u_dma dma_inst (
        .clk(in_clk),
        .data(in_a)
    );

endmodule

module u_alu(
    input  [7:0] a,
    input        clk,
    output       y
);
    assign y = ^a;
endmodule

module u_dma(
    input         clk,
    input  [15:0] data
);
endmodule
