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
               output logic  is_ball,             // Whether current pixel belongs to ball or background
               output logic  play_area           // Current coordinates in play area
              );
    
parameter [9:0] x_min = 10'd0;       // Leftmost point on the X axis
parameter [9:0] x_max = 10'd639;     // Rightmost point on the X axis
parameter [9:0] y_min = 10'd0;       // Topmost point on the Y axis
parameter [9:0] y_max = 10'd479;     // Bottommost point on the Y axis
parameter [9:0] playx_min = 10'd220;
parameter [9:0] playx_max = 10'd419;
parameter [9:0] playy_min = 10'd40;
parameter [9:0] playy_max = 10'd439;
parameter [9:0] Ball_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step = 10'd10;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step = 10'd10;      // Step size on the Y axis
    parameter [9:0] Ball_Size = 10'd20;       // Ball size

logic [7:0] W, A, S, D;
logic [5:0] counter;
logic bouncing;

logic [9:0] x_center = 10'd320;
logic [9:0] y_center = 10'd240;
logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;


// Hex values corresponding to keys pressed from keyboard
assign W = 8'h1a;
assign A = 8'h04;
assign S = 8'h16;
assign D = 8'h07;

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
    Ball_X_Pos <= x_center;
    Ball_Y_Pos <= y_center;
    Ball_X_Motion <= 10'd0;
    Ball_Y_Motion <= Ball_Y_Step;
  end
  else begin
    Ball_X_Pos <= Ball_X_Pos_in;
    Ball_Y_Pos <= Ball_Y_Pos_in;
    Ball_X_Motion <= Ball_X_Motion_in;
    Ball_Y_Motion <= Ball_Y_Motion_in;
  end
end

always_comb
begin
  // By default, keep motion and position unchanged
  Ball_X_Pos_in = Ball_X_Pos;
  Ball_Y_Pos_in = Ball_Y_Pos;
  Ball_X_Motion_in = Ball_X_Motion;
  Ball_Y_Motion_in = Ball_Y_Motion;
  bouncing = 1'b0;
  
  // Update position and motion only at rising edge of frame clock
  if (frame_clk_rising_edge && counter == 5'd15) begin
    // Be careful when using comparators with "logic" datatype because compiler treats 
    //   both sides of the operator as UNSIGNED numbers.
    // e.g. Ball_Y_Pos - Ball_Size <= Ball_Y_Min 
    // If Ball_Y_Pos is 0, then Ball_Y_Pos - Ball_Size will not be -4, but rather a large positive number.
    if( Ball_Y_Pos + Ball_Size >= Ball_Y_Max ) begin // Ball is at the bottom edge, BOUNCE!
      Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);  // 2's complement.  
      bouncing = 1'b1;
    end
    else if ( Ball_Y_Pos <= Ball_Y_Min + Ball_Size ) begin // Ball is at the top edge, BOUNCE!
      Ball_Y_Motion_in = Ball_Y_Step;
      bouncing = 1'b1;
    end
    else if (Ball_X_Pos + Ball_Size >= Ball_X_Max) begin
      Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);
      bouncing = 1'b1;
    end
    else if (Ball_X_Pos <= Ball_X_Min + Ball_Size) begin
      Ball_X_Motion_in = Ball_X_Step;
      bouncing = 1'b1;
    end
    if (!bouncing) begin
      unique case (keycode)
        A: begin
            Ball_Y_Motion_in = 10'd0;
            Ball_X_Motion_in = ((~Ball_X_Step) + 1'b1); 
        end
        S: begin
            Ball_X_Motion_in = 10'd0;
            Ball_Y_Motion_in = Ball_Y_Step;
        end
        D: begin
            Ball_Y_Motion_in = 10'd0;
            Ball_X_Motion_in = Ball_X_Step;
        end
        default: ;
      endcase
    end
    // Update the ball's position with its motion
    Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
    Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
  end
end

// Compute whether the pixel corresponds to ball or background
/* Since the multiplicants are required to be signed, we have to first cast them
    from logic to int (signed by default) before they are multiplied. */
int DistX, DistY, Size;
assign DistX = DrawX - Ball_X_Pos;
assign DistY = DrawY - Ball_Y_Pos;
assign Size = Ball_Size;
always_comb begin
  play_area = 1'b0;
  if ( ( DistX*DistX + DistY*DistY) <= (Size*Size) ) 
    is_ball = 1'b1;
  else begin
    is_ball = 1'b0;
    if (DrawX <= playx_max && DrawX >= playx_min && DrawY >= playy_min && DrawY <= playy_max)
      play_area = 1'b1;
  end
end

endmodule
