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
  input logic [2:0] block_idx1, block_idx2,
  input block_color held_block1, held_block2,
  output logic [7:0] VGA_R, VGA_G, VGA_B
);

logic [9:0] digit5_xmax, digit4_xmax, digit3_xmax, digit2_xmax, digit1_xmax, digit0_xmax;
logic [9:0] nfont_xmax, efont_xmax, xfont_xmax, tfont_xmax;
logic [9:0] hfont_xmax, ofont_xmax, lfont_xmax, dfont_xmax;
logic [2:0] block_idx;
block_color block_type;
block_color held_block;

assign digit5_xmax = score_area1 ? scorex_min1 + 7 : scorex_min2 + 7;
assign digit4_xmax = score_area1 ? scorex_min1 + 15 : scorex_min2 + 15;
assign digit3_xmax = score_area1 ? scorex_min1 + 23 : scorex_min2 + 23;
assign digit2_xmax = score_area1 ? scorex_min1 + 31 : scorex_min2 + 31;
assign digit1_xmax = score_area1 ? scorex_min1 + 39 : scorex_min2 + 39;
assign digit0_xmax = score_area1 ? scorex_max1 : scorex_max2;

logic [7:0] red, green, blue;
logic [10:0] addr;
logic [10:0] addr_offset;
logic [10:0] next_font_addr, hold_font_addr;
logic [9:0] sprite_addr;
logic [7:0] data;
logic [3:0] digit;
logic [2:0] data_idx;
logic [23:0] cur_sprite;
logic [23:0] score_digits_in;
logic [2:0] back_rgb_idx;
logic [4:0] rgb_idx;
logic [9:0] xdraw_counter, ydraw_counter;
logic [4:0] nh_offset;
logic [9:0] holdx_min, holdx_max, nextx_min, nextx_max;
logic [9:0] sprite_holdx_min, sprite_holdx_max, sprite_nextx_min, sprite_nextx_max;
logic [9:0] sprite_holdy_min, sprite_holdy_max, sprite_nexty_min, sprite_nexty_max;
logic [9:0] sprite_holdx_min1, sprite_holdx_min2, sprite_holdx_max1, sprite_holdx_max2;
logic [9:0] sprite_nextx_min1, sprite_nextx_min2, sprite_nextx_max1, sprite_nextx_max2;
logic score_area, play_area, hold_area, next_area;
logic sp_areax1_min, sp_areax2_min, sp_areax1_max, sp_areax2_max;
logic sp_areax_min, sp_areax_max, sp_areay_min, sp_areay_max;

assign sprite_holdx_min1 = 10'd230;
assign sprite_holdx_max1 = 10'd309;
assign sprite_holdx_min2 = 10'd550;
assign sprite_holdx_max2 = 10'd630;
assign sprite_holdy_min = 10'd140;
assign sprite_holdy_max = 10'd179;

assign sprite_nextx_min1 = 10'd230;
assign sprite_nextx_max1 = 10'd309;
assign sprite_nextx_min2 = 10'd550;
assign sprite_nextx_max2 = 10'd629;
assign sprite_nexty_min = 10'd60;
assign sprite_nexty_max = 10'd99;

assign score_digits_in = score_area1 ? score_digits_in1 : score_digits_in2;
assign xdraw_counter = xdraw_counter1;
assign ydraw_counter = ydraw_counter1;
assign score_area = score_area1 | score_area2;
assign holdx_min = DrawX < 10'd320 ? holdx_min1 : holdx_min2;
assign holdx_max = DrawX < 10'd320 ? holdx_max1 : holdx_max2;
assign nextx_min = DrawX < 10'd320 ? nextx_min1 : nextx_min2;
assign nextx_max = DrawX < 10'd320 ? nextx_max1 : nextx_max2;
assign sprite_holdx_min = DrawX < 10'd320 ? sprite_holdx_min1 : sprite_holdx_min2;
assign sprite_holdx_max = DrawX < 10'd320 ? sprite_holdx_max1 : sprite_holdx_max2;
assign sprite_nextx_min = DrawX < 10'd320 ? sprite_nextx_min1 : sprite_nextx_min2;
assign sprite_nextx_max = DrawX < 10'd320 ? sprite_nextx_max1 : sprite_nextx_max2;
assign held_block = DrawX < 10'd320 ? held_block1 : held_block2;
assign block_idx = DrawX < 10'd320 ? block_idx1 : block_idx2;

assign play_area = play_area1 | play_area2;
assign hold_area = (DrawX >= holdx_min && DrawX <= holdx_max && DrawY >= holdy_min && DrawY <= holdy_max);
assign next_area = (DrawX >= nextx_min && DrawX <= nextx_max && DrawY >= nexty_min && DrawY <= nexty_max);

