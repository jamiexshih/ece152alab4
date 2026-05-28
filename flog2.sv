module flog2 #(
  parameter WIDTH = 4
) (
  input logic [WIDTH-1:0] data_i,
  output logic [WIDTH-1:0] data_o,
  output logic valid_o
);
integer i;
always_comb begin
  // default values
  data_o = '0;
  valid_o = '0;
  // check every bit
  for (i = 0; i < WIDTH; i++) begin
    if (data_i[i]) begin
    data_o = WIDTH'(i);
    valid_o = 1'b1;
    end
  end
end
endmodule
