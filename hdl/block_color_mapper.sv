import types::*;

module block_color_mapper
(
  input play_area,
  input score_area,
  input block_color block_type,
  input logic [23:0] score_digits_in,
  input [9:0] DrawX, DrawY,
  output logic [7:0] VGA_R, VGA_G, VGA_B
);

parameter [9:0] scorex_min = 10'd296;
parameter [9:0] scorex_max = 10'd343;
parameter [9:0] digit5_xmax = scorex_min + 7;
parameter [9:0] digit4_xmax = scorex_min + 15;
parameter [9:0] digit3_xmax = scorex_min + 23;
parameter [9:0] digit2_xmax = scorex_min + 31;
parameter [9:0] digit1_xmax = scorex_min + 39;
parameter [9:0] digit0_xmax = scorex_max;

logic [7:0] red, green, blue;
logic [10:0] addr;
logic [10:0] addr_offset;
logic [7:0] data;
logic [3:0] digit;
logic [2:0] data_idx;

assign VGA_R = red;
assign VGA_G = green;
assign VGA_B = blue;
assign addr = score_area ? addr_offset + DrawY - 11'd10 : 11'd0;
assign data_idx = score_area ? 7 - DrawX[2:0] : 0;

// Logic to pick correct address in font_rom for score keeping
always_comb
begin
  addr_offset = 11'd768;
  digit = score_digits_in[23:19];
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
end

font_rom text_rom(.*);

always_comb
begin
  if (play_area) begin
    // Each square in the play area is determined by 4 bits, with the outside
    // area being also 4 bits corresponding to different colors
    unique case (block_type)
      // Empty will just be black since no block occupies the space
      EMPTY: begin
        red = 8'd0;
        green = 8'd0;
        blue = 8'd0;
      end
      CYAN: begin
        red = 8'd0;
        green = 8'd255;
        blue = 8'd255;
      end
      BLUE: begin
        red = 8'd0;
        green = 8'd0;
        blue = 8'd255;
      end
      ORANGE: begin
        red = 8'd255;
        green = 8'd165;
        blue = 8'd0;
      end
      YELLOW: begin
        red = 8'd255;
        green = 8'd255;
        blue = 8'd0;
      end
      GREEN: begin
        red = 8'd0;
        green = 8'd128;
        blue = 8'd0;
      end
      RED: begin
        red = 8'd255;
        green = 8'd0;
        blue = 8'd0;
      end
      MAGENTA: begin
        red = 8'd255;
        green = 8'd0;
        blue = 8'd255;
      end
    endcase
  end
  else if (score_area && data[data_idx] == 1'b1) begin
    red = 8'hff;
    green = 8'hff;
    blue = 8'hff;
  end
  // Default colors when not in play area
  else begin
    red = 8'h1f;
    green = 8'h00;
    blue = 8'h7f - {1'b0, DrawX[9:3]};
  end
end

endmodule