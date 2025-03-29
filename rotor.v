module rotor (
	input clock,
	output reg [4:0] rotor1,
	output reg [4:0] rotor2,
	output reg [4:0] rotor3,
	input reset,
	input rotate,
    input [2:0] rotor_type_2,
    input [2:0] rotor_type_3,
    input [4:0] rotor_start_1,
    input [4:0] rotor_start_2,
    input [4:0] rotor_start_3
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
		else
		begin
			if ((prev_rotate==1'b0) && (rotate==1'b1)) rotor3 <= (rotor3 == 5'd25) ? 1'b0 : rotor3 + 5'b1;
			if ((prev_knock1==1'b0) && (knock1==1'b1)) rotor2 <= (rotor2 == 5'd25) ? 1'b0 : rotor2 + 5'b1;
			if ((prev_knock2==1'b0) && (knock2==1'b1)) rotor1 <= (rotor1 == 5'd25) ? 1'b0 : rotor1 + 5'b1;			
			prev_rotate <= rotate;
			prev_knock1 <= knock1;
			prev_knock2 <= knock2;
		end
	end
endmodule
