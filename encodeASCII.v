module encodeASCII(ascii, code, valid);
	input [7:0] ascii; 
	output [4:0] code;
	output valid;

    wire [7:0] temp_code;

	assign valid = ((ascii < 8'h41 || ascii > 8'h5A) && (ascii < 8'h61 || ascii > 8'h7A)) ? 1'b0 : 1'b1;

    assign temp_code = (ascii > 8'h5A) ? ascii - 8'h61 : ascii - 8'h41;
    assign code = temp_code[4:0];

endmodule
