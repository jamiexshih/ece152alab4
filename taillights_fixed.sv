module ucsbece152a_taillights (

    input clk,
    input rst_n,
    input clk_dimmer_i,

    input left_i,
    input right_i,
    input hazard_i,

    input brake_i,
    input runlights_i,

    output reg [5:0] lights_o

);

wire [5:0] fsm_pattern;

reg [5:0] lights_runlightsoff;
reg [5:0] lights_runlightson;

ucsbece152a_fsm fsm (

    .clk(clk),
    .rst_n(rst_n),

    .left_i(left_i),
    .right_i(right_i),
    .hazard_i(hazard_i),

    .pattern_o(fsm_pattern)

);

// =====================================
// RUNLIGHTS OFF LOGIC
// =====================================

always @(*) begin

    // default = FSM pattern
    lights_runlightsoff = fsm_pattern;

    // BRAKE LOGIC
    if (brake_i) begin

        // both sides on
        lights_runlightsoff = 6'b111111;

        // left turn overrides left brake side
        if (left_i && !hazard_i)
            lights_runlightsoff[5:3] = fsm_pattern[5:3];

        // right turn overrides right brake side
        if (right_i && !hazard_i)
            lights_runlightsoff[2:0] = fsm_pattern[2:0];
    end

    // RESET OVERRIDES EVERYTHING
    if (!rst_n)
        lights_runlightsoff = 6'b000000;

end

// =====================================
// RUNLIGHTS ON LOGIC
// =====================================

always @(*) begin

    // any OFF light becomes dimmed
    lights_runlightson =
        lights_runlightsoff |
        (~lights_runlightsoff & {6{clk_dimmer_i}});

end

// =====================================
// FINAL OUTPUT MUX
// =====================================

always @(*) begin

    if (runlights_i)
        lights_o = lights_runlightson;
    else
        lights_o = lights_runlightsoff;

end

endmodule
