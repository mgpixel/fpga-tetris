import types::*;

module block_color_mapper
(
  input play_area,
  input block_color block_type,
  input [9:0] DrawX, DrawY,
  output logic [7:0] VGA_R, VGA_G, VGA_B
);

logic [7:0] red, green, blue;


assign VGA_R = red;
assign VGA_G = green;
assign VGA_B = blue;

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
  // Default colors when not in play area
  else begin
    red = 8'h1f;
    green = 8'h00;
    blue = 8'h7f - {1'b0, DrawX[9:3]};
  end
end

endmodule