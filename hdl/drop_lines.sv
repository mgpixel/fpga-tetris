import types::*;

parameter [4:0] x_size = 5'd10;
parameter [4:0] y_size = 5'd20;

module drop_lines (
    input  logic Clk,
    input  block_color board_arr[x_size][y_size],
    output block_color new_board[x_size][y_size]
);

logic [4:0] curr_row;

always_comb
begin
    curr_row = y_size - 1;

    for (row = y_size - 1; row >= 0; row = row - 1) begin
        if (board_arr[0][row] > EMPTY) || \
           (board_arr[1][row] > EMPTY) || \ 
           (board_arr[2][row] > EMPTY) || \
           (board_arr[3][row] > EMPTY) || \
           (board_arr[4][row] > EMPTY) || \
           (board_arr[5][row] > EMPTY) || \
           (board_arr[6][row] > EMPTY) || \
           (board_arr[7][row] > EMPTY) || \
           (board_arr[8][row] > EMPTY) || \
           (board_arr[9][row] > EMPTY) begin
            if (row > curr_row) begin
                for (col = 0; col < x_size; col = col + 1) begin
                    new_board[col][curr_row] = board_arr[col][row];
                end
            end 
            curr_row = curr_row + 1;   
        end
    end

    // Make sure the top lines are cleared
    for (row = curr_row; row >= 0; row = row - 1) begin
        for (col = 0; col < x_size; col = col + 1) begin
            new_board[col][curr_row] = EMPTY;
        end
    end
end
