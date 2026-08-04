// §5.1 CDC fixture — a single-bit control signal crossing two clock domains
// with NO synchronizer. The classic metastability hazard.
//
// Domains:   clk_a (primaryInput), clk_b (primaryInput)
// Crossing:  enable_a (clk_a -> clk_b), control, missing synchronizer
// Expected:  1 crossing, severity = critical. See the .expected.cdc.json.
//
// Regeneration: dart run tool/generate_pro_verification_fixtures.dart
//               --design cdc_missing_sync

module top(
    input  clk_a,
    input  clk_b,
    input  rst_n,
    input  d_a,
    output q_b
);
    reg enable_a;  // clk_a domain
    reg capture_b; // clk_b domain, samples enable_a directly (unsafe)

    always @(posedge clk_a or negedge rst_n)
        if (!rst_n) enable_a <= 1'b0; else enable_a <= d_a;

    always @(posedge clk_b or negedge rst_n)
        if (!rst_n) capture_b <= 1'b0;
        else if (enable_a) capture_b <= 1'b1; // direct cross-domain use

    assign q_b = capture_b;
endmodule
