module rotorAssign #(parameter REVERSE = 0) (code, rotor_type, val);
    
    input       [4:0]   code; 
	output reg  [4:0]   val;
	input       [2:0]   rotor_type;

    reg [2079:0] rotor_data = {
        5'h4, 5'hA, 5'hC, 5'h5, 5'hB, 5'h6, 5'h3, 5'h10, 5'h15, 5'h19,
        5'hD, 5'h13, 5'hE, 5'h16, 5'h18, 5'h7, 5'h17, 5'h14, 5'h12, 5'hF,
        5'h0, 5'h8, 5'h1, 5'h11, 5'h2, 5'h9, 
        
        5'h0, 5'h9, 5'h3, 5'hA, 5'h12, 5'h8, 5'h11, 5'h14, 5'h17, 5'h1, 
        5'hB, 5'h7, 5'h16, 5'h13, 5'hC, 5'h2, 5'h10, 5'h6, 5'h19, 5'hD, 
        5'hF, 5'h18, 5'h5, 5'h15, 5'hE, 5'h4, 
        
        5'h1, 5'h3, 5'h5, 5'h7, 5'h9, 5'hB, 5'h2, 5'hF, 5'h11, 5'h13, 
        5'h17, 5'h15, 5'h19, 5'hD, 5'h18, 5'h4, 5'h8, 5'h16, 5'h6, 5'h0, 
        5'hA, 5'hC, 5'h14, 5'h12, 5'h10, 5'hE, 
        
        5'h4, 5'h12, 5'hE, 5'h15, 5'hF, 5'h19, 5'h9, 5'h0, 5'h18, 5'h10, 
        5'h14, 5'h8, 5'h11, 5'h7, 5'h17, 5'hB, 5'hD, 5'h5, 5'h13, 5'h6, 
        5'hA, 5'h3, 5'h2, 5'hC, 5'h16, 5'h1, 
        
        5'h15, 5'h19, 5'h1, 5'h11, 5'h6, 5'h8, 5'h13, 5'h18, 5'h14, 5'hF, 
        5'h12, 5'h3, 5'hD, 5'h7, 5'hB, 5'h17, 5'h0, 5'h16, 5'hC, 5'h9, 
        5'h10, 5'hE, 5'h5, 5'h4, 5'h2, 5'hA,

        5'h9, 5'hF, 5'h6, 5'h15, 5'hE, 5'h14, 5'hC, 5'h5, 5'h18, 5'h10,
        5'h1, 5'h4, 5'hD, 5'h7, 5'h19, 5'h11, 5'h3, 5'hA, 5'h0, 5'h12,
        5'h17, 5'hB, 5'h8, 5'h2, 5'h13, 5'h16, 
        
        5'hD, 5'h19, 5'h9, 5'h7, 5'h6, 5'h11, 5'h2, 5'h17, 5'hC, 5'h18, 
        5'h12, 5'h16, 5'h1, 5'hE, 5'h14, 5'h5, 5'h0, 5'h8, 5'h15, 5'hB, 
        5'hF, 5'h4, 5'hA, 5'h10, 5'h3, 5'h13, 
        
        5'h5, 5'hA, 5'h10, 5'h7, 5'h13, 5'hB, 5'h17, 5'hE, 5'h2, 5'h1, 
        5'h9, 5'h12, 5'hF, 5'h3, 5'h19, 5'h11, 5'h0, 5'hC, 5'h4, 5'h16, 
        5'hD, 5'h8, 5'h14, 5'h18, 5'h6, 5'h15, 

        5'h14, 5'h16, 5'h18, 5'h6, 5'h0, 5'h3, 5'h5, 5'hF, 5'h15, 5'h19, 
        5'h1, 5'h4, 5'h2, 5'hA, 5'hC, 5'h13, 5'h7, 5'h17, 5'h12, 5'hB, 
        5'h11, 5'h8, 5'hD, 5'h10, 5'hE, 5'h9, 
        
        5'h0, 5'h9, 5'hF, 5'h2, 5'h19, 5'h16, 5'h11, 5'hB, 5'h5, 5'h1, 
        5'h3, 5'hA, 5'hE, 5'h13, 5'h18, 5'h14, 5'h10, 5'h6, 5'h4, 5'hD, 
        5'h7, 5'h17, 5'hC, 5'h8, 5'h15, 5'h12,

        5'h13, 5'h0, 5'h6, 5'h1, 5'hF, 5'h2, 5'h12, 5'h3, 5'h10, 5'h4,
        5'h14, 5'h5, 5'h15, 5'hD, 5'h19, 5'h7, 5'h18, 5'h8, 5'h17, 5'h9,
        5'h16, 5'hB, 5'h11, 5'hA, 5'hE, 5'hC, 
        
        5'h7, 5'h19, 5'h16, 5'h15, 5'h0, 5'h11, 5'h13, 5'hD, 5'hB, 5'h6, 
        5'h14, 5'hF, 5'h17, 5'h10, 5'h2, 5'h4, 5'h9, 5'hC, 5'h1, 5'h12, 
        5'hA, 5'h3, 5'h18, 5'hE, 5'h8, 5'h5, 
        
        5'h10, 5'h2, 5'h18, 5'hB, 5'h17, 5'h16, 5'h4, 5'hD, 5'h5, 5'h13, 
        5'h19, 5'hE, 5'h12, 5'hC, 5'h15, 5'h9, 5'h14, 5'h3, 5'hA, 5'h6, 
        5'h8, 5'h0, 5'h11, 5'hF, 5'h7, 5'h1, 
        
        5'h12, 5'hA, 5'h17, 5'h10, 5'hB, 5'h7, 5'h2, 5'hD, 5'h16, 5'h0, 
        5'h11, 5'h15, 5'h6, 5'hC, 5'h4, 5'h1, 5'h9, 5'hF, 5'h13, 5'h18, 
        5'h5, 5'h3, 5'h19, 5'h14, 5'h8, 5'hE, 
        
        5'h10, 5'hC, 5'h6, 5'h18, 5'h15, 5'hF, 5'h4, 5'h3, 5'h11, 5'h2, 
        5'h16, 5'h13, 5'h8, 5'h0, 5'hD, 5'h14, 5'h17, 5'h5, 5'hA, 5'h19, 
        5'hE, 5'h12, 5'hB, 5'h7, 5'h9, 5'h1,

        5'h10, 5'h9, 5'h8, 5'hD, 5'h12, 5'h0, 5'h18, 5'h3, 5'h15, 5'hA,
        5'h1, 5'h5, 5'h11, 5'h14, 5'h7, 5'hC, 5'h2, 5'hF, 5'hB, 5'h4,
        5'h16, 5'h19, 5'h13, 5'h6, 5'h17, 5'hE };

    reg     [11:0]  val_index;
    reg     [4:0]   temp_val; // Temporary register to hold the 5 bits

    always @*
    begin
        if (REVERSE)
            val_index = 12'd1039 - (rotor_type * 12'd130) - (code * 12'd5);
        else
            val_index = 12'd2079 - (rotor_type * 12'd130) - (code * 12'd5);

        temp_val[4] = rotor_data[val_index];
        temp_val[3] = rotor_data[val_index - 1];
        temp_val[2] = rotor_data[val_index - 2];
        temp_val[1] = rotor_data[val_index - 3];
        temp_val[0] = rotor_data[val_index - 4];

        val = temp_val;
    end


endmodule