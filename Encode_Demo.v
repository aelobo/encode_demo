
module Encode_Demo (
	// Inputs
	CLOCK_50,
	KEY,

	// Bidirectionals
	PS2_CLK,
	PS2_DAT,
	
	// Outputs
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,

    LEDR
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/

// Inputs
input				CLOCK_50;
input		[3:0]	KEY;

// Bidirectionals
inout				PS2_CLK;
inout				PS2_DAT;

// Outputs
output		[6:0]	HEX0;
output		[6:0]	HEX1;
output		[6:0]	HEX2;
output		[6:0]	HEX3;
output		[6:0]	HEX4;
output		[6:0]	HEX5;

output      [9:0]   LEDR;

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

// Internal Wires
wire                ps2_clk_posedge;

wire		[7:0]	received_data;
wire				received_data_en;

wire        [7:0]   o_outputData;
wire                o_valid;        

// Internal Registers
reg         [2:0]   state;
reg                 rotate;             // rotate signal, input to State_Machine

reg         [7:0]   history;            // registered scan code             (plaintext)
wire        [7:0]   ascii_plaintext;    // scan code -> ascii conversion    (plaintext)
reg         [7:0]   encoded_data;       // encoded ascii value              (ciphertext)

/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

parameter STATE_INIT    = 3'd0;
parameter STATE_IDLE    = 3'd1;
parameter STATE_MAKE    = 3'd2;
parameter STATE_BREAK   = 3'd3;
parameter STATE_WAIT    = 3'd4;

reg [12:0] counter;

always @(posedge CLOCK_50) begin
    // On reset, go to IDLE state
    if (~KEY[0]) begin
        state <= STATE_INIT;
        rotate <= 1'b1;
        history <= 8'b0;
        counter <= 13'b0;
        encoded_data <= 8'h00;
    end
    else begin
        case (state)
            STATE_INIT: begin
                state <= STATE_IDLE;
                rotate <= 1'b1;
                history <= 8'b0;
                counter <= 13'b0;
                encoded_data <= 8'h00;
            end
            STATE_IDLE: begin
                if (received_data_en) begin
                    state   <= STATE_MAKE;
                    history <= received_data;
                end
                else begin
                    state   <= STATE_IDLE;
                    history <= history;
                end
                rotate <= 1'b0;
                encoded_data <= 8'h00;
            end
            STATE_MAKE: begin
                if ((received_data == 8'hF0)) begin
                    state   <= STATE_BREAK;
                end
                else begin
                    state   <= STATE_MAKE;
                end
                history <= history;
                rotate <= 1'b0;
                encoded_data <= o_outputData;
            end
            STATE_BREAK: begin
                if ((received_data == history)) begin
                    state   <= STATE_WAIT;
                    rotate <= 1'b1;
                    counter <= 13'b0;
                end
                else begin
                    state   <= STATE_BREAK;
                    rotate <= 1'b0;
                end
                history <= history;
                encoded_data <= 8'h00;
            end 
            STATE_WAIT: begin
                if (counter == 13'd5000)
                    state <= STATE_IDLE;
                else
                    state <= STATE_WAIT;
                history <= history;
                rotate <= 1'b1;
                counter <= counter + 13'b1;
                encoded_data <= 8'h00;
            end   
            default: begin
                state <= STATE_IDLE;
                history <= 8'b0;
                rotate <= 1'b0;
                counter <= 13'b0;
                encoded_data <= 8'h00;
            end
        endcase
    end
end


/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

assign LEDR[0] = (state == STATE_INIT);
assign LEDR[1] = (state == STATE_IDLE);
assign LEDR[2] = (state == STATE_MAKE);
assign LEDR[3] = (state == STATE_BREAK);
assign LEDR[4] = (state == STATE_WAIT);

assign LEDR[5] = 1'b0;
assign LEDR[6] = 1'b0;
assign LEDR[7] = 1'b0;
assign LEDR[8] = 1'b0;
assign LEDR[9] = 1'b0;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

    PS2_Controller PS2 (
        // Inputs
        .CLOCK_50			(CLOCK_50),
        .reset				(~KEY[0]),

        // Bidirectionals
        .PS2_CLK			(PS2_CLK),
        .PS2_DAT			(PS2_DAT),

        // Outputs
        .received_data		(received_data),
        .received_data_en	(received_data_en)
    );

    // Convert scan code to ASCII for encryption
    Scan_Code_to_ASCII ASCII (
        .scan_code          (history),
        .ascii_plaintext    (ascii_plaintext) // input as ASCII
    );

    // State machine to control encryption
    State_Machine Enigma (
        .i_clock			(CLOCK_50),
        .reset				(~KEY[0]),
        .i_inputData        (ascii_plaintext),
        .rotate             (rotate),

        .o_outputData	    (o_outputData), // final output (in decimal)
        .o_valid            (o_valid)
    );

    // Plaintext hex scan code on seven segment 0
    Hexadecimal_To_Seven_Segment Segment0 (
        .hex_number			(history[3:0]),
        .seven_seg_display	(HEX0)
    );

    // Plaintext hex scan code on seven segment 1
    Hexadecimal_To_Seven_Segment Segment1 (
        .hex_number			(history[7:4]),
        .seven_seg_display	(HEX1)
    );

    // Plaintext hex scan code on seven segment 2
    Hexadecimal_To_Seven_Segment Segment2 (
        .hex_number			(received_data[3:0]),
        .seven_seg_display	(HEX2)
    );

    // Plaintext hex scan code on seven segment 3
    Hexadecimal_To_Seven_Segment Segment3 (
        .hex_number			(received_data[7:4]),
        .seven_seg_display	(HEX3)
    );

    // Plaintext hex scan code on seven segment 4
    Hexadecimal_To_Seven_Segment Segment4 (
        .hex_number			(encoded_data[3:0]),
        .seven_seg_display	(HEX4)
    );

    // Plaintext hex scan code on seven segment 5
    Hexadecimal_To_Seven_Segment Segment5 (
        .hex_number			(encoded_data[7:4]),
        .seven_seg_display	(HEX5)
    );

endmodule
