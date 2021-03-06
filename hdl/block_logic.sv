//-------------------------------------------------------------------------
//    (Originally) Ball.sv                                               --
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
//    block_logic.sv
//    Jiawei Huang
//    Marcos Garcia
//    Spring 2020
//
//    Holds most of the game logic, sending signals as needed to the tetris
//    board and logic for drawing onto the screen


module  block_logic( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               input [31:0]   keycode,
               input logic [9:0] playx_max, playx_min, playy_max, playy_min,
               input logic [9:0] scorex_min, scorex_max, scorey_min, scorey_max,
               input logic [4:0] can_move,
               input logic BOARD_BUSY,
               input logic [1:0] player_num,
               input logic [5:0] level_speed,
               input VGA_CLK,
               output logic play_area,          // Current coordinates in play area
               output logic score_area,
               output logic [4:0] x_coord,
               output logic [4:0] y_coord,
               output logic [19:0] x_block=x_block_choices[T_MAGENTA],
               output logic [19:0] y_block=y_block_choices[T_MAGENTA],
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
               output logic [9:0] xdraw_counter,
               output logic [9:0] ydraw_counter,
               output logic get_new_block,
               output logic frame_clk_rising_edge,
               output logic [2:0] block_idx,
               output block_color held_block,
               output block_color block
              );
    
parameter [9:0] x_min = 10'd0;       // Leftmost point on the X axis
parameter [9:0] x_max = 10'd639;     // Rightmost point on the X axis
parameter [9:0] y_min = 10'd0;       // Topmost point on the Y axis
parameter [9:0] y_max = 10'd479;     // Bottommost point on the Y axis
parameter [3:0] s_speed = 4'd1;

// Indices corresponding to starting coordinates of block and color
parameter [2:0] I_CYAN = 3'd0;
parameter [2:0] J_BLUE = 3'd1;
parameter [2:0] L_ORANGE = 3'd2;
parameter [2:0] O_YELLOW = 3'd3;
parameter [2:0] P_GREEN = 3'd4;
parameter [2:0] T_MAGENTA = 3'd5;
parameter [2:0] Z_RED = 3'd6;

parameter [9:0] HPLAY_TOTAL = 10'd19;
parameter [9:0] VPLAY_TOTAL = 10'd19;
logic [2:0] player_move;

// Possible choices to choose from corresponding to index in array
logic [19:0] x_block_choices [7];
logic [19:0] y_block_choices [7];

block_color block_color_choices [7];
block_color block_in;
logic switch_block;
logic is_block_switched;
logic replace_block;
logic [3:0] i;

logic [7:0] A, S, D, F, G, H, COMMA_KEY, PERIOD_KEY, BACKSLASH_KEY, ONE_KEY, TWO_KEY, THREE_KEY;
logic [5:0] down_counter;
logic [5:0] down_counter_in;
logic [2:0] cur_block_idx, block_idx_in, switch_block_idx;

logic [19:0] move_x, move_y;
logic [19:0] save_xblock_in, save_yblock_in;

logic [9:0] xdraw_counter_in, ydraw_counter_in;

logic left_valid;
logic right_valid;
logic rotate_right_valid;
logic rotate_left_valid;
logic down_valid;

orientation cur_orientation=NORMAL;
orientation new_orientation;

logic move_left, move_right, speed_down, rotate_left, rotate_right, hold_block;
logic old_moveleft, old_moveright, old_rotleft, old_rotright;
logic a_released, s_released, d_released, j_released, k_released, l_released;

// Creating possible moves tetromino may move linearly
assign x_move_left = {x_block[19:15]-5'd1, x_block[14:10]-5'd1, x_block[9:5]-5'd1, x_block[4:0]-5'd1};
assign y_move_left = y_block;
assign x_move_right = {x_block[19:15]+5'd1, x_block[14:10]+5'd1, x_block[9:5]+5'd1, x_block[4:0]+5'd1};
assign y_move_right = y_block;
assign x_move_down = x_block;
assign y_move_down = {y_block[19:15]+5'd1, y_block[14:10]+5'd1, y_block[9:5]+5'd1, y_block[4:0]+5'd1};

// Data from board.sv, specifies if the move is valid based on possible moves
assign left_valid = can_move[4];
assign right_valid = can_move[3];
assign rotate_right_valid = can_move[2];
assign rotate_left_valid = can_move[1];
assign down_valid = can_move[0];

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
assign y_block_choices[Z_RED] = {5'd0, 5'd0, 5'd1, 5'd1};

