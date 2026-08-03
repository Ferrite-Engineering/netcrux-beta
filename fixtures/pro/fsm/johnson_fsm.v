// §5.3.3 FSM detection fixture — Johnson counter (rotating-bit pattern).
//
// Encoding: johnson (rotating-bit pattern). The v1 detector's
// classification heuristic doesn't recognise Johnson counters
// deterministically — it falls back to `unknown` when the encoding
// doesn't match one-hot / binary / gray. The expected entry below
// records this — the integration test asserts `FsmEncodingHint.unknown`
// for this fixture.
//
// State sequence: 0000 → 0001 → 0011 → 0111 → 1111 → 1110 → 1100 → 1000 → 0000.
// Width: 4 bits.
// Reset state: S0 (0x0).
//
// Detection expectation: see johnson_fsm.expected.json.

module top(
    input        clk,
    input        rst_n,
    output [3:0] state_out
);
    reg [3:0] state_q;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_q <= 4'b0000;
        end else begin
            state_q <= {state_q[2:0], ~state_q[3]};
        end
    end

    assign state_out = state_q;

endmodule
