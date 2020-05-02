module score_keeper (
    input  logic Clk,               // 50 MHz clock
    input  logic Reset,             // Active-high reset signal
    input  logic update,
    input  logic [2:0] num_lines,
    output logic [23:0] digits
);


// Digit number is zero indexed, with digit0 being the 1's digit
logic [3:0] digit0;
assign digit0 = 4'd0; // will always be 0
logic [3:0] digit1 = 4'd0;
logic [3:0] digit2 = 4'd0;
logic [3:0] digit3 = 4'd0;
logic [3:0] digit4 = 4'd0;
logic [3:0] digit5 = 4'd0;

logic [3:0] next_digit1;
logic [3:0] next_digit2;
logic [3:0] next_digit3;
logic [3:0] next_digit4;
logic [3:0] next_digit5;

assign digits = {digit5, digit4, digit3, digit2, digit1, digit0};

// Using the original BPS scoring system
// 1 line: 40 points
// 2 lines: 100 points
// 3 lines: 300 points
// 4 lines: 1200 points

always_ff @ (posedge Clk) 
begin
    if (Reset) begin
        digit1 = 4'd0;
        digit2 = 4'd0;
        digit3 = 4'd0;
        digit4 = 4'd0;
        digit5 = 4'd0;
    end
    else begin
        digit1 = next_digit1;
        digit2 = next_digit2;
        digit3 = next_digit3;
        digit4 = next_digit4;
        digit5 = next_digit5;
    end
end

always_comb
begin
    next_digit1 = digit1;
    next_digit2 = digit2;
    next_digit3 = digit3;
    next_digit4 = digit4;
    next_digit5 = digit5;
    if (update) begin
        case (num_lines)
            3'd1:
                next_digit1 = digit1 + 4'd4;
            3'd2: 
                next_digit2 = digit2 + 4'd1;
            3'd3: 
                next_digit2 = digit2 + 4'd3;
            3'd4: begin
                next_digit2 = digit2 + 4'd2;
                next_digit3 = digit3 + 4'd1;
            end
            default: ;
        endcase

        if (next_digit1 >= 4'd10) begin
            next_digit1 -= 4'd10;
            next_digit2 += 4'd1;
        end
        if (next_digit2 >= 4'd10) begin
            next_digit2 -= 4'd10;
            next_digit3 += 4'd1;
        end
        if (next_digit3 >= 4'd10) begin
            next_digit3 -= 4'd10;
            next_digit4 += 4'd1;
        end
        if (next_digit4 >= 4'd10) begin
            next_digit4 -= 4'd10;
            next_digit5 += 4'd1;
        end
        // overflows at this point, have scores at maximum
        if (next_digit5 >= 4'd10) begin
            next_digit1 = 4'd9;
            next_digit1 = 4'd9;
            next_digit1 = 4'd9;
            next_digit1 = 4'd9;
            next_digit1 = 4'd9;
        end
    end
end

endmodule