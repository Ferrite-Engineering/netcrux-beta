// §5.1 CDC fixture — a single-bit flag correctly synchronized across two
// primary-input clock domains with a two-flop synchronizer.
//
// Domains:   clk_a (primaryInput), clk_b (primaryInput)
// Crossing:  flag_a  (clk_a -> clk_b), single-bit, proper 2-flop sync
// Expected:  1 crossing, severity = info (safe). See the .expected.cdc.json.
//
// Regeneration: dart run tool/generate_pro_verification_fixtures.dart
//               --design cdc_two_domain_2ff
// The §5.1 integration test builds an equivalent synthetic NetlistModel and
// asserts ProClockDomainAnalysisService.analyze() against the companion JSON
// (running Yosys in unit tests is out of scope).

module top(
    input  clk_a,
    input  clk_b,
    input  rst_n,
    input  d_a,
    output q_b
);
    reg flag_a;      // generated in the clk_a domain
    reg sync_meta;   // first synchronizer flop  (clk_b)
    reg sync_stable; // second synchronizer flop (clk_b)

    always @(posedge clk_a or negedge rst_n)
        if (!rst_n) flag_a <= 1'b0; else flag_a <= d_a;

    always @(posedge clk_b or negedge rst_n)
        if (!rst_n) begin
            sync_meta   <= 1'b0;
            sync_stable <= 1'b0;
        end else begin
            sync_meta   <= flag_a;      // clk_a -> clk_b crossing
            sync_stable <= sync_meta;   // completes the 2-flop chain
        end

    assign q_b = sync_stable;
endmodule
