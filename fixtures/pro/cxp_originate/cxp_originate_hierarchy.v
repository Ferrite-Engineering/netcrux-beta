// §6 CXP-originate fixture — a two-level hierarchy. CrossProbeOriginator
// resolves a NetCrux selection to a canonical ElementId path and dispatches a
// RequestHighlight to a connected peer. This fixture pins the canonical path
// each selection resolves to (deterministic name resolution via
// NetcruxNameResolver), independent of any live peer.
//
// Hierarchy: top -> u_cpu (instance) -> { clk (port), data_bus (net) }
//
// Regeneration: dart run tool/generate_pro_verification_fixtures.dart
//               --design cxp_originate_hierarchy
// The §6 integration test drives CrossProbeOriginator.dispatchTo() with a stub
// CXP server and asserts the outbound RequestHighlight carries the canonical
// element id below and returns CrossProbeDispatchResult.sent.

module top(
    input  clk,
    input  [31:0] data_in,
    output [31:0] data_out
);
    u_cpu u_cpu (
        .clk(clk),
        .data_bus(data_in),
        .result(data_out)
    );
endmodule

module u_cpu(
    input  clk,
    input  [31:0] data_bus,
    output [31:0] result
);
    reg [31:0] acc;
    always @(posedge clk) acc <= data_bus;
    assign result = acc;
endmodule
