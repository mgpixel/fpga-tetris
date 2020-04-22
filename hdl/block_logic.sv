//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  block_logic( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               input [31:0]   keycode,
               input logic [4:0] can_move,
               output logic  play_area,          // Current coordinates in play area
               output logic [4:0] x_coord,
               output logic [4:0] y_coord,
               output logic [19:0] x_block,
               output logic [19:0] y_block,
               output logic [19:0] save_yblock,
               output logic [19:0] save_xblock,
               output logic [19:0] x_move_left,
               output logic [19:0] x_move_right,
               output logic [19:0] x_move_down,
               output logic [19:0] x_rotate_left,
               output logic [19:0] x_rotate_right,
               output logic [19:0] y_move_left,
               output logic [19:0] y_move_right,
               output logic [19:0] y_move_down,
               output logic [19:0] y_rotate_left,
               output logic [19:0] y_rotate_right,
               output logic get_new_block,
               output block_color block
              );
    
parameter [9:0] x_min = 10'd0;       // Leftmost point on the X axis
parameter [9:0] x_max = 10'd639;     // Rightmost point on the X axis
parameter [9:0] y_min = 10'd0;       // Topmost point on the Y axis
parameter [9:0] y_max = 10'd479;     // Bottommost point on the Y axis
parameter [9:0] playx_min = 10'd220;
parameter [9:0] playx_max = 10'd419;
parameter [9:0] playy_min = 10'd40;
parameter [9:0] playy_max = 10'd439;
parameter [9:0] y_step = 10'd20;

// Indices corresponding to starting coordinates of block and color
parameter [2:0] I_CYAN = 3'd0;
parameter [2:0] J_BLUE = 3'd1;
parameter [2:0] L_ORANGE = 3'd2;
parameter [2:0] O_YELLOW = 3'd3;
parameter [2:0] P_GREEN = 3'd4;
parameter [2:0] T_MAGENTA = 3'd5;
parameter [2:0] Z_RED = 3'd6; 

logic [19:0] x_block_choices [7];
logic [19:0] y_block_choices [7];
block_color block_color_choices [7];

// Assign starting coordinates for when a block is generated
assign x_block_choices[I_CYAN] = {5'd3, 5'd4, 5'd5, 5'd6};
assign y_block_choices[I_CYAN] = 20'd0;

assign x_block_choices[J_BLUE] = {5'd4, 5'd4, 5'd5, 5'd6};
assign y_block_choices[J_BLUE] = {5'd0, 5'd1, 5'd1, 5'd1};

assign x_block_choices[L_ORANGE] = {5'd6, 5'd6, 5'd5, 5'd4};
assign y_block_choices[L_ORANGE] = {5'd0, 5'd1, 5'd1, 5'd1};

assign x_block_choices[O_YELLOW] = {5'd4, 5'd5, 5'd4, 5'd5};
assign y_block_choices[O_YELLOW] = {5'd0, 5'd0, 5'd1, 5'd1};

assign x_block_choices[P_GREEN] = {5'd6, 5'd5, 5'd5, 5'd4};
assign y_block_choices[P_GREEN] = {5'd0, 5'd0, 5'd1, 5'd1};

assign x_block_choices[T_MAGENTA] = {5'd4, 5'd5, 5'd5, 5'd6};
assign y_block_choices[T_MAGENTA] = {5'd1, 5'd0, 5'd1, 5'd1};

assign x_block_choices[Z_RED] = {5'd4, 5'd5, 5'd5, 5'd6};
assign y_block_choices[Z_RED] = {5'd0, 5'd1, 5'd0, 5'd1};

// Corresponding colors to blocks
assign block_color_choices[I_CYAN] = CYAN;
assign block_color_choices[J_BLUE] = BLUE;
assign block_color_choices[L_ORANGE] = ORANGE;
assign block_color_choices[O_YELLOW] = YELLOW;
assign block_color_choices[P_GREEN] = GREEN;
assign block_color_choices[T_MAGENTA] = MAGENTA;
assign block_color_choices[Z_RED] = RED;

logic [7:0] A, S, D, J, K, L;
logic [5:0] down_counter;
logic [5:0] down_counter_in;
logic [2:0] key_counter;
logic [2:0] key_counter_in;

logic [19:0] move_x;
logic [19:0] move_y;

logic left_valid;
logic right_valid;
logic rotate_right_valid;
logic rotate_left_valid;
logic down_valid;

assign x_move_left = {x_block[19:15]-5'd1, x_block[14:10]-5'd1, x_block[9:5]-5'd1, x_block[4:0]-5'd1};
assign y_move_left = y_block;
assign x_move_right = {x_block[19:15]+5'd1, x_block[14:10]+5'd1, x_block[9:5]+5'd1, x_block[4:0]+5'd1};
assign y_move_right = y_block;
assign x_move_down = x_block;
assign y_move_down = {y_block[19:15]+5'd1, y_block[14:10]+5'd1, y_block[9:5]+5'd1, y_block[4:0]+5'd1};

assign left_valid = can_move[4];
assign right_valid = can_move[3];
assign rotate_right_valid = can_move[2];
assign rotate_left_valid = can_move[1];
assign down_valid = can_move[0];

orientation cur_orientation;
orientation new_orientation;

// Hex values corresponding to keys pressed from keyboard
assign A = 8'h04;
assign S = 8'h16;
assign D = 8'h07;
assign J = 8'h0d;
assign K = 8'h0e;
assign L = 8'h0f;

