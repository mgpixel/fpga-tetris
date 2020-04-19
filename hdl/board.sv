module board (
    input  logic CLK,               // 50 MHz clock
    input  logic RESET,             // Active-high reset signal
    input  logic ADD,               // Add block signal
    input  logic CLEAR,             // Clear lines signal
    input  logic [15:0] block_arr,  // Flattened 4x4 logic array representing where the block is in a 4x4 column major array
    input  logic [3:0] x_coord,     // X-coordinate of top-left corner of 4x4 block
    input  logic [5:0] y_coord,     // Y-coordinate of top-left corner of 4x4 block
    input  logic [2:0] block_color, // Type of block, used mainly for color
    input  logic [19:0] lines,      // Indiciates which lines to clear
    output logic [599:0] board_arr  // 10x20 column major board, each square represented by 3 bits
);

logic [9:0] play1_x_center = 10'd160;
logic [9:0] play2_x_center = 10'd480;
logic [9:0] y_center = 10'd240;


logic [599:0] board_arr = 599'd0;
logic [599:0] next_board = 599'd0;

always_ff @ (posedge CLK) 
begin
    if (RESET)
        board_arr <= 599'd0;
    else
        board_arr <= next_board;
end

always_comb
begin
    if (ADD) begin
        if (block_arr[0] == 1'b1) begin
            next_board[x_coord*60 + y_coord*3] = block_color[2];
            next_board[x_coord*60 + y_coord*3 + 1] = block_color[1];
            next_board[x_coord*60 + y_coord*3 + 2] = block_color[0];
        end
        if (block_arr[1] == 1'b1) begin
            next_board[x_coord*60 + y_coord*3 + 3] = block_color[2];
            next_board[x_coord*60 + y_coord*3 + 4] = block_color[1];
            next_board[x_coord*60 + y_coord*3 + 5] = block_color[0];
        end
        if (block_arr[2] == 1'b1) begin
            next_board[x_coord*60 + y_coord*3 + 6] = block_color[2];
            next_board[x_coord*60 + y_coord*3 + 7] = block_color[1];
            next_board[x_coord*60 + y_coord*3 + 8] = block_color[0];
        end
        if (block_arr[3] == 1'b1) begin
            next_board[x_coord*60 + y_coord*3 + 9] = block_color[2];
            next_board[x_coord*60 + y_coord*3 + 10] = block_color[1];
            next_board[x_coord*60 + y_coord*3 + 11] = block_color[0];
        end
        if (block_arr[4] == 1'b1) begin
            next_board[(x_coord+1)*60 + y_coord*3] = block_color[2];
            next_board[(x_coord+1)*60 + y_coord*3 + 1] = block_color[1];
            next_board[(x_coord+1)*60 + y_coord*3 + 2] = block_color[0];
        end
        if (block_arr[5] == 1'b1) begin
            next_board[(x_coord+1)*60 + y_coord*3 + 3] = block_color[2];
            next_board[(x_coord+1)*60 + y_coord*3 + 4] = block_color[1];
            next_board[(x_coord+1)*60 + y_coord*3 + 5] = block_color[0];
        end
        if (block_arr[6] == 1'b1) begin
            next_board[(x_coord+1)*60 + y_coord*3 + 6] = block_color[2];
            next_board[(x_coord+1)*60 + y_coord*3 + 7] = block_color[1];
            next_board[(x_coord+1)*60 + y_coord*3 + 8] = block_color[0];
        end
        if (block_arr[7] == 1'b1) begin
            next_board[(x_coord+1)*60 + y_coord*3 + 9] = block_color[2];
            next_board[(x_coord+1)*60 + y_coord*3 + 10] = block_color[1];
            next_board[(x_coord+1)*60 + y_coord*3 + 11] = block_color[0];
        end
        if (block_arr[8] == 1'b1) begin
            next_board[(x_coord+2)*60 + y_coord*3] = block_color[2];
            next_board[(x_coord+2)*60 + y_coord*3 + 1] = block_color[1];
            next_board[(x_coord+2)*60 + y_coord*3 + 2] = block_color[0];
        end
        if (block_arr[9] == 1'b1) begin
            next_board[(x_coord+2)*60 + y_coord*3 + 3] = block_color[2];
            next_board[(x_coord+2)*60 + y_coord*3 + 4] = block_color[1];
            next_board[(x_coord+2)*60 + y_coord*3 + 5] = block_color[0];
        end
        if (block_arr[10] == 1'b1) begin
            next_board[(x_coord+2)*60 + y_coord*3 + 6] = block_color[2];
            next_board[(x_coord+2)*60 + y_coord*3 + 7] = block_color[1];
            next_board[(x_coord+2)*60 + y_coord*3 + 8] = block_color[0];
        end
        if (block_arr[11] == 1'b1) begin
            next_board[(x_coord+2)*60 + y_coord*3 + 9] = block_color[2];
            next_board[(x_coord+2)*60 + y_coord*3 + 10] = block_color[1];
            next_board[(x_coord+2)*60 + y_coord*3 + 11] = block_color[0];
        end
        if (block_arr[12] == 1'b1) begin
            next_board[(x_coord+3)*60 + y_coord*3] = block_color[2];
            next_board[(x_coord+3)*60 + y_coord*3 + 1] = block_color[1];
            next_board[(x_coord+3)*60 + y_coord*3 + 2] = block_color[0];
        end
        if (block_arr[13] == 1'b1) begin
            next_board[(x_coord+3)*60 + y_coord*3 + 3] = block_color[2];
            next_board[(x_coord+3)*60 + y_coord*3 + 4] = block_color[1];
            next_board[(x_coord+3)*60 + y_coord*3 + 5] = block_color[0];
        end
        if (block_arr[14] == 1'b1) begin
            next_board[(x_coord+3)*60 + y_coord*3 + 6] = block_color[2];
            next_board[(x_coord+3)*60 + y_coord*3 + 7] = block_color[1];
            next_board[(x_coord+3)*60 + y_coord*3 + 8] = block_color[0];
        end
        if (block_arr[15] == 1'b1) begin
            next_board[(x_coord+3)*60 + y_coord*3 + 9] = block_color[2];
            next_board[(x_coord+3)*60 + y_coord*3 + 10] = block_color[1];
            next_board[(x_coord+3)*60 + y_coord*3 + 11] = block_color[0];
        end
    end
end
    
endmodule
