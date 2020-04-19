//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  proto( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               input [7:0]   keycode,
               output logic  is_ball,            // Whether current pixel belongs to ball or background
               output logic  play_area,          // Current coordinates in play area
               output logic [4:0] x_coord,
               output logic [4:0] y_coord,
               output logic [4:0] x_block,
               output logic [4:0] y_block,
               output block_color block
              );
    
parameter [9:0] x_min = 10'd0;       // Leftmost point on the X axis
parameter [9:0] x_max = 10'd639;     // Rightmost point on the X axis
parameter [9:0] y_min = 10'd0;       // Topmost point on the Y axis
parameter [9:0] y_max = 10'd479;     // Bottommost point on the Y axis
parameter [9:0] playx_min = 10'd220;
parameter [9:0] playx_max = 10'd419;
parameter [9:0] playy_min = 10'd40;
parameter [9:0] playy_max = 10'd439;
parameter [9:0] y_step = 10'd20;

logic [7:0] W, A, S, D;
logic [5:0] counter;
logic bouncing;

logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;


// Hex values corresponding to keys pressed from keyboard
assign W = 8'h1a;
assign A = 8'h04;
assign S = 8'h16;
assign D = 8'h07;

assign block = CYAN;

// Detect rising edge of frame_clk
logic frame_clk_delayed, frame_clk_rising_edge;
always_ff @ (posedge Clk)
begin
  if (Reset)
    counter <= 5'd0;
  frame_clk_delayed <= frame_clk;
  frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
  if (frame_clk_rising_edge) begin
    counter <= counter + 5'd1;
    if (counter == 5'd16)
      counter <= 5'd1;
  end
end

// Update registers
always_ff @ (posedge Clk)
begin
  if (Reset) begin

  end
  else begin

  end
end

always_comb
begin
  // Update position and motion only at rising edge of frame clock
  if (frame_clk_rising_edge && counter == 5'd15) begin
    // Be careful when using comparators with "logic" datatype because compiler treats 
    //   both sides of the operator as UNSIGNED numbers.
    if (1'b0) begin
      unique case (keycode)
        A: begin

        end
        S: begin

        end
        D: begin

        end
        default: ;
      endcase
    end

  end
end

always_comb begin
  play_area = 1'b0;
  x_coord = 5'd0;
  y_coord = 5'd0;

  if (DrawX <= playx_max && DrawX >= playx_min && DrawY >= playy_min && DrawY <= playy_max) begin
    x_coord = (DrawX - playx_min) / 20;
    y_coord = (DrawY - playy_min) / 20;
    play_area = 1'b1;
  end
end

endmodule