assign nfont_xmax = nextx_min + 7;
assign efont_xmax = nextx_min + 15;
assign xfont_xmax = nextx_min + 23;
assign tfont_xmax = nextx_max;

assign hfont_xmax = holdx_min + 7;
assign ofont_xmax = holdx_min + 15;
assign lfont_xmax = holdx_min + 23;
assign dfont_xmax = holdx_max;

assign nh_offset = xdraw_counter >= 10 ? xdraw_counter - 10 : xdraw_counter + 10;

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
assign data_idx = score_area ? 7 - DrawX[2:0] : 7 - (DrawX[2:0]-4);
assign cur_sprite = sprite_palette[rgb_idx];

always_comb
begin
  addr = addr_offset + DrawY - 11'd15;
  if (next_area)
    addr = next_font_addr;
  else if (hold_area)
    addr = hold_font_addr;
end

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
  
  hold_font_addr = 11'd1152;
  if (DrawX <= hfont_xmax)
    hold_font_addr = 11'd1152 + DrawY - 120;
  else if (DrawX <= ofont_xmax)
    hold_font_addr = 11'd1264 + DrawY - 120;
  else if (DrawX <= lfont_xmax)
    hold_font_addr = 11'd1216 + DrawY - 120;
  else if (DrawX <= dfont_xmax)
    hold_font_addr = 11'd1088 + DrawY - 120;
end

font_rom text_rom(.*);

logic valid_nsprite, valid_hsprite;

