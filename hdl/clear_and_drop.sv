import types::*;

parameter [4:0] x_size = 5'd10;
parameter [4:0] y_size = 5'd20;

module clear_and_drop (
    input  logic Clk,
    input  block_color board_arr[x_size][y_size],
    output block_color cleared_board[x_size][y_size],
    output block_clock dropped_board[x_size][y_size],
    output logic [2:0] num_lines                    // for score keeping
);

logic [4:0] curr_row;

always_comb
begin
    curr_row = y_size - 1;
    num_lines = 3'd0;

    for (row = 0; row < y_size; row = row + 1) begin
        if (board_arr[0][row] != EMPTY) && \
           (board_arr[1][row] != EMPTY) && \ 
           (board_arr[2][row] != EMPTY) && \
           (board_arr[3][row] != EMPTY) && \
           (board_arr[4][row] != EMPTY) && \
           (board_arr[5][row] != EMPTY) && \
           (board_arr[6][row] != EMPTY) && \
           (board_arr[7][row] != EMPTY) && \
           (board_arr[8][row] != EMPTY) && \
           (board_arr[9][row] != EMPTY) begin
            num_lines += 1
            for (col = 0; col < x_size; col = col + 1) begin
                cleared_board[col][row] = EMPTY;
            end
        end
        else begin
            for (col = 0; col < x_size; col = col + 1) begin
                cleared_board[col][row] = board_arr[col][row];
                dropped_board[col][curr_row] = board_arr[col][row];
            end
            curr_row = curr_row + 1;
        end
    end

    // Make sure the top lines in dropped_board are cleared
    for (row = curr_row; row >= 0; row = row - 1) begin
        for (col = 0; col < x_size; col = col + 1) begin
            dropped_board[col][curr_row] = EMPTY;
        end
    end
end