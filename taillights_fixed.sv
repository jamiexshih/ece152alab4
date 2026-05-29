module ucsbece152a_taillights (

    input clk,
    input rst_n,
    input clk_dimmer_i,

    input left_i,
    input right_i,
    input hazard_i,

    input brake_i,
    input runlights_i,

    output logic [5:0] lights_o

);

logic [5:0] fsm_pattern;

logic [5:0] lights_runlightsoff;
logic [5:0] lights_runlightson;


// FSM INSTANCE

ucsbece152a_fsm fsm (

    .clk(clk),
    .rst_n(rst_n),

    .left_i(left_i),
    .right_i(right_i),
    .hazard_i(hazard_i),

    .pattern_o(fsm_pattern)

);

// BASE LIGHTING LOGIC

always_comb begin

    // default
    lights_runlightsoff = fsm_pattern;

    // RESET HAS HIGHEST PRIORITY
    if (!rst_n) begin

        lights_runlightsoff = 6'b000000;

    end

    // BRAKE LOGIC
    else if (brake_i) begin

        // start with all ON
        lights_runlightsoff = 6'b111111;

        // LEFT TURN overrides LEFT brake side
        if (left_i && !hazard_i)
            lights_runlightsoff[5:3] = fsm_pattern[5:3];

        // RIGHT TURN overrides RIGHT brake side
        if (right_i && !hazard_i)
            lights_runlightsoff[2:0] = fsm_pattern[2:0];

    end

end


// RUNLIGHT DIMMING LOGIC

always_comb begin

    // default = same as normal lights
    lights_runlightson = lights_runlightsoff;

    // dim ONLY the OFF LEDs
    if (clk_dimmer_i) begin

        lights_runlightson =
            lights_runlightsoff |
            (~lights_runlightsoff);

    end

end


// FINAL OUTPUT

always_comb begin

    if (!rst_n)
        lights_o = 6'b000000;

    else if (runlights_i)
        lights_o = lights_runlightson;

    else
        lights_o = lights_runlightsoff;

end

endmodule
