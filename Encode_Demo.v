
module Encode_Demo (
	// Inputs
	CLOCK_50,
	KEY,
    SW,

	// Bidirectionals
	PS2_CLK,
	PS2_DAT,
    GPIO,
	
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
input       [9:0]   SW;

// Bidirectionals
inout				PS2_CLK;
inout				PS2_DAT;
inout       [35:0]  GPIO;

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

wire                rotor_start_3_sel;   
wire                rotor_start_2_sel;
wire                rotor_start_1_sel;

wire        [4:0]   rotor_start_3;    // rotor starting position
wire        [4:0]   rotor_start_2;
wire        [4:0]   rotor_start_1;
reg         [7:0]   display_rotor_start;

wire        [9:0]   SW_sync;            // synchronized inputs
wire        [3:0]   KEY_sync;           

// Internal Registers
reg         [2:0]   state;
reg                 rotate;             // rotate signal, input to State_Machine

reg                 rotor_start_3_en;   // rotor start enables, input to State_Machine
reg                 rotor_start_2_en;
reg                 rotor_start_1_en;

reg         [7:0]   history;            // registered scan code             (plaintext)
wire        [7:0]   ascii_plaintext;    // scan code -> ascii conversion    (plaintext)
reg         [7:0]   encoded_data;       // encoded ascii value              (ciphertext)

wire                update_settings_out;

wire        [4:0]   rotor3_out;
wire        [4:0]   rotor2_out;
wire        [4:0]   rotor1_out;

wire        [7:0]   c0, c1, c2, c3, c4, c5, c6, c7;

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
    if (~KEY_sync[0]) begin
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


assign rotor_start_3_sel =  SW_sync[7] && ~SW_sync[8] && ~SW_sync[9];
assign rotor_start_2_sel = ~SW_sync[7] &&  SW_sync[8] && ~SW_sync[9];
assign rotor_start_1_sel = ~SW_sync[7] && ~SW_sync[8] &&  SW_sync[9];

always @* begin
    rotor_start_3_en  = rotor_start_3_sel && ~KEY_sync[3];
    rotor_start_2_en  = rotor_start_2_sel && ~KEY_sync[3];
    rotor_start_1_en  = rotor_start_1_sel && ~KEY_sync[3];
end

always @* begin
    if (rotor_start_3_sel)          display_rotor_start = {3'b000, rotor_start_3};
    else if (rotor_start_2_sel)     display_rotor_start = {3'b000, rotor_start_2};
    else if (rotor_start_1_sel)     display_rotor_start = {3'b000, rotor_start_1};
    else                            display_rotor_start = 8'b0;
end



// CLOCK DIVIDER FOR MAX SEVEN SEGMENT
// 3-bit counter to count from 0 to 4
reg [2:0] clk_counter;
reg       clk_out;

always @(posedge CLOCK_50) begin
if (~KEY[0]) begin
    clk_counter <= 3'd0;
    clk_out <= 1'b0;
end else begin
    // increment counter; reset to 0 when count reaches 4
    if (clk_counter == 3'd4)
    clk_counter <= 3'd0;
    else
    clk_counter <= clk_counter + 3'd1;
    
    // generate clk_out: high for 2 cycles, low for 3 cycles
    if (clk_counter < 3'd2)
    clk_out <= 1'b1;
    else
    clk_out <= 1'b0;
end
end

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

assign HEX2 = 7'h7F;
// assign HEX3 = 7'h7F;
// assign HEX5 = 7'h7F;

// assign LEDR[0] = (state == STATE_INIT);
// assign LEDR[1] = (state == STATE_IDLE);
// assign LEDR[2] = (state == STATE_MAKE);
// assign LEDR[3] = (state == STATE_BREAK);
// assign LEDR[4] = (state == STATE_WAIT);

assign LEDR[0] = update_settings_out;
assign LEDR[1] = 1'b0;
assign LEDR[2] = 1'b0;
assign LEDR[3] = 1'b0;

assign LEDR[4] = rotor_start_3_en;
assign LEDR[5] = rotor_start_2_en;
assign LEDR[6] = rotor_start_1_en;

assign LEDR[7] = rotor_start_3_sel;
assign LEDR[8] = rotor_start_2_sel;
assign LEDR[9] = rotor_start_1_sel;

assign c2      = 8'b0;
// assign c3      = 8'b0;
// assign c4      = 8'b0;
// assign c5      = 8'b0;
assign c6      = 8'b0;
assign c7      = 8'b0;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

    PS2_Controller PS2 (
        // Inputs
        .CLOCK_50			(CLOCK_50),
        .reset				(~KEY_sync[0]),

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
        .reset				(~KEY_sync[0]),
        .i_inputData        (ascii_plaintext),
        .rotate             (rotate),

        .rotor_start_3_en   (rotor_start_3_en),
        .rotor_start_2_en   (rotor_start_2_en),
        .rotor_start_1_en   (rotor_start_1_en),

        .rotor_start_3    (rotor_start_3),
        .rotor_start_2    (rotor_start_2),
        .rotor_start_1    (rotor_start_1), 

        .o_outputData	    (o_outputData), // final output (in decimal)
        .o_valid            (o_valid),
        .update_settings_out(update_settings_out),

        .rotor3_out         (rotor3_out),
        .rotor2_out         (rotor2_out),
        .rotor1_out         (rotor1_out)
    );


    // Plaintext hex scan code on seven segment 0
    Scan_Code_to_Seven_Segment Segment0 (
        .scan_code			(history[7:0]),
        .seven_seg_display	(HEX0)
    );

    // Plaintext hex scan code on seven segment 2
    ASCII_to_Seven_Segment Segment1 (
        .ascii              (encoded_data[7:0]),
        .seven_seg_display	(HEX1)
    );

    // Plaintext hex scan code on seven segment 4
    ASCII_to_Seven_Segment Segment2 (
        .ascii			    ({3'b0, rotor3_out[4:0]} + 8'h40),
        .seven_seg_display	(HEX3)
    );

    // Plaintext hex scan code on seven segment 4
    ASCII_to_Seven_Segment Segment3 (
        .ascii			    ({3'b0, rotor2_out[4:0]} + 8'h41),
        .seven_seg_display	(HEX4)
    );

    // Plaintext hex scan code on seven segment 4
    ASCII_to_Seven_Segment Segment4 (
        .ascii			    ({3'b0, rotor1_out[4:0]} + 8'h41),
        .seven_seg_display	(HEX5)
    );

///////////////

    Scan_Code_to_MAX C0 (
        .scan_code			(history[7:0]),
        .seven_seg_display	(c0)
    );

    ASCII_to_MAX C1 (
        .ascii			    ({3'b0, rotor3_out[4:0]} + 8'h40),
        .seven_seg_display	(c1)
    );

    ASCII_to_MAX C3 (
        .ascii			    ({3'b0, rotor3_out[4:0]} + 8'h40),
        .seven_seg_display	(c3)
    );

    ASCII_to_MAX C4 (
        .ascii			    ({3'b0, rotor2_out[4:0]} + 8'h41),
        .seven_seg_display	(c4)
    );

    ASCII_to_MAX C5 (
        .ascii			    ({3'b0, rotor1_out[4:0]} + 8'h41),
        .seven_seg_display	(c5)
    );


    top max_top(
        .CLK                (clk_out),

        .c0                 (c0),
        .c1                 (c1),
        .c2                 (c2),
        .c3                 (c3),
        .c4                 (c4),
        .c5                 (c5),
        .c6                 (c6),
        .c7                 (c7), 

        .PIN_13             (GPIO[5]), // CLK
        .PIN_12             (GPIO[1]),  // DAT IN
        .PIN_11             (GPIO[3]),  // CS
        .USBPU              ()
    );


    // Hexadecimal_To_Seven_Segment Segment4 (
    //     .hex_number			(display_rotor_start[3:0]),
    //     .seven_seg_display	(HEX4)
    // );

    // // // Plaintext hex scan code on seven segment 1
    // Hexadecimal_To_Seven_Segment Segment5 (
    //     .hex_number			(display_rotor_start[7:4]),
    //     .seven_seg_display	(HEX5)
    // );
    


    // // Plaintext hex scan code on seven segment 0
    // Hexadecimal_To_Seven_Segment Segment0 (
    //     .hex_number			(display_rotor_start[3:0]),
    //     .seven_seg_display	(HEX0)
    // );

    // // Plaintext hex scan code on seven segment 1
    // Hexadecimal_To_Seven_Segment Segment1 (
    //     .hex_number			(display_rotor_start[7:4]),
    //     .seven_seg_display	(HEX1)
    // );

    // // Plaintext hex scan code on seven segment 2
    // Hexadecimal_To_Seven_Segment Segment2 (
    //     .hex_number			(received_data[3:0]),
    //     .seven_seg_display	(HEX2)
    // );

    // // Plaintext hex scan code on seven segment 3
    // Hexadecimal_To_Seven_Segment Segment3 (
    //     .hex_number			(received_data[7:4]),
    //     .seven_seg_display	(HEX3)
    // );

    // // Plaintext hex scan code on seven segment 4
    // Hexadecimal_To_Seven_Segment Segment4 (
    //     .hex_number			(encoded_data[3:0]),
    //     .seven_seg_display	(HEX4)
    // );

    // // Plaintext hex scan code on seven segment 5
    // Hexadecimal_To_Seven_Segment Segment5 (
    //     .hex_number			(encoded_data[7:4]),
    //     .seven_seg_display	(HEX5)
    // );

    Synchronizer #(4) KeySync (
        .clock              (CLOCK_50),
        .async              (KEY[3:0]),
        .sync               (KEY_sync[3:0])
    );

    Synchronizer #(10) SwitchSync (
        .clock              (CLOCK_50),
        .async              (SW[9:0]),
        .sync               (SW_sync[9:0])
    );

endmodule