// §5.3.3 FSM detection fixture — borderline candidate register.
//
// A 16-bit register that the v1 detector flags as a `candidateRegister`
// but doesn't classify as an FSM. The detector's width-filter cap is
// 8 bits — registers above that are surfaced as candidates so the user
// can "Force detection" via the results dialog.
//
// Detection expectation: see candidate_register.expected.json.

module top(
    input         clk,
    input         rst_n,
    input  [15:0] data_in,
    output [15:0] data_out
);
    reg [15:0] state_q;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) state_q <= 16'h0000;
        else        state_q <= data_in;
    end

    assign data_out = state_q;

endmodule
