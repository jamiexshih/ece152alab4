```verilog
module ucsbece152a_taillights (

    input clk,
    input rst_n,
    input clk_dimmer_i,

    input left_i,
    input right_i,
    input hazard_i,

    input brake_i,
    input runlights_i,

    output [5:0] lights_o

);

wire [5:0] fsm_pattern;

reg [5:0] lights_o;

ucsbece152a_fsm fsm (

    .clk(clk),
    .rst_n(rst_n),

    .left_i(left_i),
    .right_i(right_i),
    .hazard_i(hazard_i),

    .pattern_o(fsm_pattern)

);

// =====================================
// OUTPUT LOGIC
// =====================================

always @(*) begin

    // default
    lights_o = fsm_pattern;

    // BRAKES
    if (brake_i) begin

        lights_o = 6'b111111;

        // left sequence overrides left brake side
        if (left_i)
            lights_o[5:3] = fsm_pattern[5:3];

        // right sequence overrides right brake side
        if (right_i)
            lights_o[2:0] = fsm_pattern[2:0];

    end

    // RUNLIGHTS
    if (runlights_i) begin

        lights_o = lights_o |
                   (~lights_o & {6{clk_dimmer_i}});

    end

    // RESET
    if (!rst_n)
        lights_o = 6'b000000;

end

endmodule
```
