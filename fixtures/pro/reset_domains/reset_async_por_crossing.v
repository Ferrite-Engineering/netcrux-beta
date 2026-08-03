// §5.2 reset-domain fixture — data crosses from an asynchronous power-on
// reset domain into a synchronous software-reset domain with no reset
// synchronizer on the boundary register.
//
// Domains:   por_n     (active-low, async-assert/sync-deassert, powerOnReset)
//            soft_rst  (active-high, sync-assert/sync-deassert, software)
// Crossing:  stage_a -> stage_b, dataCrossesResetBoundary, missing sync
// Expected:  2 reset domains, 1 crossing, severity = warning.
//
// NOTE on severity: `ResetCrossing.severityFor` only promotes a
// `dataCrossesResetBoundary + missingSynchronizer` crossing to critical
// at `ResetConfidence.high`
// (netcrux/lib/domain/models/reset_domain/reset_crossing.dart). Per
// `ProResetDomainAnalysisService._classifySynchronizer`, `high`
// confidence is only ever assigned alongside a *proper* / vendor /
// custom synchronizer status — a `missingSynchronizer` classification
// (the direct one-hop A -> B shape this fixture exercises) always
// resolves through the chain.length <= 1 branches, which cap at
// `medium` confidence -> `warning` severity. So `critical` is not a
// reachable outcome for this crossing shape today; `warning` is the
// canonical live-service result and what the seeded integration
// journey asserts.
//
// Regeneration: dart run tool/generate_pro_verification_fixtures.dart
//               --design reset_async_por_crossing

module top(
    input  clk,
    input  por_n,     // asynchronous, active-low power-on reset
    input  soft_rst,  // synchronous, active-high software reset
    input  d_in,
    output q_out
);
    reg stage_a; // reset by por_n
    reg stage_b; // reset by soft_rst, consumes stage_a across the boundary

    always @(posedge clk or negedge por_n)
        if (!por_n) stage_a <= 1'b0; else stage_a <= d_in;

    always @(posedge clk)
        if (soft_rst) stage_b <= 1'b0; else stage_b <= stage_a;

    assign q_out = stage_b;
endmodule
