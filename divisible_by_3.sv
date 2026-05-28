module divisible_by_3 (
  input logic clk,
  input logic rst_n,
  input logic serial_i,
  output logic divisible_by_3_o
);
typedef enum logic [1:0] {
  REMAINDER_0,
  REMAINDER_1,
  REMAINDER_2
} state_t;
state_t state_d, state_q = REMAINDER_0;
  
assign divisible_by_3_o = (state_q == REMAINDER_0);
  
always_comb begin
  state_d = REMAINDER_0;
  if (serial_i) begin
    case (state_q) // 2*num + 1
    REMAINDER_0: state_d = REMAINDER_1;
    REMAINDER_1: state_d = REMAINDER_0;
    REMAINDER_2: state_d = REMAINDER_2;
    endcase
  end else begin
    case (state_q) // 2*num + 0
    REMAINDER_0: state_d = REMAINDER_0;
    REMAINDER_1: state_d = REMAINDER_2;
    REMAINDER_2: state_d = REMAINDER_1;
    endcase
  end
end
  
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state_q <= REMAINDER_0;
    end else begin
      state_q <= state_d;
    end
  end
endmodule
