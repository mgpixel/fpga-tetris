import types::*;

module color_mapper_testbench();

timeunit 10ns;
timeprecision 1ns;

logic clk;
initial clk = 0;
always begin
  #1 clk = ~clk;
end

logic play_area;
logic score_area;
block_color block_type;
logic [23:0] score_digits_in;
logic [9:0] DrawX, DrawY;
logic [4:0] xdraw_counter, ydraw_counter;
logic [7:0] VGA_R, VGA_G, VGA_B;

assign play_area = 1'b1;
assign score_area = 1'b0;
assign block_type = MAGENTA;

block_color_mapper block_mapper(.*);

always_ff @(posedge clk)
begin
  if (xdraw_counter == 5'd20)
    xdraw_counter <= 5'd0;
  else
    xdraw_counter <= 5'd1 + xdraw_counter;
  if (ydraw_counter == 5'd20)
    ydraw_counter <= 5'd0;
  else
    ydraw_counter <= 5'd1 + ydraw_counter;
end

endmodule
