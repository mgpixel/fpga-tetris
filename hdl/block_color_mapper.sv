import types::*;

module block_color_mapper
(
  input Clk,
  input play_area1, play_area2,
  input score_area1, score_area2,
  input block_color block_type1, block_type2,
  input logic [23:0] score_digits_in1, score_digits_in2,
  input [9:0] DrawX, DrawY,
  input [9:0] scorex_min1, scorex_max1, scorex_min2, scorex_max2,
  input logic [9:0] xdraw_counter1, ydraw_counter1, xdraw_counter2, ydraw_counter2,
  input logic [9:0] holdy_min, holdy_max, holdx_min1, holdx_max1, holdx_min2, holdx_max2,
  input logic [9:0] nexty_min, nexty_max, nextx_min1, nextx_max1, nextx_min2, nextx_max2,
  output logic [7:0] VGA_R, VGA_G, VGA_B
);

logic [9:0] digit5_xmax, digit4_xmax, digit3_xmax, digit2_xmax, digit1_xmax, digit0_xmax;
logic [9:0] nfont_xmax, efont_xmax, xfont_xmax, tfont_xmax;
block_color block_type;

assign digit5_xmax = score_area1 ? scorex_min1 + 7 : scorex_min2 + 7;
assign digit4_xmax = score_area1 ? scorex_min1 + 15 : scorex_min2 + 15;
assign digit3_xmax = score_area1 ? scorex_min1 + 23 : scorex_min2 + 23;
assign digit2_xmax = score_area1 ? scorex_min1 + 31 : scorex_min2 + 31;
assign digit1_xmax = score_area1 ? scorex_min1 + 39 : scorex_min2 + 39;
assign digit0_xmax = score_area1 ? scorex_max1 : scorex_max2;

logic [7:0] red, green, blue;
logic [10:0] addr;
logic [10:0] addr_offset;
logic [10:0] next_font_addr;
logic [9:0] sprite_addr;
logic [7:0] data;
logic [3:0] digit;
logic [2:0] data_idx;
logic [23:0] cur_sprite;
logic [23:0] score_digits_in;
logic [2:0] back_rgb_idx;
logic [4:0] rgb_idx;
logic [9:0] xdraw_counter, ydraw_counter;
logic [9:0] holdx_min;
logic [9:0] holdx_max;
logic score_area;
logic play_area;
logic hold_area;

assign play_area = play_area1 | play_area2;
assign score_digits_in = score_area1 ? score_digits_in1 : score_digits_in2;
assign xdraw_counter = play_area1 ? xdraw_counter1 : xdraw_counter2;
assign ydraw_counter = play_area1 ? ydraw_counter1 : ydraw_counter2;
assign score_area = score_area1 | score_area2;
assign block_type = play_area1 ? block_type1 : block_type2;
assign holdx_min = DrawX < 10'd320 ? holdx_min1 : holdx_min2;
assign holdx_max = DrawX < 10'd320 ? holdx_max1 : holdx_max2;
assign hold_area = (DrawX >= holdx_min && DrawX <= holdx_max && DrawY >= holdy_min && DrawY <= holdy_max);
assign nfont_xmax = holdx_min + 7;
assign efont_xmax = holdx_min + 15;
assign xfont_xmax = holdx_min + 23;
assign tfont_xmax = holdx_max;

// Holds colors for the block sprites
logic [0:28][23:0] sprite_palette = {
24'hFF0000, 24'hF83800, 24'hF0D0B0, 24'h503000,
24'hFFE0A8, 24'h0058F8, 24'hFCFCFC, 24'hBCBCBC,
24'hA40000, 24'hD82800, 24'hFC7460, 24'hFCBCB0,
24'hF0BC3C, 24'hAEACAE, 24'h363301, 24'h6C6C01,
24'hBBBD00, 24'h88D500, 24'h398802, 24'h65B0FF,
24'h155ED8, 24'h800080, 24'h24188A, 24'hEF9F00,
24'hDB960E, 24'hE8B651, 24'h333333, 24'h4E4E4E,
24'h393939};

assign VGA_R = red;
assign VGA_G = green;
assign VGA_B = blue;
assign addr = score_area ? addr_offset + DrawY - 11'd15 : next_font_addr;
assign sprite_addr = play_area ? ydraw_counter*10'd20 + xdraw_counter : 10'd0;
assign data_idx = score_area ? 7 - DrawX[2:0] : 7 - (DrawX[2:0]-4);
assign cur_sprite = sprite_palette[rgb_idx];

block_sprites block_sprites(.address(sprite_addr), .block(block_type), .data(rgb_idx));

// Logic to pick correct address in font_rom for score keeping
always_comb
begin
  // This is for score keeping area
  addr_offset = 11'd768;
  digit = score_digits_in[23:20];
  // Checking ranges to not use a multiplier here
  if (DrawX <= digit5_xmax)
    digit = score_digits_in[23:20];
  else if (DrawX <= digit4_xmax)
    digit = score_digits_in[19:16];
  else if (DrawX <= digit3_xmax)
    digit = score_digits_in[15:12];
  else if (DrawX <= digit2_xmax)
    digit = score_digits_in[11:8];
  else if (DrawX <= digit1_xmax)
    digit = score_digits_in[7:4];
  else if (DrawX <= digit0_xmax)
    digit = score_digits_in[3:0];
  case (digit)
    4'd0:
      addr_offset = 11'd768;
    4'd1:
      addr_offset = 11'd784;
    4'd2:
      addr_offset = 11'd800;
    4'd3:
      addr_offset = 11'd816;
    4'd4:
      addr_offset = 11'd832;
    4'd5:
      addr_offset = 11'd848;
    4'd6:
      addr_offset = 11'd864;
    4'd7:
      addr_offset = 11'd880;
    4'd8:
      addr_offset = 11'd896;
    4'd9:
      addr_offset = 11'd912;
    default:
      addr_offset = 11'd768;
  endcase

  next_font_addr = 11'd1248;
  // Logic for next block area here
  if (DrawX <= nfont_xmax)
    next_font_addr = 11'd1248 + DrawY - 40;
  else if (DrawX <= efont_xmax)
    next_font_addr = 11'd1104 + DrawY - 40;
  else if (DrawX <= xfont_xmax)
    next_font_addr = 11'd1408 + DrawY - 40;
  else if (DrawX <= tfont_xmax)
    next_font_addr = 11'd1344 + DrawY - 40;
end

font_rom text_rom(.*);

always_comb
begin
  if (play_area) begin
    // Each square in the play area is determined by 4 bits, with the outside
    // area being also 4 bits corresponding to different colors
    red = cur_sprite[23:16];
    green = cur_sprite[15:8];
    blue = cur_sprite[7:0];
  end
  else if ((score_area | hold_area) && data[data_idx] == 1'b1) begin
    red = 8'hff;
    green = 8'hff;
    blue = 8'hff;
  end
  // Background when not in play or score area
  else begin
    red = 8'h1f;
    green = 8'h00;
    blue = 8'h7f - {1'b0, DrawX[9:3]};
  end
end

endmodule