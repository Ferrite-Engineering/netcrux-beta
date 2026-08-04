// reset_domains — two reset domains (polarity split) + a reset-boundary
// crossing + an unreset flop.
//
// Domains:
//   rst_n  (async, active-low)   drives data_r
//   rst2   (async, active-high)  drives capture_r
//
// Crossing:  data_r -> capture_r crosses the rst_n → rst2 reset boundary
//            (8-bit bus), sampled with no synchronizer.
//
// BUG (P44): alarm_r has NO reset in any branch — it is only ever assigned
// in the plain `always @(posedge clk)` block, so it powers up X and the
// reset-domain analysis must flag it as an unreset / reset-unassigned
// register. data_r and capture_r (both async-reset) DO reset and must NOT
// be flagged.
//
// Both resets are async so Yosys lowers them to `$adff` cells with an
// `ARST` port — the reset-domain detector's Part B recognises those
// directly, so no synth-inference pass beyond `proc; opt` is needed.
module reset_domains (
    input  wire       clk,
    input  wire       rst_n,       // async active-low reset (domain A)
    input  wire       rst2,        // async active-high reset (domain B)
    input  wire [7:0] d_in,
    input  wire       alarm_set,
    output     [7:0] q_out,
    output           alarm
);

    // (* keep *) preserves each register's own net name through the
    // `proc; opt` lowering the reset-domain flow runs (opt would otherwise
    // fold a register that only drives an output port into the output net,
    // erasing the source name).
    (* keep *) reg [7:0] data_r;     // reset by rst_n  (domain A)
    (* keep *) reg [7:0] capture_r;  // reset by rst2   (domain B)
    (* keep *) reg       alarm_r;    // NO reset — powers up X

    // Domain A: async active-low reset.
    always @(posedge clk or negedge rst_n)
        if (!rst_n) data_r <= 8'h00;
        else        data_r <= d_in;

    // Domain B: async active-high reset; samples data_r across the boundary.
    always @(posedge clk or posedge rst2)
        if (rst2) capture_r <= 8'h00;
        else      capture_r <= data_r;

    // Unreset flop: no reset branch at all.
    always @(posedge clk)
        alarm_r <= alarm_set | (|capture_r);

    // `alarm` is derived from alarm_r through real logic (not a bare alias)
    // so the alarm_r register keeps its own source name after opt instead of
    // being folded into the `alarm` output net.
    assign q_out = capture_r;
    assign alarm = alarm_r & alarm_set;

endmodule
