import types::*;

module testbench();

timeunit 10ns;
timeprecision 1ns;

logic clk;
initial clk = 0;
always begin
  #1 clk = ~clk;
end

block_color block = CYAN;
logic [19:0] x_block;
logic [19:0] y_block;
logic rot_left = 1'b1;
orientation cur_orientation;
orientation new_orientation;
logic [19:0] rot_xblock;
logic [19:0] rot_yblock;

rotate_blocks rotater(.*);

always_ff @(posedge clk)
begin
  cur_orientation <= new_orientation;
  x_block <= rot_xblock;
  y_block <= rot_yblock;
end

endmodule