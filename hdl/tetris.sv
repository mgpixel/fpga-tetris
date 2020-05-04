//-------------------------------------------------------------------------
//      lab8.sv (Originally, used as baseline for tetris proejct)        --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------
// Marcos Garcia, Jiawei Huang, Spring 2020
import types::*;

module tetris(input              CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             input  logic        AUD_BCLK, AUD_ADCDAT, AUC_DACLRCK, AUD_ADRCLRCK,
             output logic        AUD_MCLK, AUD_DACDAT, I2C_SDAT, I2C_SCLK,
             output logic        NEXT_SAMPLE,
             output logic [6:0]  HEX0, HEX1,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK      //SDRAM Clock
);
    
    logic Reset_h, Clk;
    logic [31:0] keycode;
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
    logic [9:0] DrawX, DrawY;
    logic [23:0] score_digits1;
    logic [23:0] score_digits2;
    logic [23:0] score_digits_in1;
    logic [23:0] score_digits_in2;
    logic [9:0] xdraw_counter1, ydraw_counter1, xdraw_counter2, ydraw_counter2;
    logic play_area1, play_area2;
    logic score_area1, score_area2;

    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        score_digits_in1 <= score_digits1;
        score_digits_in2 <= score_digits2;
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
    end

    // Player 1
    logic [4:0] can_move1;
    logic [4:0] x_coord1, y_coord1;
    logic [19:0] x_block1;
    logic [19:0] y_block1;
    logic [19:0] save_xblock1;
    logic [19:0] save_yblock1;
    // Possible moves that board checks are valid to not go out of bounds accidentally
    logic [19:0] x_move_left1;
    logic [19:0] x_move_right1;
    logic [19:0] x_move_down1;
    logic [19:0] x_rotate_left1;
    logic [19:0] x_rotate_right1;
    logic [19:0] y_move_left1;
    logic [19:0] y_move_right1;
    logic [19:0] y_move_down1;
    logic [19:0] y_rotate_left1;
    logic [19:0] y_rotate_right1;
    logic get_new_block1;
    logic BOARD_BUSY1;
    block_color block1;
    block_color current_pixel1;

    // Player 2
    logic [4:0] can_move2;
    logic [4:0] x_coord2, y_coord2;
    logic [19:0] x_block2;
    logic [19:0] y_block2;
    logic [19:0] save_xblock2;
    logic [19:0] save_yblock2;

    logic [19:0] x_move_left2;
    logic [19:0] x_move_right2;
    logic [19:0] x_move_down2;
    logic [19:0] x_rotate_left2;
    logic [19:0] x_rotate_right2;
    logic [19:0] y_move_left2;
    logic [19:0] y_move_right2;
    logic [19:0] y_move_down2;
    logic [19:0] y_rotate_left2;
    logic [19:0] y_rotate_right2;
    logic get_new_block2;
    logic BOARD_BUSY2;
    block_color block2;
    block_color current_pixel2;

    logic frame_clk_rising_edge;
    logic frame_clk_dummy;
    
    logic [9:0] playy_min;
    logic [9:0] playy_max;
    logic [9:0] scorey_min;
    logic [9:0] scorey_max;
    logic [9:0] holdy_min, holdy_max;
    logic [9:0] holdx_min1, holdx_max1, holdx_min2, holdx_max2;
    logic [9:0] nexty_min, nexty_max;
    logic [9:0] nextx_min1, nextx_max1, nextx_min2, nextx_max2;

    assign playy_min = 10'd40;
    assign playy_max = 10'd439;
    assign scorey_min = 10'd15;
    assign scorey_max = 10'd30;

    assign holdy_min = 10'd40;
    assign holdy_max = 10'd55;
    assign holdx_min1 = 10'd260;
    assign holdx_max1 = 10'd291;
    assign holdx_min2 = 10'd580;
    assign holdx_max2 = 10'd611;

    assign nexty_min = 10'd40;
    assign nexty_max = 10'd55;
    assign nextx_min1 = 10'd260;
    assign nextx_max1 = 10'd291;
    assign nextx_min2 = 10'd580;
    assign nextx_max2 = 10'd611;

    logic [15:0] audio_data;
    
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );

     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     nios_system nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );
    
    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    VGA_controller vga_controller_instance(.Reset(Reset_h), .*);

    // Maps appropriate color to pixel on the board or background
    block_color_mapper color_instance(.block_type1(current_pixel1), .block_type2(current_pixel2), .*);
    logic [9:0] scorex_min1, scorex_max1, scorex_min2, scorex_max2;
    assign scorex_min1 = 10'd96;
    assign scorex_max1 = 10'd143;
    assign scorex_min2 = 10'd416;
    assign scorex_max2 = 10'd463;

    // 10x20 game board that gives pixel color at given x and y
    board game_board1(.Reset(Reset_h),
        .x_coord(x_coord1),
        .y_coord(y_coord1),
        .x_block(x_block1),
        .y_block(y_block1),
        .save_yblock(save_yblock1),
        .save_xblock(save_xblock1),
        .x_move_left(x_move_left1),
        .x_move_right(x_move_right1),
        .x_move_down(x_move_down1),
        .x_rotate_right(x_rotate_right1),
        .x_rotate_left(x_rotate_left1),
        .y_move_left(y_move_left1),
        .y_move_right(y_move_right1),
        .y_move_down(y_move_down1),
        .y_rotate_left(y_rotate_left1),
        .y_rotate_right(y_rotate_right1),
        .get_new_block(get_new_block1),
        .can_move(can_move1),
        .block(block1),
        .BOARD_BUSY(BOARD_BUSY1),
        .current_pixel(current_pixel1),
        .score_digits(score_digits1),
        .*);

    board game_board2(.Reset(Reset_h),
        .x_coord(x_coord2),
        .y_coord(y_coord2),
        .x_block(x_block2),
        .y_block(y_block2),
        .save_yblock(save_yblock2),
        .save_xblock(save_xblock2),
        .x_move_left(x_move_left2),
        .x_move_right(x_move_right2),
        .x_move_down(x_move_down2),
        .x_rotate_right(x_rotate_right2),
        .x_rotate_left(x_rotate_left2),
        .y_move_left(y_move_left2),
        .y_move_right(y_move_right2),
        .y_move_down(y_move_down2),
        .y_rotate_left(y_rotate_left2),
        .y_rotate_right(y_rotate_right2),
        .get_new_block(get_new_block2),
        .can_move(can_move2),
        .block(block2),
        .BOARD_BUSY(BOARD_BUSY2),
        .current_pixel(current_pixel2),
        .score_digits(score_digits2),
        .*);
    
    // Holds game logic for blocks in the game
    block_logic game1(.Reset(Reset_h),
        .frame_clk(VGA_VS),
        .playx_min(10'd20),
        .playx_max(10'd219),
        .scorex_min(scorex_min1),
        .scorex_max(scorex_max1),
        .play_area(play_area1),
        .score_area(score_area1),
        .xdraw_counter(xdraw_counter1),
        .ydraw_counter(ydraw_counter1),
        .x_coord(x_coord1),
        .y_coord(y_coord1),
        .x_block(x_block1),
        .y_block(y_block1),
        .save_yblock(save_yblock1),
        .save_xblock(save_xblock1),
        .x_move_left(x_move_left1),
        .x_move_right(x_move_right1),
        .x_move_down(x_move_down1),
        .x_rotate_right(x_rotate_right1),
        .x_rotate_left(x_rotate_left1),
        .y_move_left(y_move_left1),
        .y_move_right(y_move_right1),
        .y_move_down(y_move_down1),
        .y_rotate_left(y_rotate_left1),
        .y_rotate_right(y_rotate_right1),
        .get_new_block(get_new_block1),
        .can_move(can_move1),
        .block(block1),
        .BOARD_BUSY(BOARD_BUSY1),
        .player_num(2'd1),
        .*);

    block_logic game2(.Reset(Reset_h),
        .frame_clk(VGA_VS),
        .playx_min(10'd340),
        .playx_max(10'd539),
        .scorex_min(scorex_min2),
        .scorex_max(scorex_max2),
        .play_area(play_area2),
        .score_area(score_area2),
        .xdraw_counter(xdraw_counter2),
        .ydraw_counter(ydraw_counter2),
        .x_coord(x_coord2),
        .y_coord(y_coord2),
        .x_block(x_block2),
        .y_block(y_block2),
        .save_yblock(save_yblock2),
        .save_xblock(save_xblock2),
        .x_move_left(x_move_left2),
        .x_move_right(x_move_right2),
        .x_move_down(x_move_down2),
        .x_rotate_right(x_rotate_right2),
        .x_rotate_left(x_rotate_left2),
        .y_move_left(y_move_left2),
        .y_move_right(y_move_right2),
        .y_move_down(y_move_down2),
        .y_rotate_left(y_rotate_left2),
        .y_rotate_right(y_rotate_right2),
        .get_new_block(get_new_block2),
        .can_move(can_move2),
        .block(block2),
        .BOARD_BUSY(BOARD_BUSY2),
        .frame_clk_rising_edge(frame_clk_dummy),
        .player_num(2'd2),
        .*);

    // Display keycode on hex display
    HexDriver hex_inst_0 (keycode[3:0], HEX0);
    HexDriver hex_inst_1 (keycode[7:4], HEX1);
endmodule
