// §5.3.3 FSM detection fixture — two independent FSMs in one module.
//
// Demonstrates that the detector walks every register cell in the
// netlist, not just the first match. Both FSMs are binary-encoded
// 3-state machines distinguishable by their state register names.
//
// Detection expectation: see multiple_fsms.expected.json.

module top(
    input        clk,
    input        rst_n,
    input        ev_a,
    input        ev_b,
    output       busy_a,
    output       busy_b
);
    reg [1:0] state_a;
    reg [1:0] state_b;

    // FSM A
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) state_a <= 2'd0;
        else case (state_a)
            2'd0: state_a <= ev_a ? 2'd1 : 2'd0;
            2'd1: state_a <= 2'd2;
            2'd2: state_a <= 2'd0;
            default: state_a <= 2'd0;
        endcase
    end

    // FSM B (independent of A)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) state_b <= 2'd0;
        else case (state_b)
            2'd0: state_b <= ev_b ? 2'd1 : 2'd0;
            2'd1: state_b <= 2'd2;
            2'd2: state_b <= 2'd0;
            default: state_b <= 2'd0;
        endcase
    end

    assign busy_a = (state_a != 2'd0);
    assign busy_b = (state_b != 2'd0);

endmodule
