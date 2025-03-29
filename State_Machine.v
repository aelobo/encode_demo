`default_nettype none

module State_Machine(
	input i_clock,
    input reset,
	input [7:0] i_inputData,
    input rotate,
	input rotor_start_3_en,
    input rotor_start_2_en, 
    input rotor_start_1_en, 
	output reg [4:0] rotor_start_3, 
    output reg [4:0] rotor_start_2, 
    output reg [4:0] rotor_start_1,
	output reg [7:0] o_outputData,
	output reg o_valid,
    output reg update_settings_out,
    output reg [4:0] rotor3_out,
    output reg [4:0] rotor2_out,
    output reg [4:0] rotor1_out
);		

    wire [4:0]   rotor_start_3_temp;
    wire [4:0]   rotor_start_2_temp;
    wire [4:0]   rotor_start_1_temp;

    wire update_settings;

    reg [2:0] rotor_type_3 = 3'b010;
	reg [2:0] rotor_type_2 = 3'b001;
	reg [2:0] rotor_type_1 = 3'b000;

	reg [4:0] ring_position_3 = 5'b00000;
	reg [4:0] ring_position_2 = 5'b00000;
	reg [4:0] ring_position_1 = 5'b00000;
    
	reg reflector_type = 1'b0;

	wire [4:0] rotor1;
	wire [4:0] rotor2;
	wire [4:0] rotor3;

    // wire [4:0] rotor1_out;
	// wire [4:0] rotor2_out;
	// wire [4:0] rotor3_out;
	
	wire [4:0] value0;	
	wire [4:0] value1;
	wire [4:0] value2;
	wire [4:0] value3;
	wire [4:0] value4;
	wire [4:0] value5;
	wire [4:0] value6;
	wire [4:0] value7;
	wire [4:0] value8;
	
	wire [4:0] inputCode;
    wire [7:0] final_ascii;

    wire valid;

    wire rotor_3_increment;
    wire rotor_2_increment;
    wire rotor_1_increment;

    rotor_settings settings(
        .i_clock            (i_clock),
        .reset              (reset),
        .rotor_start_3_en   (rotor_start_3_en),
        .rotor_start_2_en   (rotor_start_2_en),
        .rotor_start_1_en   (rotor_start_1_en), 
	    .rotor_start_3  (rotor_start_3_temp), 
        .rotor_start_2  (rotor_start_2_temp), 
        .rotor_start_1  (rotor_start_1_temp),
        .update_settings(update_settings),
        .rotor_3_increment(rotor_3_increment),
        .rotor_2_increment(rotor_2_increment),
        .rotor_1_increment(rotor_1_increment)
    ); 

    always @(posedge i_clock) begin
        rotor_start_3 <= rotor_start_3_temp;
        rotor_start_2 <= rotor_start_2_temp;
        rotor_start_1 <= rotor_start_1_temp;

        update_settings_out <= update_settings;

        rotor3_out <= rotor3;
        rotor2_out <= rotor2;
        rotor1_out <= rotor1;
    end
	
    encodeASCII encode(.ascii(i_inputData), .code(inputCode), .valid(valid)); // output o_valid
		
	rotor rotorcontrol(.clock(i_clock),.rotor1(rotor1),.rotor2(rotor2),.rotor3(rotor3),.reset(reset),.rotate(rotate),
	        .rotor_type_2(rotor_type_2),.rotor_type_3(rotor_type_3),
		    .rotor_start_1(rotor_start_1),.rotor_start_2(rotor_start_2),.rotor_start_3(rotor_start_3),.update_settings(update_settings),
			.rotor_3_increment(rotor_3_increment),
            .rotor_2_increment(rotor_2_increment),
            .rotor_1_increment(rotor_1_increment));
            
	plugboardEncode plugboard(.code(inputCode),.val(value0));	
	encode #(.REVERSE(0)) rot3Encode(.inputValue(inputCode),.rotor(rotor3),.outputValue(value1),.rotor_type(rotor_type_3),.ring_position(ring_position_3));
	encode #(.REVERSE(0)) rot2Encode(.inputValue(value1),.rotor(rotor2),.outputValue(value2),.rotor_type(rotor_type_2),.ring_position(ring_position_2));
	encode #(.REVERSE(0)) rot1Encode(.inputValue(value2),.rotor(rotor1),.outputValue(value3),.rotor_type(rotor_type_1),.ring_position(ring_position_1));
	reflectorEncode reflector(.code(value3),.val(value4),.reflector_type(reflector_type));
	encode #(.REVERSE(1)) rot1EncodeRev(.inputValue(value4),.rotor(rotor1),.outputValue(value5),.rotor_type(rotor_type_1),.ring_position(ring_position_1));
	encode #(.REVERSE(1)) rot2EncodeRev(.inputValue(value5),.rotor(rotor2),.outputValue(value6),.rotor_type(rotor_type_2),.ring_position(ring_position_2));
	encode #(.REVERSE(1)) rot3EncodeRev(.inputValue(value6),.rotor(rotor3),.outputValue(value7),.rotor_type(rotor_type_3),.ring_position(ring_position_3));

	decodeASCII decode(.code(value7), .ascii(final_ascii));

    always @(posedge i_clock) begin
        o_valid <= valid;
        o_outputData <= final_ascii;
    end
	
endmodule
