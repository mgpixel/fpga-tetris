import types::*;

module rotate_blocks
(
  input block_color block,
  input logic [19:0] x_block,
  input logic [19:0] y_block,
  input logic rot_left,
  input orientation cur_orientation,
  output logic [19:0] rot_xblock,
  output logic [19:0] rot_yblock
);

// If time allows, come up with actual math for this. For now,
// some messy systemverilog is ahead.
always_comb
begin
  rot_xblock = 20'd0;
  rot_yblock = 20'd0;

  // Stars represent beginning orientation of the block
  case (block)
    /* **** */
    CYAN: begin
      if (rot_left == 1'b1) begin
        case (cur_orientation)
          NORMAL: begin
            rot_xblock = y_block;
            rot_yblock = x_block[0 +: 20];
          end
          ROT_LEFT: begin
            rot_xblock = y_block;
            rot_yblock = {y_block[9:5], y_block[9:5], y_block[9:5], y_block[9:5]};
          end
          ROT2: begin
            rot_xblock = y_block;
            rot_yblock = x_block;
          end
          ROT_RIGHT: begin
            rot_xblock = y_block[0 +: 20];
            rot_yblock = {y_block[14:10], y_block[14:10], y_block[14:10], y_block[14:10]};
          end
          default: begin
            rot_xblock = y_block;
            rot_yblock = x_block[0 +: 20];
          end
        endcase
      end
      else begin
        case (cur_orientation)
          NORMAL: begin
            rot_xblock = {x_block[9:5], x_block[9:5], x_block[9:5], x_block[9:5]};
            rot_yblock = x_block;
          end
          ROT_RIGHT: begin
            rot_xblock = y_block;
            rot_yblock = x_block;
          end
          ROT2: begin
            rot_xblock = {x_block[14:10], x_block[14:10], x_block[14:10], x_block[14:10]};
            rot_yblock = x_block;
          end
          ROT_LEFT: begin
            rot_xblock = y_block;
            rot_yblock = x_block[0 +: 20];
          end
        endcase
      end
    end
    /* *
       *** */
    BLUE: begin
      ;
    end
    ORANGE: begin
      ;
    end
    /* **
       ** */
    // do nothing for square
    YELLOW: begin
      ;
    end
    /*  **
       **  */
    GREEN: begin
      ;
    end
    /* **
        ** */
    RED: begin
      ;
    end
    /*  *
       *** */
    MAGENTA: begin
      ;
    end
  endcase
end

endmodule