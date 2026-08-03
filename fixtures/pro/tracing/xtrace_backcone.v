// §4.2 X-trace fixture — a buffer chain from a primary input to a primary
// output. With a VCD showing an unknown (X) on q_out, an X-trace back-walk
// follows the chain to its topological origin.
//
// Chain: q_out <- buf2 <- buf1 <- buf0 <- d_in
// Terminating at the primary input d_in yields XTraceTermination.reachedBoundary
// for a pure topological walk (no VCD). With a VCD whose X originates at buf1,
// the walk stops there with foundOrigin — see the companion JSON note.
//
// Regeneration: dart run tool/generate_pro_verification_fixtures.dart
//               --design xtrace_backcone

module top(
    input  clk,
    input  d_in,
    output q_out
);
    reg buf0, buf1, buf2;
    always @(posedge clk) begin
        buf0 <= d_in;
        buf1 <= buf0;
        buf2 <= buf1;
    end
    assign q_out = buf2;
endmodule
