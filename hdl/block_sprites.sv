import types::*;

module block_sprites(
  input logic [9:0] address,
  input block_color block,
  output logic [4:0] data
);

// Cyan iblock
parameter logic [0:399][4:0] IBLOCK =
{5'd19, 5'd19, 5'd6, 5'd6, 5'd6, 5'd6, 5'd6, 5'd6, 5'd6, 5'd6, 5'd6, 5'd6, 5'd6, 5'd6, 5'd6, 5'd6, 5'd6, 5'd6, 5'd19, 5'd19, 
5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 
5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 
5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 
5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 
5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 
5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 
5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 
5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 
5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 
5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 
5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 
5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 
5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 
5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 
5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 
5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 
5'd19, 5'd19, 5'd20, 5'd20, 5'd20, 5'd20, 5'd20, 5'd20, 5'd20, 5'd20, 5'd20, 5'd20, 5'd20, 5'd20, 5'd20, 5'd20, 5'd20, 5'd20, 5'd19, 5'd19, 
5'd19, 5'd20, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd20, 5'd19, 
5'd20, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd20};

// Blue jblock
parameter logic [0:399][4:0] JBLOCK=
{5'd20, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd20, 
5'd20, 5'd20, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd19, 5'd20, 
5'd22, 5'd20, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd20, 5'd22, 
5'd22, 5'd22, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd22, 5'd22, 
5'd22, 5'd22, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd22, 5'd22, 
5'd22, 5'd22, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd22, 5'd22, 
5'd22, 5'd22, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd22, 5'd22, 
5'd22, 5'd22, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd22, 5'd22, 
5'd22, 5'd22, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd22, 5'd22, 
5'd22, 5'd22, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd22, 5'd22, 
5'd22, 5'd22, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd22, 5'd22, 
5'd22, 5'd22, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd22, 5'd22, 
5'd22, 5'd22, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd22, 5'd22, 
5'd22, 5'd22, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd22, 5'd22, 
5'd22, 5'd22, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd22, 5'd22, 
5'd22, 5'd22, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd22, 5'd22, 
5'd22, 5'd22, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd5, 5'd22, 5'd22, 
5'd22, 5'd20, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd20, 5'd22, 
5'd20, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd20, 
5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22};

// Orange lblock
parameter logic [0:399][4:0] LBLOCK =
{5'd25, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 
5'd24, 5'd25, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd12, 
5'd24, 5'd24, 5'd25, 5'd25, 5'd25, 5'd25, 5'd25, 5'd25, 5'd25, 5'd25, 5'd25, 5'd25, 5'd25, 5'd25, 5'd25, 5'd25, 5'd25, 5'd25, 5'd24, 5'd24, 
5'd24, 5'd24, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd24, 5'd24, 
5'd24, 5'd24, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd24, 5'd24, 
5'd24, 5'd24, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd24, 5'd24, 
5'd24, 5'd24, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd24, 5'd24, 
5'd24, 5'd24, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd24, 5'd24, 
5'd24, 5'd24, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd24, 5'd24, 
5'd24, 5'd24, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd24, 5'd24, 
5'd24, 5'd24, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd24, 5'd24, 
5'd24, 5'd24, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd24, 5'd24, 
5'd24, 5'd24, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd24, 5'd24, 
5'd24, 5'd24, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd24, 5'd24, 
5'd24, 5'd24, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd24, 5'd24, 
5'd24, 5'd24, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd24, 5'd24, 
5'd24, 5'd24, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd24, 5'd24, 
5'd24, 5'd24, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd23, 5'd24, 5'd24, 
5'd24, 5'd24, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd24, 5'd24, 
5'd24, 5'd15, 5'd3, 5'd3, 5'd3, 5'd3, 5'd3, 5'd3, 5'd3, 5'd3, 5'd3, 5'd3, 5'd3, 5'd3, 5'd3, 5'd3, 5'd3, 5'd3, 5'd15, 5'd24};

// Yellow oblock
parameter logic [0:399][4:0] OBLOCK =
{5'd12, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd12, 
5'd16, 5'd12, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd4, 5'd12, 5'd16, 
5'd16, 5'd16, 5'd16, 5'd12, 5'd12, 5'd12, 5'd12, 5'd12, 5'd12, 5'd12, 5'd12, 5'd12, 5'd12, 5'd12, 5'd12, 5'd12, 5'd12, 5'd12, 5'd16, 5'd16, 
5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 
5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 
5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 
5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 
5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 
5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 
5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 
5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 
5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 
5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 
5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 
5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 
5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 
5'd16, 5'd16, 5'd16, 5'd12, 5'd12, 5'd12, 5'd12, 5'd12, 5'd12, 5'd12, 5'd12, 5'd12, 5'd12, 5'd12, 5'd12, 5'd12, 5'd12, 5'd16, 5'd16, 5'd16, 
5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 
5'd16, 5'd16, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd16, 5'd16, 
5'd16, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd15, 5'd16};

// Green sblock
parameter logic [0:399][4:0] SBLOCK =
{5'd13, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd13, 
5'd18, 5'd13, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd17, 
5'd18, 5'd18, 5'd17, 5'd17, 5'd17, 5'd17, 5'd17, 5'd17, 5'd17, 5'd17, 5'd17, 5'd17, 5'd17, 5'd17, 5'd17, 5'd17, 5'd17, 5'd17, 5'd17, 5'd18, 
5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 
5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 
5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 
5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 
5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 
5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 
5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 
5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 
5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 
5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 
5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 
5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 
5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 
5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 
5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 
5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 
5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18, 5'd18};

// Magenta tblock
parameter logic [0:399][4:0] TBLOCK =
{5'd13, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd13, 
5'd21, 5'd13, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd7, 5'd13, 5'd21, 
5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 
5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 
5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 
5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 
5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 
5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 
5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 
5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 
5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 
5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 
5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 
5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 
5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 
5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 
5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 
5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 
5'd21, 5'd21, 5'd21, 5'd22, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd21, 5'd22, 5'd21, 5'd21, 
5'd21, 5'd21, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd22, 5'd21};

// Red zblock
parameter logic [0:399][4:0] ZBLOCK =
{5'd10, 5'd10, 5'd11, 5'd11, 5'd11, 5'd11, 5'd11, 5'd11, 5'd11, 5'd11, 5'd11, 5'd11, 5'd11, 5'd11, 5'd11, 5'd11, 5'd11, 5'd11, 5'd11, 5'd10, 
5'd9, 5'd10, 5'd10, 5'd11, 5'd11, 5'd11, 5'd11, 5'd11, 5'd11, 5'd11, 5'd11, 5'd11, 5'd11, 5'd11, 5'd11, 5'd11, 5'd11, 5'd11, 5'd10, 5'd9, 
5'd9, 5'd9, 5'd9, 5'd1, 5'd1, 5'd1, 5'd1, 5'd1, 5'd1, 5'd1, 5'd1, 5'd1, 5'd1, 5'd1, 5'd1, 5'd1, 5'd1, 5'd1, 5'd9, 5'd9, 
5'd9, 5'd9, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd9, 
5'd9, 5'd9, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd9, 
5'd9, 5'd9, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd9, 
5'd9, 5'd9, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd9, 
5'd9, 5'd9, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd9, 
5'd9, 5'd9, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd9, 
5'd9, 5'd9, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd9, 
5'd9, 5'd9, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd9, 
5'd9, 5'd9, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd9, 
5'd9, 5'd9, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd9, 
5'd9, 5'd9, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd9, 
5'd9, 5'd9, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd9, 
5'd9, 5'd9, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd9, 
5'd9, 5'd9, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd9, 
5'd9, 5'd9, 5'd9, 5'd9, 5'd9, 5'd9, 5'd9, 5'd9, 5'd9, 5'd9, 5'd9, 5'd9, 5'd9, 5'd9, 5'd9, 5'd9, 5'd9, 5'd9, 5'd9, 5'd9, 
5'd9, 5'd9, 5'd8, 5'd8, 5'd8, 5'd8, 5'd8, 5'd8, 5'd8, 5'd8, 5'd8, 5'd8, 5'd8, 5'd8, 5'd8, 5'd8, 5'd8, 5'd8, 5'd8, 5'd9, 
5'd9, 5'd8, 5'd3, 5'd8, 5'd8, 5'd8, 5'd8, 5'd8, 5'd8, 5'd8, 5'd8, 5'd8, 5'd8, 5'd8, 5'd8, 5'd8, 5'd8, 5'd8, 5'd3, 5'd8};

// Empty block
parameter logic [0:399][4:0] EBLOCK =
{5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd28, 
5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd28, 5'd28, 
5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd28, 5'd28, 5'd28, 
5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd28, 5'd28, 5'd28, 
5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd28, 5'd28, 5'd28, 
5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd28, 5'd28, 5'd28, 
5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd28, 5'd28, 5'd28, 
5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd28, 5'd28, 5'd28, 
5'd28, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd28, 5'd28, 5'd26, 
5'd28, 5'd28, 5'd28, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd28, 5'd26, 5'd26, 
5'd28, 5'd28, 5'd28, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd28, 5'd26, 5'd26, 
5'd28, 5'd28, 5'd28, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd28, 5'd26, 5'd26, 
5'd28, 5'd28, 5'd28, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd28, 5'd26, 5'd26, 
5'd28, 5'd28, 5'd28, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd28, 5'd26, 5'd26, 
5'd28, 5'd28, 5'd28, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd28, 5'd26, 5'd26, 
5'd28, 5'd28, 5'd28, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd28, 5'd26, 5'd26, 
5'd28, 5'd28, 5'd28, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd27, 5'd28, 5'd26, 5'd26, 
5'd28, 5'd28, 5'd28, 5'd28, 5'd28, 5'd28, 5'd28, 5'd28, 5'd28, 5'd28, 5'd28, 5'd28, 5'd28, 5'd28, 5'd28, 5'd28, 5'd28, 5'd26, 5'd26, 5'd26, 
5'd28, 5'd28, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 
5'd28, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26, 5'd26};

always_comb
begin
  data = EBLOCK[address];
  case (block)
    CYAN:
      data = IBLOCK[address];
    BLUE:
      data = JBLOCK[address];
    ORANGE:
      data = LBLOCK[address];
    YELLOW:
      data = OBLOCK[address];
    GREEN:
      data = SBLOCK[address];
    RED:
      data = ZBLOCK[address];
    MAGENTA:
      data = TBLOCK[address];
    EMPTY:
      data = EBLOCK[address];
  endcase
end

endmodule
