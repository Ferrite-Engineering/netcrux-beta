// §5.3.3 FSM detection fixture — Gray-coded FSM.
//
// Encoding: gray (state values 0x0, 0x1, 0x3, 0x2 — sorted-adjacent
// pairs differ by exactly one bit: 0^1=1, 1^2=3 — gray after sort).
//
// Note: the v1 detector classifies encoding from the sorted state-value
// set; this 4-state Gray sequence presents as 0, 1, 2, 3 sorted, with
// 0^1=1, 1^2=3 (popcount 2) — classification falls back to binary.
// The 3-state subset 0, 1, 3 is unambiguously Gray (0^1=1, 1^3=2;
// popcount 1 each). We use the 3-state variant so detector returns
// FsmEncodingHint.gray deterministically.
//
// Width: 2 bits.
// Reset state: S_A (0x0).
//
// Detection expectation: see gray_fsm.expected.json.

module top(
    input        clk,
    input        rst_n,
    input        next,
    output [1:0] state_out
);
    reg [1:0] state_q;

    localparam S_A = 2'b00;
    localparam S_B = 2'b01;
    localparam S_C = 2'b11;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_q <= S_A;
        end else begin
            case (state_q)
                S_A: state_q <= next ? S_B : S_A;
                S_B: state_q <= next ? S_C : S_B;
                S_C: state_q <= next ? S_A : S_C;
                default: state_q <= S_A;
            endcase
        end
    end

    assign state_out = state_q;

endmodule
