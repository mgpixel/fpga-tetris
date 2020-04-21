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

// Out of bounds checking for every possible move, a bit nasty to look at
assign can_move[4] = ((x_move_left[19:15] < x_size) && (x_move_left[14:10] < x_size) && (x_move_left[9:5] < x_size) && (x_move_left[4:0] < x_size)) &&
                     ((y_move_left[19:15] < y_size) && (y_move_left[14:10] < y_size) && (y_move_left[9:5] < y_size) && (y_move_left[4:0] < y_size));
assign can_move[3] = ((x_move_right[19:15] < x_size) && (x_move_right[14:10] < x_size) && (x_move_right[9:5] < x_size) && (x_move_right[4:0] < x_size)) &&
                     ((y_move_right[19:15] < y_size) && (y_move_right[14:10] < y_size) && (y_move_right[9:5] < y_size) && (y_move_right[4:0] < y_size));
assign can_move[2] = ((x_rotate_right[19:15] < x_size) && (x_rotate_right[14:10] < x_size) && (x_rotate_right[9:5] < x_size) && (x_rotate_right[4:0] < x_size)) &&
                     ((y_rotate_right[19:15] < y_size) && (y_rotate_right[14:10] < y_size) && (y_rotate_right[9:5] < y_size) && (y_rotate_right[4:0] < y_size));
assign can_move[1] = ((x_rotate_left[19:15] < x_size) && (x_rotate_left[14:10] < x_size) && (x_rotate_left[9:5] < x_size) && (x_rotate_left[4:0] < x_size)) &&
                     ((y_rotate_left[19:15] < y_size) && (y_rotate_left[14:10] < y_size) && (y_rotate_left[9:5] < y_size) && (y_rotate_left[4:0] < y_size));
assign can_move[0] = ((x_move_down[19:15] < x_size) && (x_move_down[14:10] < x_size) && (x_move_down[9:5] < x_size) && (x_move_down[4:0] < x_size)) &&
                     ((y_move_down[19:15] < y_size) && (y_move_down[14:10] < y_size) && (y_move_down[9:5] < y_size) && (y_move_down[4:0] < y_size));

always_ff @(posedge Clk) 
begin
    if (Reset) begin
        for (row = 0; row < x_size; row = row + 1) begin
            for (col = 0; col < y_size; col = col + 1) begin
                board_arr[row][col] <= EMPTY;
            end
        end
    end
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
