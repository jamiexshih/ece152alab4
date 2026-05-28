/*
* Copyright (c) 2023, University of California; Santa Barbara
* Distribution prohibited. All rights reserved.
*
* File: ucsbece152a_taillights.sv
* Description: Starter code for taillights.
*/

module ucsbece152a_taillights (
    input logic clk,
    input logic rst_n,
    input logic clk_dimmer_i,
    input logic left_i,
    input logic right_i,
    input logic hazard_i,
    input logic brake_i,
    input logic runlights_i,
    output logic [5:0] lights_o
);

logic [5:0] fsm_pattern;

ucsbece152a_fsm fsm (
    .clk(clk),
    .rst_n(rst_n),
    .left_i(left_i),
    .right_i(right_i),
    .hazard_i(hazard_i),
    .pattern_o(fsm_pattern)
);

// logic [5:0] lights_runlightsoff, lights_runlightson;

// TODO: Convert `fsm_pattern` into `lights_o`
// Runlight Signals
logic [5:0] lights_runlightsoff;
logic [5:0] lights_runlightson;

// RUNLIGHTS OFF
always_comb begin

    // FSM pattern has highest priority
    if (fsm_pattern != 6'b000000)
        lights_runlightsoff = fsm_pattern;

    // Brake lights
    else if (brake_i)
        lights_runlightsoff = 6'b111111;

    // Otherwise off
    else
        lights_runlightsoff = 6'b000000;

end

// RUNLIGHTS ON
always_comb begin

    // Start with runlights
    // Example: dim outer lamps
    if (clk_dimmer_i)
        lights_runlightson = 6'b100001;
    else
        lights_runlightson = 6'b000000;

    // FSM overrides runlights
    if (fsm_pattern != 6'b000000)
        lights_runlightson = fsm_pattern;

    // Brake overrides everything
    if (brake_i)
        lights_runlightson = 6'b111111;

end

// Final MUX
assign lights_o =
    (runlights_i) ? lights_runlightson
                  : lights_runlightsoff;


endmodule
