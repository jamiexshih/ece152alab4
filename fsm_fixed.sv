/*
* Copyright (c) 2023, University of California; Santa Barbara
* Distribution prohibited. All rights reserved.
*
* File: ucsbece152a_fsm.sv
* Description: Starter code for fsm.
*/
import taillights_pkg::*;

module ucsbece152a_fsmg (

    input clk,
    input rst_n,

    input left_i,
    input right_i,
    input hazard_i,

    output reg [5:0] pattern_o,
    output state_t state_o

);

state_t state_d;
state_t state_q;

assign state_o = state_q;

// NEXT STATE LOGIC

always @(*) begin

    state_d = state_q;

    // hazards override everything
    if (hazard_i || (left_i && right_i)) begin

        case(state_q)

            S111_111: state_d = S000_000;
            default:  state_d = S111_111;

        endcase

    end

    // LEFT TURN
    else if (left_i) begin

        case(state_q)

            S000_000: state_d = S001_000;
            S001_000: state_d = S011_000;
            S011_000: state_d = S111_000;
            S111_000: state_d = S000_000;

            default:  state_d = S000_000;

        endcase

    end

    // RIGHT TURN
    else if (right_i) begin

        case(state_q)

            S000_000: state_d = S000_100;
            S000_100: state_d = S000_110;
            S000_110: state_d = S000_111;
            S000_111: state_d = S000_000;

            default:  state_d = S000_000;

        endcase

    end

    else begin

        state_d = S000_000;

    end

end

// STATE REGISTER

always @(posedge clk or negedge rst_n) begin

    if (!rst_n)
        state_q <= S000_000;
    else
        state_q <= state_d;

end

// OUTPUT DECODER

always @(*) begin

    case(state_q)

        S000_000: pattern_o = 6'b000000;

        // RIGHT
        S000_100: pattern_o = 6'b000100;
        S000_110: pattern_o = 6'b000110;
        S000_111: pattern_o = 6'b000111;

        // LEFT
        S001_000: pattern_o = 6'b001000;
        S011_000: pattern_o = 6'b011000;
        S111_000: pattern_o = 6'b111000;

        // HAZARD
        S111_111: pattern_o = 6'b111111;

        default:  pattern_o = 6'b000000;

    endcase

end

endmodule
