import types::*;

parameter [4:0] x_size = 5'd10;
parameter [4:0] y_size = 5'd20;

module board (
    input  logic Clk,         // 60 Hz clock in sync with game
    input  logic Reset,             // Active-high reset signal
    input  logic [4:0] x_coord,     // X-coordinate of top-left corner of 4x4 block
    input  logic [4:0] y_coord,     // Y-coordinate of top-left corner of 4x4 block
    input  logic [19:0] x_block,
    input  logic [19:0] y_block,
    input  logic [19:0] save_xblock,
    input  logic [19:0] save_yblock,
    input  logic [19:0] x_move_left,
    input  logic [19:0] x_move_right,
    input  logic [19:0] x_move_down,
    input  logic [19:0] x_rotate_left,
    input  logic [19:0] x_rotate_right,
    input  logic [19:0] y_move_left,
    input  logic [19:0] y_move_right,
    input  logic [19:0] y_move_down,
    input  logic [19:0] y_rotate_left,
    input  logic [19:0] y_rotate_right,
    input  block_color block,
    // input  logic [19:0] lines,      // Indiciates which lines to clear
    output block_color current_pixel,  // 10x20 column major board, each square represented by 3 bits
    output logic [4:0] can_move
);

block_color board_arr[x_size][y_size];
logic [9:0] i;
logic [9:0] j;
logic [9:0] row;
logic [9:0] col;

assign current_pixel = board_arr[x_coord][y_coord];

// For each x and y coordinate given, check that the block is occupied by its respective tetronome,
// or it's an empty space that the block can move to. Only true when all 4 x,y coordinates are good
// Just a little bit nasty to look at.
function logic checkBoardSpaces(logic [19:0] xparam, logic[19:0] yparam);
    logic xgood, ygood;
    xgood = (board_arr[xparam[19:15]][yparam[19:15]] == EMPTY) || (xparam[19:15] == x_block[19:15]) || (xparam[19:15] == x_block[14:10]) ||
            (xparam[19:15] == x_block[9:5]) || (xparam[19:15] == x_block[4:0]);

    xgood = ((board_arr[xparam[14:10]][yparam[14:10]] == EMPTY) || (xparam[14:10] == x_block[19:15]) || (xparam[14:10] == x_block[14:10]) ||
            (xparam[14:10] == x_block[9:5]) || (xparam[14:10] == x_block[4:0])) && xgood;

    xgood = ((board_arr[xparam[9:5]][yparam[9:5]] == EMPTY) || (xparam[9:5] == x_block[19:15]) || (xparam[9:5] == x_block[14:10]) ||
            (xparam[9:5] == x_block[9:5]) || (xparam[9:5] == x_block[4:0])) && xgood;

    xgood = ((board_arr[xparam[4:0]][yparam[4:0]] == EMPTY) || (xparam[4:0] == x_block[19:15]) || (xparam[4:0] == x_block[14:10]) ||
            (xparam[4:0] == x_block[9:5]) || (xparam[4:0] == x_block[4:0])) && xgood;


    ygood = (board_arr[xparam[19:15]][yparam[19:15]] == EMPTY) || (yparam[19:15] == y_block[19:15]) || (yparam[19:15] == y_block[14:10]) ||
            (yparam[19:15] == y_block[9:5]) || (yparam[19:15] == y_block[4:0]);

    ygood = ((board_arr[xparam[14:10]][yparam[14:10]] == EMPTY) || (yparam[14:10] == y_block[19:15]) || (yparam[14:10] == y_block[14:10]) ||
            (yparam[14:10] == y_block[9:5]) || (yparam[14:10] == y_block[4:0])) && ygood;

    ygood = ((board_arr[xparam[9:5]][yparam[9:5]] == EMPTY) || (yparam[9:5] == y_block[19:15]) || (yparam[9:5] == y_block[14:10]) ||
            (yparam[9:5] == y_block[9:5]) || (yparam[9:5] == y_block[4:0])) && ygood;

    ygood = ((board_arr[xparam[4:0]][yparam[4:0]] == EMPTY) || (yparam[4:0] == y_block[19:15]) || (yparam[4:0] == y_block[14:10]) ||
            (yparam[4:0] == y_block[9:5]) || (yparam[4:0] == y_block[4:0])) && ygood;
    return xgood && ygood;    
endfunction

// Making sure coordinates of possible move in game board, use < size from unsigned shenanigans
function logic inBounds(logic [19:0] xparam, logic[19:0] yparam);
    logic in_bound;
    in_bound = (xparam[19:15] < x_size) && (xparam[14:10] < x_size) && (xparam[9:5] < x_size) && (xparam[4:0] < x_size) &&
               (yparam[19:15] < y_size) && (yparam[14:10] < y_size) && (yparam[9:5] < y_size) && (yparam[4:0] < y_size);
    return in_bound;
endfunction

assign can_move[4] = inBounds(x_move_left, y_move_left) && checkBoardSpaces(x_move_left, y_move_left);
assign can_move[3] = inBounds(x_move_right, y_move_right) && checkBoardSpaces(x_move_right, y_move_right);
assign can_move[2] = inBounds(x_rotate_right, y_rotate_right) && checkBoardSpaces(x_rotate_right, y_rotate_right);
assign can_move[1] = inBounds(x_rotate_left, y_rotate_left) && checkBoardSpaces(x_rotate_left, y_rotate_left);
assign can_move[0] = inBounds(x_move_down, y_move_down); && checkBoardSpaces(x_move_down, y_move_down);

always_ff @(posedge Clk) 
begin
    if (Reset) begin
        for (row = 0; row < x_size; row = row + 1) begin
            for (col = 0; col < y_size; col = col + 1) begin
                board_arr[row][col] <= EMPTY;
            end
        end
    end
    // Constantly redraws part of board with current block, even if no movement occurs
    board_arr[save_xblock[19:15]][save_yblock[19:15]] <= EMPTY;
    board_arr[save_xblock[14:10]][save_yblock[14:10]] <= EMPTY;
    board_arr[save_xblock[9:5]][save_yblock[9:5]] <= EMPTY;
    board_arr[save_xblock[4:0]][save_yblock[4:0]] <= EMPTY;

    board_arr[x_block[19:15]][y_block[19:15]] <= block;
    board_arr[x_block[14:10]][y_block[14:10]] <= block;
    board_arr[x_block[9:5]][y_block[9:5]] <= block;
    board_arr[x_block[4:0]][y_block[4:0]] <= block;
end

endmodule
