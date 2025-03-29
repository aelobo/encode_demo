`default_nettype none

module State_Machine(
	input i_clock,
    input reset,
	input [7:0] i_inputData,
    input rotate,
	input rotor_start_3_en, rotor_start_2_en, rotor_start_1_en, 
	output reg [4:0] o_rotor_start_3, o_rotor_start_2, o_rotor_start_1,
	output reg [7:0] o_outputData,
	output reg o_valid
);	

	reg [2:0] rotor_type_3 = 3'b010;
	reg [2:0] rotor_type_2 = 3'b001;
	reg [2:0] rotor_type_1 = 3'b000;

	reg [4:0] rotor_start_3;
	reg [4:0] rotor_start_2;
	reg [4:0] rotor_start_1;

	always @(posedge clock) begin
		if (reset) begin
			rotor_start_3 = 5'b00000;
			rotor_start_2 = 5'b00000;
			rotor_start_1 = 5'b00000;
		end
		else begin
			if (rotor_start_3_en) begin
				rotor_start_3 <= rotor_start_3 + 5'b00001;
			end
		    else if (rotor_start_2_en) begin
				rotor_start_3 <= rotor_start_2 + 5'b00001;
			end
			else if (rotor_start_1_en) begin 
				rotor_start_3 <= rotor_start_1 + 5'b00001;
			end
		end
	end

	reg [4:0] ring_position_3 = 5'b00000;
	reg [4:0] ring_position_2 = 5'b00000;
	reg [4:0] ring_position_1 = 5'b00000;
	reg reflector_type = 1'b0;

	wire [4:0] rotor1;
	wire [4:0] rotor2;
	wire [4:0] rotor3;
	
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
	
    encodeASCII encode(.ascii(i_inputData), .code(inputCode), .valid(valid)); // output o_valid
		
	rotor rotorcontrol(.clock(i_clock),.rotor1(rotor1),.rotor2(rotor2),.rotor3(rotor3),.reset(reset),.rotate(rotate),
	        .rotor_type_2(rotor_type_2),.rotor_type_3(rotor_type_3),
		    .rotor_start_1(rotor_start_1),.rotor_start_2(rotor_start_2),.rotor_start_3(rotor_start_3)
			);
            
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
