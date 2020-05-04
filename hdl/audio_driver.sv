module audio_driver(
    input  logic Clk, Reset, 
    input  logic [15:0] DATA,                                       // Sound data from NIOS-II
    input  logic AUD_BCLK, AUD_ADCDAT, AUC_DACLRCK, AUD_ADCLRCK,    // WM8731 Input Signals
    output logic AUD_MCLK, AUD_DACDAT, I2C_SDAT, I2C_SCLK,          // WM8731 Output Signals
    output logic NEXT_SAMPLE                                        // Signal to NIOS-II to move on to next 16 bits
);

enum logic [1:0] {RESET, INIT_, WRITE, NEXT} state, next_state;

logic INIT, INIT_FINISH, data_over;
logic adc_full; // unused signal
logic [31:0] ADCDATA; // unused signal


audio_interface audio_intf(
    .clk(Clk), .LDATA(DATA), .RDATA(DATA), .*
);

always_ff @ (posedge Clk)
begin
    if (Reset)
        state <= RESET;
    else
        state <= next_state;
end

always_comb
begin
    next_state = state;
    NEXT_SAMPLE = 1'b0;
    case (state)
        RESET:
        begin
            next_state = INIT_;
        end
        INIT_:
        begin
            if (INIT_FINISH)
                next_state = WRITE;
        end
        WRITE:
        begin
            if (data_over)
                next_state = NEXT;
        end
        NEXT:
        begin
            if (~data_over)
            begin
                NEXT_SAMPLE = 1'b1;
                next_state = WRITE;
            end
            
        end
    endcase
end

endmodule
