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
    input  logic [19:0] rot_xblock,
    input  logic [19:0] rot_yblock,
    input  block_color block,
    input  direction movement,
    // input  logic [19:0] lines,      // Indiciates which lines to clear
    output block_color current_pixel,  // 10x20 column major board, each square represented by 3 bits
    output logic can_move
);

block_color board_arr[x_size][y_size];
logic [9:0] i;
logic [9:0] j;
logic [9:0] row;
logic [9:0] col;

orientation rotation;

assign current_pixel = board_arr[x_coord][y_coord];

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
