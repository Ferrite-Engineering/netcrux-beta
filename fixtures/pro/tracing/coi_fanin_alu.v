// §4.1 cone-of-influence fixture — a small registered ALU. Selecting the
// output register and running a fanin cone highlights exactly the cells and
// boundary inputs that can influence it.
//
// Selection: cell y_reg (the output flop)
// Fanin cone: y_reg <- mux <- {adder, a}; adder <- {a, b}; mux sel <- sel
// Expected boundary inputs in the cone: a, b, sel, clk
//
// Regeneration: dart run tool/generate_pro_verification_fixtures.dart
//               --design coi_fanin_alu
// The §4.1 integration test seeds this design through the schematic
// projection and asserts ProConeOfInfluenceService.compute() produces a
// TraceOverlay whose highlighted sets match the companion JSON.

module top(
    input        clk,
    input  [7:0] a,
    input  [7:0] b,
    input        sel,
    output [7:0] y
);
    wire [7:0] sum   = a + b;          // adder
    wire [7:0] muxed = sel ? sum : a;  // mux
    reg  [7:0] y_reg;                  // output flop

    always @(posedge clk) y_reg <= muxed;
    assign y = y_reg;
endmodule
