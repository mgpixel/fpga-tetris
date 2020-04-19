import types::*;

parameter [4:0] x_size = 5'd10;
parameter [4:0] y_size = 5'd20;

module board (
    input  logic Clk,         // 60 Hz clock in sync with game
    input  logic Reset,             // Active-high reset signal
    input  logic [4:0] x_coord,     // X-coordinate of top-left corner of 4x4 block
    input  logic [4:0] y_coord,     // Y-coordinate of top-left corner of 4x4 block
    input  logic [4:0] x_block,
    input  logic [4:0] y_block,
    input  block_color block,
    input  direction movement,
    input  logic has_moved,
    // input  logic [19:0] lines,      // Indiciates which lines to clear
    output block_color current_pixel // 10x20 column major board, each square represented by 3 bits
);

block_color board_arr[x_size][y_size];
logic [9:0] i;
logic [9:0] j;
logic [9:0] row;
logic [9:0] col;

orientation rotation;
logic x_match;
logic y_match;

assign current_pixel = board_arr[x_coord][y_coord];

enum logic [3:0] {
    ADD,
    CLEAR,
    GAME,
    DONE,
    INIT,
    GENERATE
} state, next_state;

assign x_match = x_coord > 5'd2 && x_coord < 5'd7;
assign y_match = y_coord < 5'd1;

always_ff @(posedge Clk) 
begin
    if (Reset) begin
        for (row = 0; row < x_size; row = row + 1) begin
            for (col = 0; col < y_size; col = col + 1) begin
                board_arr[row][col] <= EMPTY;
            end
        end
    end
    else begin
        if (has_moved) begin
            unique case (movement)
                LEFT: ;
                RIGHT: ;
                DOWN: begin
                    board_arr[x_coord][y_coord-1] <= EMPTY;
                    board_arr[x_coord+1][y_coord-1] <= EMPTY;
                    board_arr[x_coord+2][y_coord-1] <= EMPTY;
                    board_arr[x_coord+3][y_coord-1] <= EMPTY;
                end
            endcase
        end
        if (x_match & y_match) begin
            board_arr[x_coord][y_coord] <= CYAN;
        end
    end
end

always_comb
begin
    next_state = state;
    unique case (next_state)
        INIT:
            next_state = GENERATE;
        GENERATE:
            next_state = ADD;
        CLEAR:
            next_state = ADD;
        ADD:
            next_state = GAME;
        GAME: ;
        DONE: ;
        default:
            next_state = INIT;
    endcase

    unique case (state)
        INIT: ;
        GENERATE: ;
        CLEAR: ;
        ADD: begin

        end
        GAME: ;
        DONE: ;
        default: ;
    endcase
end

// always_comb
// begin
//     if (ADD) begin
//         if (block_arr[0] == 1'b1) begin
//             next_board[x_coord*60 + y_coord*3] = block_color[2];
//             next_board[x_coord*60 + y_coord*3 + 1] = block_color[1];
//             next_board[x_coord*60 + y_coord*3 + 2] = block_color[0];
//         end

//     end
// end
    
endmodule
