// Baseline-side Verilog source for the §5.2.3 Diff View verification.
//
// Pair this file with comparison.v (in the same directory) and load
// both through `Tools → Load Comparison Netlist…` to exercise the
// full diff pipeline end-to-end.
//
// Expected diff vs. comparison.v: see expected_diff.json.

module top(
    input  [7:0] in_a,
    input        in_clk,
    output       out_y
);

    // Single instance — comparison adds a sibling dma_inst.
    u_alu alu_inst (
        .a(in_a),
        .clk(in_clk),
        .y(out_y)
    );

endmodule

module u_alu(
    input  [7:0] a,
    input        clk,
    output       y
);
    assign y = ^a;
endmodule
