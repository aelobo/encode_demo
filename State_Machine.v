`default_nettype none

module State_Machine(
	input i_clock,
    input reset,
	input [7:0] i_inputData,
    input rotate,

    input rotor_ring_2_en, 
    input rotor_ring_1_en, 

	input rotor_start_3_en,
    input rotor_start_2_en, 
    input rotor_start_1_en, 

    input rotor_num_3_en,
    input rotor_num_2_en, 
    input rotor_num_1_en, 

    output reg [7:0] o_outputData,
	output reg       o_valid,
    output reg       update_settings_out,

	output reg [4:0] rotor_start_3, 
    output reg [4:0] rotor_start_2, 
    output reg [4:0] rotor_start_1,

    output reg [4:0] rotor3_ring,
    output reg [4:0] rotor2_ring,
    output reg [4:0] rotor1_ring,

    output reg [4:0] rotor3_out,
    output reg [4:0] rotor2_out,
    output reg [4:0] rotor1_out,

    output reg [4:0] rotor3_num,
    output reg [4:0] rotor2_num,
    output reg [4:0] rotor1_num
);		

    // reg [4:0] rotor_num_3;
    // reg [4:0] rotor_num_2; 
    // reg [4:0] rotor_num_1;

    // reg [4:0] rotor_ring_3;
    // reg [4:0] rotor_ring_2;
    // reg [4:0] rotor_ring_1;

    wire [4:0]   rotor_ring_3_temp;
    wire [4:0]   rotor_ring_2_temp;
    wire [4:0]   rotor_ring_1_temp;

    wire [4:0]   rotor_start_3_temp;
    wire [4:0]   rotor_start_2_temp;
    wire [4:0]   rotor_start_1_temp;

    wire [2:0]   rotor_num_3_temp;
    wire [2:0]   rotor_num_2_temp;
    wire [2:0]   rotor_num_1_temp;

    wire update_settings;

    // reg [2:0] rotor_type_3 = 3'b010;
	// reg [2:0] rotor_type_2 = 3'b001;
	// reg [2:0] rotor_type_1 = 3'b000;
    // wire [2:0] rotor_type_3;
    // wire [2:0] rotor_type_2;
    // wire [2:0] rotor_type_1;

	// wire [4:0] ring_position_3
    // wire [4:0] ring_position_2;
    // wire [4:0] ring_position_1;
    
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

    wire rotor_3_num_increment;
    wire rotor_2_num_increment;
    wire rotor_1_num_increment;

    wire rotor_3_ring_increment;
    wire rotor_2_ring_increment;
    wire rotor_1_ring_increment;

    rotor_settings settings(
        .i_clock(i_clock),
        .reset(reset),

        .rotor_ring_2_en(rotor_ring_2_en),
        .rotor_ring_1_en(rotor_ring_1_en), 

        .rotor_start_3_en(rotor_start_3_en),
        .rotor_start_2_en(rotor_start_2_en),
        .rotor_start_1_en(rotor_start_1_en), 

        .rotor_num_3_en(rotor_num_3_en),
        .rotor_num_2_en(rotor_num_2_en),
        .rotor_num_1_en(rotor_num_1_en), 

        .update_settings(update_settings),

        .rotor_ring_3(rotor_ring_3_temp), 
        .rotor_ring_2(rotor_ring_2_temp), 
        .rotor_ring_1(rotor_ring_1_temp),

        .rotor_start_3(rotor_start_3_temp), 
        .rotor_start_2(rotor_start_2_temp), 
        .rotor_start_1(rotor_start_1_temp),

        .rotor_num_3(rotor_num_3_temp), 
        .rotor_num_2(rotor_num_2_temp), 
        .rotor_num_1(rotor_num_1_temp),

        // .rotor_3_ring_increment(rotor_3_ring_increment),
        .rotor_2_ring_increment(rotor_2_ring_increment),
        .rotor_1_ring_increment(rotor_1_ring_increment),

        .rotor_3_increment(rotor_3_increment),
        .rotor_2_increment(rotor_2_increment),
        .rotor_1_increment(rotor_1_increment),

        .rotor_3_num_increment(rotor_3_num_increment),
        .rotor_2_num_increment(rotor_2_num_increment),
        .rotor_1_num_increment(rotor_1_num_increment)

    ); 

    always @(posedge i_clock) begin
        rotor_start_3 <= rotor_start_3_temp;
        rotor_start_2 <= rotor_start_2_temp;
        rotor_start_1 <= rotor_start_1_temp;

        rotor3_ring <= rotor_ring_3_temp;
        rotor2_ring <= rotor_ring_2_temp;
        rotor1_ring <= rotor_ring_1_temp;

        rotor3_num <= rotor_num_3_temp;
        rotor2_num <= rotor_num_2_temp;
        rotor1_num <= rotor_num_1_temp;

        update_settings_out <= update_settings;

        rotor3_out <= rotor3;
        rotor2_out <= rotor2;
        rotor1_out <= rotor1;

        // rotor3_ring <= ring_position_3;
        // rotor2_ring <= ring_position_2;
        // rotor1_ring <= ring_position_1;

        // rotor3_num <= rotor_type_3;
        // rotor2_num <= rotor_type_2;
        // rotor1_num <= rotor_type_1;
    end
	
    encodeASCII encode(.ascii(i_inputData), .code(inputCode), .valid(valid)); // output o_valid
		
	rotor rotorcontrol(
        .clock(i_clock),
        .reset(reset),
        .rotate(rotate),
        .update_settings(update_settings),

        .rotor_type_1(rotor3_num),                    // rotor num
        .rotor_type_2(rotor2_num),
        .rotor_type_3(rotor1_num),

        .rotor_start_1(rotor_start_1),
        .rotor_start_2(rotor_start_2),
        .rotor_start_3(rotor_start_3),
        
        // .ring_position_1(ring_position_1),
        // .ring_position_2(ring_position_2),
        // .ring_position_3(ring_position_3),

        // .rotor_ring_1(rotor_ring_1),
        // .rotor_ring_2(rotor_ring_2),
        // .rotor_ring_3(rotor_ring_3),

        // .rotor_num_1(rotor_num_1),
        // .rotor_num_2(rotor_num_2),
        // .rotor_num_3(rotor_num_3),

        // .rotor_3_num_increment(rotor_3_num_increment), // rotor num
        // .rotor_2_num_increment(rotor_2_num_increment),
        // .rotor_1_num_increment(rotor_1_num_increment),

        .rotor_3_increment(rotor_3_increment),
        .rotor_2_increment(rotor_2_increment),
        .rotor_1_increment(rotor_1_increment),
        
        // .rotor_3_ring_increment(rotor_3_ring_increment),
        // .rotor_2_ring_increment(rotor_2_ring_increment),
        // .rotor_1_ring_increment(rotor_1_ring_increment)
        
        .rotor1(rotor1),
        .rotor2(rotor2),
        .rotor3(rotor3)
    );
           
           
	plugboardEncode plugboard(.code(inputCode),.val(value0));

	encode #(.REVERSE(0)) rot3Encode(.inputValue(inputCode),.rotor(rotor3),.outputValue(value1),.rotor_type(rotor3_num),.ring_position(rotor3_ring));
	encode #(.REVERSE(0)) rot2Encode(.inputValue(value1),   .rotor(rotor2),.outputValue(value2),.rotor_type(rotor2_num),.ring_position(rotor2_ring));
	encode #(.REVERSE(0)) rot1Encode(.inputValue(value2),   .rotor(rotor1),.outputValue(value3),.rotor_type(rotor1_num),.ring_position(rotor1_ring));
	
    reflectorEncode reflector(.code(value3),.val(value4),.reflector_type(reflector_type));
	
    encode #(.REVERSE(1)) rot1EncodeRev(.inputValue(value4),.rotor(rotor1),.outputValue(value5),.rotor_type(rotor1_num),.ring_position(rotor1_ring));
	encode #(.REVERSE(1)) rot2EncodeRev(.inputValue(value5),.rotor(rotor2),.outputValue(value6),.rotor_type(rotor2_num),.ring_position(rotor2_ring));
	encode #(.REVERSE(1)) rot3EncodeRev(.inputValue(value6),.rotor(rotor3),.outputValue(value7),.rotor_type(rotor3_num),.ring_position(rotor3_ring));

	decodeASCII decode(.code(value7), .ascii(final_ascii));

    always @(posedge i_clock) begin
        o_valid <= valid;
        o_outputData <= final_ascii;
    end
	
endmodule
