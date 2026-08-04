// §5.3.3 FSM detection fixture — FSM with one state present in the
// next-state logic but unreachable from reset (dead code).
//
// The S_DEAD value (0x3) is mentioned in the case statement's default
// arm but never assigned in the live state graph — synthesis tools
// typically warn about this. The detector should still surface it as
// a state value (the v1 detector enumerates every constant that
// appears on the FF's D-driving logic) but mark it `isReachable: false`
// once a future v2 pass computes reachability. v1 marks everything as
// reachable by default — see the comment on FsmState.isReachable in
// `domain/models/fsm/fsm_state.dart`. The integration test treats the
// reachability column as `true` for every state of this fixture until
// the v2 reachability pass lands.
//
// Detection expectation: see unreachable_state_fsm.expected.json.

module top(
    input        clk,
    input        rst_n,
    input        go,
    output [1:0] state_out
);
    reg [1:0] state_q;

    localparam S_IDLE = 2'd0;
    localparam S_RUN  = 2'd1;
    localparam S_DONE = 2'd2;
    localparam S_DEAD = 2'd3;  // unreachable

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) state_q <= S_IDLE;
        else case (state_q)
            S_IDLE: state_q <= go ? S_RUN : S_IDLE;
            S_RUN:  state_q <= S_DONE;
            S_DONE: state_q <= S_IDLE;
            S_DEAD: state_q <= S_IDLE;  // dead-code arm
            default: state_q <= S_IDLE;
        endcase
    end

    assign state_out = state_q;

endmodule
