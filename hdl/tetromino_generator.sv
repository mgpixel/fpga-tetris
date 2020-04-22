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

logic [13:0] start = 14'd385;
logic [13:0] generated_bits = 14'd0;
logic [2:0] idx_in;
logic [2:0] counter;
logic [2:0] counter_in;
logic [2:0] extra_counter;
logic [2:0] extra_counter_in;

always_ff @(posedge Clk)
begin
  if (Reset) begin
    generated_bits <= generated_bits + start;
    counter <= 3'd0;
    extra_counter <= 3'd0;
  end
  else begin
    counter <= counter_in;
  end
  generated_bits <= generated_bits + new_move + extra_counter;
  block_idx <= idx_in;
end

always_comb
begin
  idx_in = block_idx;
  counter_in = counter;
  extra_counter_in = extra_counter;

  if (Reset) begin
    idx_in = generated_bits[2:0];
    counter_in = 3'd0;
  end
  if (new_block) begin
    idx_in = generated_bits[2:0];
  end
  // If idx_in is 7, ensure (some) fairness that all blocks are picked at
  // some point.
  if (idx_in > 3'd6) begin
    idx_in = counter_in;
    counter_in = counter_in + 1;
    if (counter_in > 3'd6) begin
      counter_in <= 3'd0;
    end
  end
  if (new_move) begin
    extra_counter_in = extra_counter_in + 3'd1;
  end
end

endmodule