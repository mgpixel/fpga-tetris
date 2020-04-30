module score_keeper (
    input  logic CLK,               // 50 MHz clock
    input  logic RESET,             // Active-high reset signal
    input  logic [2:0] num_lines,
    output logic [7:0] digit0, 
    output logic [7:0] digit1, 
    output logic [7:0] digit2, 
    output logic [7:0] digit3, 
    output logic [7:0] digit4, 
    output logic [7:0] digit5 
);


// Digit number is zero indexed, with digit0 being the 1's digit
logic [7:0] digit0 = 8'd0; // will always be 0
logic [7:0] digit1 = 8'd0;
logic [7:0] digit2 = 8'd0;
logic [7:0] digit3 = 8'd0;
logic [7:0] digit4 = 8'd0;
logic [7:0] digit5 = 8'd0;

logic [7:0] next_digit1 = 8'd0;
logic [7:0] next_digit2 = 8'd0;
logic [7:0] next_digit3 = 8'd0;
logic [7:0] next_digit4 = 8'd0;
logic [7:0] next_digit5 = 8'd0;

// Using the original BPS scoring system
// 1 line: 40 points
// 2 lines: 100 points
// 3 lines: 300 points
// 4 lines: 1200 points

always_ff @ (posedge CLK) 
begin
    if (RESET) begin
        digit1 = 8'd0;
        digit2 = 8'd0;
        digit3 = 8'd0;
        digit4 = 8'd0;
        digit5 = 8'd0;
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
    if (num_lines == 3'd1)
        next_digit1 = digit1 + 8'd4;
    else if (num_lines == 3'd2) 
        next_digit2 = digit2 + 8'd1;
    else if (num_lines == 3'd3) 
        next_digit2 = digit2 + 8'd3;
    else if (num_lines == 3'd4) begin
        next_digit2 = digit2 + 8'd2;
        next_digit3 = digit3 + 8'd1;
    end

    if (next_digit1 >= 8'd10) begin
        next_digit1 -= 8'd10;
        next_digit2 += 8'd1;
    end
    if (next_digit2 >= 8'd10) begin
        next_digit2 -= 8'd10;
        next_digit3 += 8'd1;
    end
    if (next_digit3 >= 8'd10) begin
        next_digit3 -= 8'd10;
        next_digit4 += 8'd1;
    end
    if (next_digit4 >= 8'd10) begin
        next_digit4 -= 8'd10;
        next_digit5 += 8'd1;
    end
    if (next_digit5 >= 8'd10) begin
        next_digit5 -= 8'd10; // overflows at this point, game over?? 
    end
end