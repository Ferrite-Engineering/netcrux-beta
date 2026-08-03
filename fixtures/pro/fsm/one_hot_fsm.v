// §5.3.3 FSM detection fixture — one-hot encoded FSM.
//
// Encoding: one-hot (state values 0x01, 0x02, 0x04, 0x08 — single bit set).
// Width: 4 bits.
// Reset state: S0 (0x01).
//
// Detection expectation: see one_hot_fsm.expected.json.

module top(
    input        clk,
    input        rst_n,
    input        go,
    input        ack,
    input        err,
    output [3:0] state_out
);
    reg [3:0] state_q;

    localparam S_IDLE  = 4'b0001;
    localparam S_RUN   = 4'b0010;
    localparam S_WAIT  = 4'b0100;
    localparam S_ERR   = 4'b1000;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_q <= S_IDLE;
        end else begin
            case (state_q)
                S_IDLE: state_q <= go ? S_RUN : S_IDLE;
                S_RUN:  state_q <= err ? S_ERR : S_WAIT;
                S_WAIT: state_q <= ack ? S_IDLE : S_WAIT;
                S_ERR:  state_q <= ack ? S_IDLE : S_ERR;
                default: state_q <= S_IDLE;
            endcase
        end
    end

    assign state_out = state_q;

endmodule
