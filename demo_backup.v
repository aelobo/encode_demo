
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
wire		[7:0]	ps2_key_data;
wire				ps2_key_pressed;
wire        [7:0]   i_inputData;
wire                o_ready;
wire        [7:0]   o_outputData;
wire                o_valid;        

// Internal Registers
reg			[7:0]	last_data_received; // holds scan code
reg         [7:0]   last_data_received_ascii; // holds ascii


reg    [7:0]   encoded_data;

/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/




reg state;
reg rotate;

reg [7:0] history;

parameter STATE_IDLE    = 2'b00;
parameter STATE_MAKE    = 2'b01;
parameter STATE_BREAK   = 2'b10;

always @(posedge CLOCK_50) begin
    // On reset, go to IDLE state
    if (~KEY[0]) begin

    end
    else begin


    end

end



// parameter STATE_NO_PRESS    = 1'b0;
// parameter STATE_PRESSED     = 1'b1;

// wire key_released;
// assign key_released = (last_data_received != ps2_key_data);

// always @(posedge CLOCK_50) begin
//     // On reset, do not rotate the rotors yet
//     if (~KEY[0]) begin
//         state <= STATE_NO_PRESS;
//         encoded_data <= 8'b0;
//         rotate <= 1'b0;
//         last_data_received <= 8'b0;
//         last_data_received_ascii <= 8'b0; 
//     end
//     else begin
//         case (state) 
//             STATE_NO_PRESS: begin
//                 if (~key_released) state <= STATE_PRESSED;
//                 else state <= STATE_NO_PRESS;
//                 rotate <= 1'b0;
//             end
//             STATE_PRESSED: begin
//                 if (key_released) state <= STATE_NO_PRESS;
//                 else state <= STATE_PRESSED;

//                 // Rotate only high for one cycle
//                 // Only change the value of encoded data when key is released
//                 if (key_released) begin
//                     rotate <= 1'b1;
//                     encoded_data <= o_outputData;
//                 end
//             end
//         endcase
//         last_data_received <= ps2_key_data;
//         last_data_received_ascii <= i_inputData; 
//     end
// end

assign LEDR[0] = (state == STATE_NO_PRESS);
assign LEDR[1] = (state == STATE_PRESSED);
assign LEDR[2] = (key_released);
assign LEDR[3] = (ps2_key_pressed);

assign LEDR[4] = 1'b0;
assign LEDR[5] = 1'b0;
assign LEDR[6] = 1'b0;
assign LEDR[7] = 1'b0;
assign LEDR[8] = 1'b0;
assign LEDR[9] = 1'b0;



// always @(posedge CLOCK_50)
// begin
//     // RESET CASE
// 	if (KEY[0] == 1'b0) begin
// 		last_data_received <= ps2_key_data;
//         last_data_received_ascii <= i_inputData; 
//         // last_data_received <= 8'h00; //dummy val
// 		// last_data_received_ascii <= 8'h00;
// 	end
//     // NOT RESET
// 	else if (ps2_key_pressed == 1'b1) begin
//         if (last_data_received == ps2_key_data) begin
//             last_data_received <= last_data_received;
//             last_data_received_ascii <= last_data_received_ascii;   
//         end
//         else begin
//             last_data_received <= ps2_key_data;
//             last_data_received_ascii <= i_inputData; 
//         end
// 	end
//     else begin
//         last_data_received <= last_data_received;
//         last_data_received_ascii <= last_data_received_ascii; 
//     end
// end

// always @(posedge CLOCK_50)
// begin
//     // RESET CASE
// 	if (KEY[0] == 1'b0) begin
// 		last_data_received <= 8'h00; //dummy val
// 		last_data_received_ascii <= 8'h00;
// 	end

//     // NOT RESET
// 	else if (ps2_key_pressed == 1'b1) begin
//         // HOLDING VAL RESET
//         if ((ps2_key_data == last_data_received) && (last_data_received == 8'b0)) begin
//             last_data_received <= ps2_key_data;
//             last_data_received_ascii <= i_inputData; //dummy val
//         end
//         // HOLDING VAL SAME KEY
//         if ((ps2_key_data == last_data_received) && (last_data_received != 8'b0)) begin
//             last_data_received <= last_data_received;
//             last_data_received_ascii <= 8'd40; //dummy val
//         end
//         // NEW VAL
//         else begin
//             last_data_received <= ps2_key_data;
//             last_data_received_ascii <= i_inputData;
//         end
// 	end
// end

// always @(posedge CLOCK_50)
// begin
//     // RESET CASE
// 	if (KEY[0] == 1'b0) begin
// 		last_data_received <= 8'h00;
// 		last_data_received_ascii <= 8'h00;
// 	end

//     // NOT RESET
// 	else if (ps2_key_pressed == 1'b1) begin
//         // HOLDING VAL NON RESET
//         if ((ps2_key_data == last_data_received) && (ps2_key_data != 8'b0)) begin
//             last_data_received <= last_data_received;
//             last_data_received_ascii <= 8'd40; //dummy val
//         end
//         else if ((ps2_key_data == last_data_received) && (ps2_key_data == 8'b0)) begin
//             last_data_received <= ps2_key_data;
//             last_data_received_ascii <= i_inputData;
//         end
//         // NEW VAL
//         else begin
//             last_data_received <= ps2_key_data;
//             last_data_received_ascii <= i_inputData;
//         end
// 	end
// end

    
// always @(posedge CLOCK_50)
// begin
//     if (KEY[0] == 1'b0)
//         encoded_data <= 8'h00;
//     else if (o_valid == 1'b1)
//         encoded_data <= o_outputData;
// end

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

//assign HEX2 = 7'h7F;
//assign HEX3 = 7'h7F;
//assign HEX4 = 7'h7F;
//assign HEX5 = 7'h7F;

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
        .received_data		(ps2_key_data),
        .received_data_en	(ps2_key_pressed)
    );

    // Convert scan code to ASCII for encryption
    Scan_Code_to_ASCII ASCII (
        .scan_code          (last_data_received),
        .i_inputData        (i_inputData) // input as ASCII
    );

    State_Machine Enigma (
        .i_clock			(CLOCK_50),
        .reset				(~KEY[0]),
        .i_ready            (ps2_key_pressed),
        .i_inputData        (last_data_received_ascii),
        .rotate             (rotate),

        .o_ready		    (o_ready),
        .o_outputData	    (o_outputData), // final output (in decimal)
        .o_valid            (o_valid)
    );

    // Plaintext hex scan code on seven segment 0
    Hexadecimal_To_Seven_Segment Segment0 (
        .hex_number			(last_data_received[3:0]),
        .seven_seg_display	(HEX0)
    );

    // Plaintext hex scan code on seven segment 1
    Hexadecimal_To_Seven_Segment Segment1 (
        .hex_number			(last_data_received[7:4]),
        .seven_seg_display	(HEX1)
    );

    // Plaintext hex scan code on seven segment 2
    Hexadecimal_To_Seven_Segment Segment2 (
        .hex_number			(i_inputData[3:0]),
        .seven_seg_display	(HEX2)
    );

    // Plaintext hex scan code on seven segment 3
    Hexadecimal_To_Seven_Segment Segment3 (
        .hex_number			(i_inputData[7:4]),
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
