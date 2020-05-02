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
    input  logic get_new_block,
    input  logic frame_clk_rising_edge,
    input  block_color block,
    // input  logic [19:0] lines,      // Indiciates which lines to clear
    output block_color current_pixel,  // 10x20 column major board, each square represented by 3 bits
    output logic BOARD_BUSY,
    output logic [4:0] can_move
);

block_color board_arr[x_size][y_size];
block_color board_in[x_size][y_size];
logic [4:0] row;
logic [4:0] col;

logic can_clear_row;
logic can_clear_current;
logic clear_row;
logic drop_rows;
logic [4:0] i;
logic [4:0] j;
logic [4:0] clear_y;
logic [4:0] num_rows;
logic [4:0] clear_y_reg;
logic [4:0] num_rows_reg;

assign current_pixel = board_arr[x_coord][y_coord];

enum logic [2:0] {
    PLAY,
    CLEAR,
    DROP
} state, next_state;

// Logic if a line can be cleared in the board
always_comb
begin
    clear_y = 5'd30;
    num_rows = 5'd0;
    can_clear_row = 1'b0;
    for (j = 5'd0; j < y_size; j = j + 5'd1) begin
        can_clear_current = 1'b1;
        for (i = 5'd0; i < x_size; i = i + 5'd1) begin
            if (board_arr[i][j] == EMPTY) begin
                can_clear_current = 1'b0;
                break;
            end
        end
        if (can_clear_current == 1'b1) begin
            clear_y = j;
            num_rows = num_rows + 5'd1;
            can_clear_row = 1'b1;
        end
    end
end

logic save_clear_y;
always_comb
begin
    next_state = state;
    save_clear_y = 1'b0;
    // Next state transitions
    unique case (next_state)
        PLAY: begin
            if (get_new_block && can_clear_row) begin
                save_clear_y = 1'b1;
                next_state = CLEAR;
            end
        end
        CLEAR: begin
            if (num_rows == 1'b1 && clear_y_reg-num_rows_reg != 5'd0)
                next_state = DROP;
            else if (num_rows > 1'b1)
                next_state = CLEAR;
            else
                next_state = PLAY;
        end
        DROP: begin
            next_state = PLAY;
        end
        default:
            next_state = PLAY;
    endcase
    
    BOARD_BUSY = 1'b0;
    board_in = board_arr;
    col = 5'd0;
    row = 5'd0;
    // Signals based on current state
    case (state)
        PLAY: begin
            if (get_new_block == 1'b0) begin
                board_in[save_xblock[19:15]][save_yblock[19:15]] = EMPTY;
                board_in[save_xblock[14:10]][save_yblock[14:10]] = EMPTY;
                board_in[save_xblock[9:5]][save_yblock[9:5]] = EMPTY;
                board_in[save_xblock[4:0]][save_yblock[4:0]] = EMPTY;
            end
            board_in[x_block[19:15]][y_block[19:15]] = block;
            board_in[x_block[14:10]][y_block[14:10]] = block;
            board_in[x_block[9:5]][y_block[9:5]] = block;
            board_in[x_block[4:0]][y_block[4:0]] = block;
        end
        CLEAR: begin
            BOARD_BUSY = 1'b1;
            for (col = 5'd0; col < x_size; col = col + 1) begin
                board_in[col][clear_y] = EMPTY;
            end
        end
        DROP: begin
            BOARD_BUSY = 1'b1;
            for (row = y_size - 1; row < y_size; row = row - 1) begin
                for (col = 0; col < x_size; col = col + 1) begin
                    // This is below the dropped line(s), at or above should be shifted appropriately
                    if (row > (clear_y_reg+num_rows_reg-1))
                        board_in[col][row] = board_arr[col][row];
                    else
                        board_in[col][row] = board_arr[col][row-num_rows_reg];
                end
            end
        end
    endcase
end

function logic checkBlockMatch(logic [4:0] xcheck, logic [4:0] ycheck);
    return (board_arr[xcheck][ycheck] == EMPTY) || ((xcheck == x_block[19:15] && ycheck == y_block[19:15]) || (xcheck == x_block[14:10] && ycheck == y_block[14:10]) ||
           (xcheck == x_block[9:5] && ycheck == y_block[9:5]) || (xcheck == x_block[4:0] && ycheck == y_block[4:0]));
endfunction

// For each x and y coordinate given, check that the block is occupied by its respective tetromino,
// or it's an empty space that the block can move to. Only true when all 4 x,y coordinates are good.
function logic checkBoardSpaces(logic [19:0] xparam, logic[19:0] yparam);
    logic x1y1good, x2y2good, x3y3good, x4y4good;

    x1y1good = checkBlockMatch(xparam[19:15], yparam[19:15]);
    x2y2good = checkBlockMatch(xparam[14:10], yparam[14:10]);
    x3y3good = checkBlockMatch(xparam[9:5], yparam[9:5]);
    x4y4good = checkBlockMatch(xparam[4:0], yparam[4:0]);

    return x1y1good && x2y2good && x3y3good && x4y4good;    
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
assign can_move[0] = inBounds(x_move_down, y_move_down) && checkBoardSpaces(x_move_down, y_move_down);

always_ff @(posedge Clk) 
begin
    if (Reset) begin
        num_rows_reg <= 5'd0;
        clear_y_reg <= 5'd0;
        for (col = 0; col < x_size; col = col + 1) begin
            for (row = 0; row < y_size; row = row + 1) begin
                board_arr[col][row] <= EMPTY;
            end
        end
    end
    else begin
        board_arr <= board_in;
        state <= next_state;
        if (save_clear_y) begin
            num_rows_reg <= num_rows;
            clear_y_reg <= clear_y;
        end
    end
end

endmodule