// Corresponding colors to blocks
assign block_color_choices[I_CYAN] = CYAN;
assign block_color_choices[J_BLUE] = BLUE;
assign block_color_choices[L_ORANGE] = ORANGE;
assign block_color_choices[O_YELLOW] = YELLOW;
assign block_color_choices[P_GREEN] = GREEN;
assign block_color_choices[T_MAGENTA] = MAGENTA;
assign block_color_choices[Z_RED] = RED;

// Hex values corresponding to keys pressed from keyboard
assign A = keycode[0];
assign S = keycode[1];
assign D = keycode[2];
assign F = keycode[3];
assign G = keycode[4];
assign H = keycode[5];

assign COMMA_KEY = keycode[6];
assign PERIOD_KEY = keycode[7];
assign BACKSLASH_KEY = keycode[8];
assign ONE_KEY = keycode[9];
assign TWO_KEY = keycode[10]; 
assign THREE_KEY = keycode[11];

logic [7:0] kleft, kright, kdown, krotleft, krotright, khold;

assign kleft = player_num == 2'b1 ? A : COMMA_KEY;
assign kright = player_num == 2'b1 ? D : BACKSLASH_KEY;
assign kdown = player_num == 2'b1 ? S : PERIOD_KEY;
assign krotleft = player_num == 2'b1 ? F : ONE_KEY;
assign krotright = player_num == 2'b1 ? G : THREE_KEY;
assign khold = player_num == 2'b1 ? H : TWO_KEY;

// Detect keycodes by checking the bits of keycode data passed in
assign move_left = kleft != 8'd0;
assign move_right = kright != 8'd0;
assign speed_down = kdown != 8'd0;
assign rotate_left = krotleft != 8'd0;
assign rotate_right = krotright != 8'd0;
assign hold_block = khold != 8'd0;

logic left_held, right_held, rotate_left_held, rotate_right_held;
logic [3:0] speed_counter, speed_counter_in;

assign left_held = (old_moveleft == move_left);
assign right_held = (old_moveright == move_right);
assign rotate_left_held = (old_rotleft == rotate_left);
assign rotate_right_held = (old_rotright == rotate_right);

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

tetromino_generator block_gen(
  .new_block(get_new_block | replace_block),
  .new_move(player_move),
  .block_idx(block_idx),
  .*
);

// When a new block is gotten, set the appropriate inputs for registers
function void setNewBlockInputs(logic [2:0] idx);
  move_x = x_block_choices[idx];
  move_y = y_block_choices[idx];
  save_xblock_in = x_block_choices[idx];
  save_yblock_in = y_block_choices[idx];
  block_in = block_color_choices[idx];
  block_idx_in = block_idx;
  new_orientation = NORMAL;
  down_counter_in = 0;
  speed_counter_in = 0;
endfunction

// Detect rising edge of frame_clk
logic frame_clk_delayed;
always_ff @ (posedge Clk)
begin
  if (Reset) begin
    down_counter <= 6'd0;
    cur_orientation <= NORMAL;
    speed_counter <= 4'd0;
    x_block <= x_block_choices[block_idx];
    y_block <= y_block_choices[block_idx];
    block <= block_color_choices[block_idx];
    save_xblock <= x_block_choices[block_idx];
    save_yblock <= y_block_choices[block_idx];
    cur_block_idx <= block_idx;
    is_block_switched <= 1'b0;
    held_block <= EMPTY;
  end
  else begin
    x_block <= move_x;
    y_block <= move_y;
    save_xblock <= save_xblock_in;
    save_yblock <= save_yblock_in;
    if (switch_block) begin
      held_block <= block;
      switch_block_idx <= cur_block_idx;
      is_block_switched <= 1'b1;
    end
    else if (get_new_block)
      is_block_switched <= 1'b0;
    block <= block_in;
    cur_block_idx <= block_idx_in;
    cur_orientation <= new_orientation;
    down_counter <= down_counter_in;
    speed_counter <= speed_counter_in;
  end
  frame_clk_delayed <= frame_clk;
  frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
end

always_ff @(posedge Clk)
begin
  if (frame_clk_rising_edge) begin
    old_moveleft <= move_left;
    old_moveright <= move_right;
    old_rotleft <= rotate_left;
    old_rotright <= rotate_right;
  end
end

always_ff @(posedge VGA_CLK) begin
  if (Reset) begin
    xdraw_counter <= 10'd0;
    ydraw_counter <= 10'd0;
  end
  else begin
    xdraw_counter <= xdraw_counter_in;
    ydraw_counter <= ydraw_counter_in;
  end
end

