module rotor (
	input clock,
	input reset,
	input rotate,
    input update_settings,

	input [2:0] rotor_type_3,
	input [2:0] rotor_type_2,
	input [2:0] rotor_type_1,

	input [4:0] rotor_start_3,
    input [4:0] rotor_start_2,
	input [4:0] rotor_start_1,

	// input [4:0] ring_position_3,
	// input [4:0] ring_position_2,
	// input [4:0] ring_position_1,

	input rotor_3_increment,
	input rotor_2_increment,
	input rotor_1_increment,

	// input rotor_3_ring_increment,
	// input rotor_2_ring_increment,
	// input rotor_1_ring_increment,

	// input rotor_3_num_increment,
	// input rotor_2_num_increment,
	// input rotor_1_num_increment,

	output reg [4:0] rotor3,
	output reg [4:0] rotor2,
	output reg [4:0] rotor1
);

	wire knock1;
	wire knock2;

	reg prev_rotate = 1'b0;
	reg prev_knock1 = 1'b0;
	reg prev_knock2 = 1'b0;
	
	checkKnockpoints checker3(.position(rotor3), .knockpoint(knock1), .rotor_type(rotor_type_3));
	checkKnockpoints checker2(.position(rotor2), .knockpoint(knock2), .rotor_type(rotor_type_2));

	
	always @(posedge clock)
	begin
		if (reset) 
		begin
			rotor1 <= rotor_start_1;
			rotor2 <= rotor_start_2;
			rotor3 <= rotor_start_3;
			prev_rotate <= 1'b0;
			prev_knock1 <= 1'b0;
			prev_knock2 <= 1'b0;
		end
		else if (rotor_3_increment) begin
            if (rotor_start_3 == 5'd25)         rotor3 <= 5'd1;
            // else if (rotor_start_3 == 5'd26)    rotor3 <= 5'd2;
            else                                rotor3 <= rotor_start_3 + 5'd2;
			if ((prev_knock1==1'b0) && (knock1==1'b1)) rotor2 <= (rotor2 == 5'd25) ? 1'b0 : rotor2 + 5'b1;
			if ((prev_knock2==1'b0) && (knock2==1'b1)) rotor1 <= (rotor1 == 5'd25) ? 1'b0 : rotor1 + 5'b1;			
			prev_rotate <= rotate;
			prev_knock1 <= knock1;
			prev_knock2 <= knock2;
		end
    else if (rotor_2_increment) begin
			if ((prev_rotate==1'b0) && (rotate==1'b1)) rotor3 <= (rotor3 == 5'd25) ? 1'b0 : rotor3 + 5'b1;
            rotor2 <= (rotor_start_2 == 5'd25) ? 1'b0 : rotor_start_2 + 5'b1;
			if ((prev_knock2==1'b0) && (knock2==1'b1)) rotor1 <= (rotor1 == 5'd25) ? 1'b0 : rotor1 + 5'b1;			
			prev_rotate <= rotate;
			prev_knock1 <= knock1;
			prev_knock2 <= knock2;
		end
        else if (rotor_1_increment) begin
			if ((prev_rotate==1'b0) && (rotate==1'b1)) rotor3 <= (rotor3 == 5'd25) ? 1'b0 : rotor3 + 5'b1;
			if ((prev_knock1==1'b0) && (knock1==1'b1)) rotor2 <= (rotor2 == 5'd25) ? 1'b0 : rotor2 + 5'b1;
            rotor1 <= (rotor_start_1 == 5'd25) ? 1'b0 : rotor_start_1 + 5'b1;	
			prev_rotate <= rotate;
			prev_knock1 <= knock1;
			prev_knock2 <= knock2;
		end
		else
		begin
			if ((prev_rotate==1'b0) && (rotate==1'b1)) rotor3 <= (rotor3 == 5'd26) ? 1'b1 : rotor3 + 5'b1;
			if ((prev_knock1==1'b0) && (knock1==1'b1)) rotor2 <= (rotor2 == 5'd25) ? 1'b0 : rotor2 + 5'b1;
			if ((prev_knock2==1'b0) && (knock2==1'b1)) rotor1 <= (rotor1 == 5'd25) ? 1'b0 : rotor1 + 5'b1;			
			prev_rotate <= rotate;
			prev_knock1 <= knock1;
			prev_knock2 <= knock2;
		end
	end
endmodule