always_comb
begin
  sprite_addr = 0;
  block_type = EMPTY;
  if (play_area) begin
    block_type = play_area1 ? block_type1 : block_type2;
    sprite_addr = ydraw_counter*10'd20 + xdraw_counter;
  end
  else if (DrawX >= sprite_holdx_min && DrawX <= sprite_holdx_max && DrawY >= sprite_holdy_min && DrawY <= sprite_holdy_max) begin
    block_type = held_block;
    sprite_addr = ydraw_counter*10'd20 + nh_offset;
  end
  else if (DrawX >= sprite_nextx_min && DrawX <= sprite_nextx_max && DrawY >= sprite_nexty_min && DrawY <= sprite_nexty_max) begin
    block_type = block_color'(block_idx+1);
    sprite_addr = ydraw_counter*10'd20 + nh_offset;
  end

  valid_nsprite = 1'b0;
  case (block_type)
    CYAN: begin
      valid_nsprite = (DrawX >= sprite_nextx_min && DrawX <= sprite_nextx_max && DrawY >= sprite_nexty_min && DrawY <= (sprite_nexty_min+19));
    end
    BLUE: begin
      valid_nsprite = (DrawX >= sprite_nextx_min && DrawX <= (sprite_nextx_min+19) && DrawY >= sprite_nexty_min && DrawY <= (sprite_nexty_min+19)) ||
          (DrawX >= sprite_nextx_min && DrawX <= (sprite_nextx_min+59) && DrawY >= (sprite_nexty_min+20) && DrawY <= (sprite_nexty_min+39));
    end
    ORANGE: begin
      valid_nsprite = (DrawX >= (sprite_nextx_min+40) && DrawX <= (sprite_nextx_min+59) && DrawY >= sprite_nexty_min && DrawY <= (sprite_nexty_min+19)) ||
          (DrawX >= sprite_nextx_min && DrawX <= (sprite_nextx_min+59) && DrawY >= (sprite_nexty_min+20) && DrawY <= (sprite_nexty_min+39));
    end
    YELLOW: begin
      valid_nsprite = (DrawX >= (sprite_nextx_min+20) && DrawX <= (sprite_nextx_min+59) && DrawY >= sprite_nexty_min && DrawY <= (sprite_nexty_min+19)) ||
          (DrawX >= (sprite_nextx_min+20) && DrawX <= (sprite_nextx_min+59) && DrawY >= (sprite_nexty_min+20) && DrawY <= (sprite_nexty_min+39));
    end
    GREEN: begin
      valid_nsprite = (DrawX >= (sprite_nextx_min+20) && DrawX <= (sprite_nextx_min+59) && DrawY >= sprite_nexty_min && DrawY <= (sprite_nexty_min+19)) ||
          (DrawX >= sprite_nextx_min && DrawX <= (sprite_nextx_min+39) && DrawY >= (sprite_nexty_min+20) && DrawY <= (sprite_nexty_min+39));
    end
    RED: begin
      valid_nsprite = (DrawX >= sprite_nextx_min && DrawX <= (sprite_nextx_min+39) && DrawY >= sprite_nexty_min && DrawY <= (sprite_nexty_min+19)) ||
          (DrawX >= (sprite_nextx_min+20) && DrawX <= (sprite_nextx_min+59) && DrawY >= (sprite_nexty_min+20) && DrawY <= (sprite_nexty_min+39));
    end
    MAGENTA: begin
      valid_nsprite = (DrawX >= (sprite_nextx_min+20) && DrawX <= (sprite_nextx_min+39) && DrawY >= sprite_nexty_min && DrawY <= (sprite_nexty_min+19)) ||
          (DrawX >= sprite_nextx_min && DrawX <= (sprite_nextx_min+59) && DrawY >= (sprite_nexty_min+20) && DrawY <= (sprite_nexty_min+39));
    end
    default:
      valid_nsprite = (DrawX >= sprite_nextx_min && DrawX <= sprite_nextx_max && DrawY >= sprite_nexty_min && DrawY <= (sprite_nexty_min+19));
  endcase


  valid_hsprite = 1'b0;
  // Very similar logic to next sprite data, but using different boundaries
  case (block_type)
    CYAN: begin
      valid_nsprite = (DrawX >= sprite_holdx_min && DrawX <= sprite_holdx_max && DrawY >= sprite_holdy_min && DrawY <= (sprite_holdy_min+19));
    end
    BLUE: begin
      valid_nsprite = (DrawX >= sprite_holdx_min && DrawX <= (sprite_holdx_min+19) && DrawY >= sprite_holdy_min && DrawY <= (sprite_holdy_min+19)) ||
          (DrawX >= sprite_holdx_min && DrawX <= (sprite_holdx_min+59) && DrawY >= (sprite_holdy_min+20) && DrawY <= (sprite_holdy_min+39));
    end
    ORANGE: begin
      valid_nsprite = (DrawX >= (sprite_holdx_min+40) && DrawX <= (sprite_holdx_min+59) && DrawY >= sprite_holdy_min && DrawY <= (sprite_holdy_min+19)) ||
          (DrawX >= sprite_holdx_min && DrawX <= (sprite_holdx_min+59) && DrawY >= (sprite_holdy_min+20) && DrawY <= (sprite_holdy_min+39));
    end
    YELLOW: begin
      valid_nsprite = (DrawX >= (sprite_holdx_min+20) && DrawX <= (sprite_holdx_min+59) && DrawY >= sprite_holdy_min && DrawY <= (sprite_holdy_min+19)) ||
          (DrawX >= (sprite_holdx_min+20) && DrawX <= (sprite_holdx_min+59) && DrawY >= (sprite_holdy_min+20) && DrawY <= (sprite_holdy_min+39));
    end
    GREEN: begin
      valid_nsprite = (DrawX >= (sprite_holdx_min+20) && DrawX <= (sprite_holdx_min+59) && DrawY >= sprite_holdy_min && DrawY <= (sprite_holdy_min+19)) ||
          (DrawX >= sprite_holdx_min && DrawX <= (sprite_holdx_min+39) && DrawY >= (sprite_holdy_min+20) && DrawY <= (sprite_holdy_min+39));
    end
    RED: begin
      valid_nsprite = (DrawX >= sprite_holdx_min && DrawX <= (sprite_holdx_min+39) && DrawY >= sprite_holdy_min && DrawY <= (sprite_holdy_min+19)) ||
          (DrawX >= (sprite_holdx_min+20) && DrawX <= (sprite_holdx_min+59) && DrawY >= (sprite_holdy_min+20) && DrawY <= (sprite_holdy_min+39));
    end
    MAGENTA: begin
      valid_nsprite = (DrawX >= (sprite_holdx_min+20) && DrawX <= (sprite_holdx_min+39) && DrawY >= sprite_holdy_min && DrawY <= (sprite_holdy_min+19)) ||
          (DrawX >= sprite_holdx_min && DrawX <= (sprite_holdx_min+59) && DrawY >= (sprite_holdy_min+20) && DrawY <= (sprite_holdy_min+39));
    end
    default: ;
  endcase

  if (play_area) begin
    red = cur_sprite[23:16];
    green = cur_sprite[15:8];
    blue = cur_sprite[7:0];
  end
  // Font for score, next, and hold
  else if ((score_area | hold_area | next_area) && data[data_idx] == 1'b1) begin
    red = 8'hff;
    green = 8'hff;
    blue = 8'hff;
  end
  // Same as play area, just here to have it be seen separately
  else if (valid_nsprite | valid_hsprite) begin
    red = cur_sprite[23:16];
    green = cur_sprite[15:8];
    blue = cur_sprite[7:0];
  end
  // Background when not in play or score area
  else begin
    red = 8'h1f;
    green = 8'h00;
    blue = 8'h7f - {1'b0, DrawX[9:3]};
  end
end

endmodule