always_comb
begin
  down_counter_in = down_counter;
  speed_counter_in = speed_counter;
  move_x = x_block;
  move_y = y_block;
  save_xblock_in = x_block;
  save_yblock_in = y_block;
  block_in = block;
  new_orientation = cur_orientation;
  get_new_block = 1'b0;
  player_move = 3'd0;
  block_idx_in = cur_block_idx;
  switch_block = 1'b0;
  replace_block = 1'b0;

  if (Reset || BOARD_BUSY == 1'b1) /* do nothing */ ;
  // Update position and motion only at rising edge of frame clock
  else if (frame_clk_rising_edge && (down_counter >= level_speed)) begin
    if (down_valid) begin
      player_move = 3'd2;
      move_y = y_move_down;
      down_counter_in = 6'd0;
    end
    // Reached the end, spawn a new block
    else begin
      setNewBlockInputs(block_idx);
      get_new_block = 1'b1;
      player_move = cur_block_idx + 3'd1;
    end
  end
  else if (frame_clk_rising_edge) begin
    // Rotation movement
    if (rotate_left && rotate_left_valid && rotate_left_held == 1'b0) begin
      move_x = x_rotate_left;
      move_y = y_rotate_left;
      player_move = 3'd6;
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
    else if (rotate_right && rotate_right_valid && rotate_right_held == 1'b0) begin
      move_x = x_rotate_right;
      move_y = y_rotate_right;
      player_move = 3'd5;
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
    else if (move_right && right_valid && right_held == 1'b0) begin
      player_move = 3'd4;
      move_x = x_move_right;
      move_y = y_move_right;
    end
    else if (move_left && left_valid && left_held == 1'b0) begin
      player_move = 3'd3;
      move_x = x_move_left;
      move_y = y_move_left;
    end
    else if (speed_down == 1'b1) begin
      speed_counter_in = speed_counter_in + 4'd1;
      down_counter_in = down_counter + 6'd1;
      if (speed_counter >= s_speed) begin
        speed_counter_in = 4'd0;
        // Don't have it speed down at top for when a new block spawns
        if (down_valid && y_block[19:15] != 5'd0 && y_block[14:10] != 5'd0 &&
            y_block[9:5] != 5'd0 && y_block[4:0] != 5'd0) begin
          down_counter_in = 6'd0;
          move_y = y_move_down;
        end
        else if (down_valid == 1'b0) begin
          setNewBlockInputs(block_idx);
          get_new_block = 1'b1;
          player_move = cur_block_idx + 1'd1;
        end
      end
    end
    else if (hold_block && is_block_switched == 1'b0) begin
      switch_block = 1'b1;
      if (held_block != EMPTY) begin
        setNewBlockInputs(switch_block_idx);
      end
      else begin
        setNewBlockInputs(block_idx);
        replace_block = 1'b1;
      end
      // Setting these back for board.sv to erase data there correctly
      save_xblock_in = x_block;
      save_yblock_in = y_block;
    end
    else
      down_counter_in = down_counter + 6'd1;
  end
end

always_comb begin
  play_area = 1'b0;
  score_area = 1'b0;
  x_coord = 5'd0;
  y_coord = 5'd0;
  ydraw_counter_in = ydraw_counter;
  xdraw_counter_in = xdraw_counter;

  // Determines that board.sv should output current pixel rather than the background
  if (DrawX <= playx_max && DrawX >= playx_min && DrawY >= playy_min && DrawY <= playy_max) begin
    // Using two of our multipliers to divide (I think)
    x_coord = (DrawX - playx_min) / 20;
    y_coord = (DrawY - playy_min) / 20;
    play_area = 1'b1;
  end
  else if (DrawX <= scorex_max && DrawX >= scorex_min && DrawY >= scorey_min && DrawY <= scorey_max) begin
    score_area = 1'b1;
  end
  // When in specific area, x is always updated at next clock cycle
  if (DrawX >= 10'd20 && DrawX <= 10'd639 && DrawY >= playy_min && DrawY <= playy_max) begin
    xdraw_counter_in = xdraw_counter + 10'd1;
    if (xdraw_counter >= HPLAY_TOTAL)
      xdraw_counter_in = 10'd0;
    else
      xdraw_counter_in = xdraw_counter + 10'd1;

    // Only update y counter when DrawX is at edge of specified area
    if (DrawX == 10'd639) begin
      xdraw_counter_in = 10'd0;
      ydraw_counter_in = ydraw_counter_in + 10'd1;
      if (ydraw_counter >= VPLAY_TOTAL)
        ydraw_counter_in = 10'd0;
      else
        ydraw_counter_in = ydraw_counter + 10'd1;
    end
    if (DrawX == playx_min && DrawY == playy_min) begin
      xdraw_counter_in = 10'd1;
      ydraw_counter_in = 10'd0;
    end
  end
end

endmodule
