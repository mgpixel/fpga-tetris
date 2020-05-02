// A pseudo random module to create blocks for the game. Most games have a bag of 7
// to be choosing from, this one just generates 1 block at a time. Holds the block index
// until a new one is needed.
module tetromino_generator
(
  input Clk,
  input Reset,
  input new_block,
  input logic [2:0] new_move,
  output logic [2:0] block_idx
);

logic [9:0] start = 10'd385;
logic [9:0] generated_bits = 10'd220;
logic [2:0] fair_idx;
logic [2:0] old_idx;
logic [2:0] fair_counter;
logic [2:0] fair_counter_in;

always_ff @(posedge Clk)
begin
  if (Reset) begin
    generated_bits <= generated_bits + start;
    fair_counter <= 3'd0;
  end
  old_idx <= block_idx;
  fair_counter <= fair_counter_in;
  generated_bits <= generated_bits + new_move + block_idx;
end

always_comb
begin
  block_idx = 3'd0;
  fair_counter_in = fair_counter;
  if (Reset)
    block_idx = generated_bits[5:3];
  else if (new_block) begin
    block_idx = generated_bits[2:0];
    if (block_idx > 3'd6 || block_idx == old_idx) begin
      block_idx = fair_counter;
      fair_counter_in = fair_counter_in + 3'd1;
      if (fair_counter_in == 3'd7)
        fair_counter_in = 3'd0;
    end
  end
end

endmodule