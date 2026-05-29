```verilog
`timescale 1ns/1ps

module tb_taillights;

// =====================
// SIGNALS
// =====================

reg clk;
reg rst_n;
reg clk_dimmer_i;

reg left_i;
reg right_i;
reg hazard_i;
reg brake_i;
reg runlights_i;

wire [5:0] lights_o;

// =====================
// DUT
// =====================

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

// =====================
// MAIN CLOCK
// =====================

always begin
    #5 clk = ~clk;
end

// =====================
// DIMMER CLOCK
// =====================

always begin
    #1 clk_dimmer_i = ~clk_dimmer_i;
end

// =====================
// TEST SEQUENCE
// =====================

initial begin

    // INITIALIZE EVERYTHING

    clk = 0;
    clk_dimmer_i = 0;

    rst_n = 0;

    left_i = 0;
    right_i = 0;
    hazard_i = 0;
    brake_i = 0;
    runlights_i = 0;

    // RESET

    #20;
    rst_n = 1;

    // =========================
    // LEFT TURN TEST
    // =========================

    #20;
    left_i = 1;

    #120;
    left_i = 0;

    // =========================
    // RIGHT TURN TEST
    // =========================

    #40;
    right_i = 1;

    #120;
    right_i = 0;

    // =========================
    // HAZARD TEST
    // =========================

    #40;
    hazard_i = 1;

    #120;
    hazard_i = 0;

    // =========================
    // BRAKE TEST
    // =========================

    #40;
    brake_i = 1;

    #80;
    brake_i = 0;

    // =========================
    // BRAKE + LEFT TEST
    // =========================

    #40;
    brake_i = 1;
    left_i = 1;

    #120;

    brake_i = 0;
    left_i = 0;

    // =========================
    // BRAKE + RIGHT TEST
    // =========================

    #40;
    brake_i = 1;
    right_i = 1;

    #120;

    brake_i = 0;
    right_i = 0;

    // =========================
    // LEFT + RIGHT TEST
    // =========================

    #40;
    left_i = 1;
    right_i = 1;

    #120;

    left_i = 0;
    right_i = 0;

    // =========================
    // RUNLIGHT TEST
    // =========================

    #40;
    runlights_i = 1;

    #120;
    runlights_i = 0;

    // =========================
    // FINAL RESET TEST
    // =========================

    #40;
    rst_n = 0;

    #20;
    rst_n = 1;

    // END SIMULATION

    #100;

    $finish;

end

endmodule
```