// Default block color for testing
assign block = block_color_choices[T_MAGENTA];

logic move_left;
logic move_right;
logic speed_down;
logic rotate_left;
logic rotate_right;
logic hold_block;

logic [7:0] key;
logic [7:0] key2;
logic [7:0] key3;
logic [7:0] key4;

// Keycode holds first 4 keys being pressed at a time, split for comparisons
assign key = keycode[7:0];
assign key2 = keycode[15:8];
assign key3 = keycode[23:16];
assign key4 = keycode[31:24];

// Detect keycodes by comparing every keycode read
assign move_left = (key == A) | (key2 == A) | (key3 == A) | (key4 == A);
assign move_right = (key == D) | (key2 == D) | (key3 == D) | (key4 == D);
assign speed_down = (key == S) | (key2 == S) | (key3 == S) | (key4 == S);
assign rotate_left = (key == J) | (key2 == J) | (key3 == J) | (key4 == J);
assign rotate_right = (key == L) | (key2 == L) | (key3 == L) | (key4 == L);
assign hold_block = (key == K) | (key2 == K) | (key3 == K) | (key4 == K);

// Detect rising edge of frame_clk
logic frame_clk_delayed, frame_clk_rising_edge;
always_ff @ (posedge Clk)
begin
  if (Reset) begin
    down_counter <= 6'd0;
    key_counter <= 3'd1;
    x_block <= x_block_choices[T_MAGENTA];
    y_block <= y_block_choices[T_MAGENTA];
    cur_orientation <= NORMAL;
  end
  else begin
    down_counter <= down_counter_in;
    key_counter <= key_counter_in;
    if (get_new_block) begin
      x_block <= x_block_choices[T_MAGENTA];
      y_block <= y_block_choices[T_MAGENTA];
      save_xblock <= x_block_choices[T_MAGENTA];
      save_yblock <= y_block_choices[T_MAGENTA];
      cur_orientation <= NORMAL;
    end
    else begin
      save_xblock <= x_block;
      save_yblock <= y_block;
      x_block <= move_x;
      y_block <= move_y;
      cur_orientation <= new_orientation;
    end
  end
  frame_clk_delayed <= frame_clk;
  frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
end

rotate_blocks rotater_left(
  .rotate_left(1'b1),
  .x_block(save_xblock),
  .y_block(save_yblock),
  .rot_xblock(x_rotate_left),
  .rot_yblock(y_rotate_left),
  .*
);

rotate_blocks rotater_right(
  .rotate_left(1'b0),
  .x_block(save_xblock),
  .y_block(save_yblock),
  .rot_xblock(x_rotate_right),
  .rot_yblock(y_rotate_right),
  .*
);

always_comb
begin
  down_counter_in = down_counter;
  move_x = x_block;
  move_y = y_block;
  new_orientation = cur_orientation;
  key_counter_in = key_counter;
  get_new_block = 1'b0;
  // Update position and motion only at rising edge of frame clock
  if (frame_clk_rising_edge && down_counter == 6'd20) begin
    if (down_valid) begin
      move_y = y_move_down;
    end
    // Reached the end, spawn a new block
    else begin
      get_new_block = 1'b1;
    end
  end
  else if (frame_clk_rising_edge && key_counter == 3'd0) begin
    // Rotation movement
    if (rotate_left && rotate_left_valid) begin
      move_x = x_rotate_left;
      move_y = y_rotate_left;
      case (cur_orientation)
        NORMAL:
          new_orientation = ROT_LEFT;
        ROT_LEFT:
          new_orientation = ROT2;
        ROT2:
          new_orientation = ROT_RIGHT;
        ROT_RIGHT:
          new_orientation = NORMAL;
        default:
          new_orientation = NORMAL;
      endcase
    end
    else if (rotate_right && rotate_right_valid) begin
      move_x = x_rotate_right;
      move_y = y_rotate_right;
      case (cur_orientation)
        NORMAL:
          new_orientation = ROT_RIGHT;
        ROT_RIGHT:
          new_orientation = ROT2;
        ROT2:
         new_orientation = ROT_LEFT;
        ROT_LEFT:
         new_orientation = NORMAL;
        default:
          new_orientation = NORMAL;
      endcase
    end
    // Linear movement
    else if (move_right && right_valid) begin
      move_x = x_move_right;
      move_y = y_move_right;
    end
    else if (move_left && left_valid) begin
      move_x = x_move_left;
      move_y = y_move_left;
    end
  end
  // Update counters on the frame clock to be synced with game
  if (frame_clk_rising_edge) begin
    down_counter_in = down_counter_in + 6'd1;
    key_counter_in = key_counter_in + 3'd1;
    if (down_counter_in >= 6'd21)
      down_counter_in = 6'd1;
  end
end

always_comb begin
  play_area = 1'b0;
  x_coord = 5'd0;
  y_coord = 5'd0;

  // Determines that board.sv should output current pixel rather than the background
  if (DrawX <= playx_max && DrawX >= playx_min && DrawY >= playy_min && DrawY <= playy_max) begin
    // Using two of our multipliers to divide (I think)
    x_coord = (DrawX - playx_min) / 20;
    y_coord = (DrawY - playy_min) / 20;
    play_area = 1'b1;
  end
end

endmodule
