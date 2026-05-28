`timescale 1ns/1ps

module tb_taillights;

// Signals
logic clk;
logic rst_n;
logic clk_dimmer_i;

logic left_i;
logic right_i;
logic hazard_i;
logic brake_i;
logic runlights_i;

logic [5:0] lights_o;

// DUT
ucsbece152a_taillights dut (

    .clk(clk),
    .rst_n(rst_n),
    .clk_dimmer_i(clk_dimmer_i),

    .left_i(left_i),
    .right_i(right_i),
    .hazard_i(hazard_i),

    .brake_i(brake_i),
    .runlights_i(runlights_i),

    .lights_o(lights_o)
);

// Clock Generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Dimmer Clock

initial begin
    clk_dimmer_i = 0;
    forever #20 clk_dimmer_i = ~clk_dimmer_i;
end

// Test Sequence
initial begin

    // Initialize
    rst_n = 0;

    left_i = 0;
    right_i = 0;
    hazard_i = 0;
    brake_i = 0;
    runlights_i = 0;

    #20;
    rst_n = 1;

    // LEFT TURN TEST
    #20;
    left_i = 1;

    #80;
    left_i = 0;

    // RIGHT TURN TEST
    #40;
    right_i = 1;

    #80;
    right_i = 0;
    // HAZARD TEST
    #40;
    hazard_i = 1;

    #100;
    hazard_i = 0;

    // BRAKE TEST
    #40;
    brake_i = 1;

    #60;
    brake_i = 0;
  
    // RUNLIGHT TEST
    #40;
    runlights_i = 1;

    #100;
    runlights_i = 0;

    // END SIM

    #50;
    $stop;

end

endmodule
