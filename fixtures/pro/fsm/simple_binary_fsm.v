// §5.3.3 FSM detection fixture — simple binary-encoded FSM.
//
// Encoding: binary (state values 0, 1, 2, 3 — contiguous 0..N-1).
// Width: 2 bits.
// Reset state: S0 (0x00).
//
// Detection expectation: see simple_binary_fsm.expected.json.
//
// Regeneration: feed this file through Yosys via
//     yosys -p 'read_verilog simple_binary_fsm.v; proc; opt' \
//           -o simple_binary_fsm.json
// then load the JSON via NetCrux's elaboration pipeline. The
// integration test in test/features/fsm/fsm_integration_test.dart
// constructs an equivalent synthetic NetlistModel directly instead
// of invoking Yosys (running Yosys in unit tests is out of scope).

module top(
    input        clk,
    input        rst_n,
    input        start,
    input        done,
    output       busy
);
    reg [1:0] state_q;

    localparam S0 = 2'd0;
    localparam S1 = 2'd1;
    localparam S2 = 2'd2;
    localparam S3 = 2'd3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_q <= S0;
        end else begin
            case (state_q)
                S0: state_q <= start ? S1 : S0;
                S1: state_q <= S2;
                S2: state_q <= done ? S3 : S2;
                S3: state_q <= S0;
                default: state_q <= S0;
            endcase
        end
    end

    assign busy = (state_q != S0);

endmodule
