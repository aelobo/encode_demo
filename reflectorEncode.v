module reflectorEncode (code, val, reflector_type);
  input [4:0] code; 
  output reg [4:0] val;
  input reflector_type;

    reg [7:0] temp_val; // Temporary 8-bit register

    always @* begin
    if (reflector_type == 1'b0) begin
        // Reflector B
        case (code)
            0 : temp_val = ("Y" - 8'h41);
            1 : temp_val = ("R" - 8'h41);
            2 : temp_val = ("U" - 8'h41);
            3 : temp_val = ("H" - 8'h41);
            4 : temp_val = ("Q" - 8'h41);
            5 : temp_val = ("S" - 8'h41);
            6 : temp_val = ("L" - 8'h41);
            7 : temp_val = ("D" - 8'h41);
            8 : temp_val = ("P" - 8'h41);
            9 : temp_val = ("X" - 8'h41);
            10: temp_val = ("N" - 8'h41);
            11: temp_val = ("G" - 8'h41);
            12: temp_val = ("O" - 8'h41);
            13: temp_val = ("K" - 8'h41);
            14: temp_val = ("M" - 8'h41);
            15: temp_val = ("I" - 8'h41);
            16: temp_val = ("E" - 8'h41);
            17: temp_val = ("B" - 8'h41);
            18: temp_val = ("F" - 8'h41);
            19: temp_val = ("Z" - 8'h41);
            20: temp_val = ("C" - 8'h41);
            21: temp_val = ("W" - 8'h41);
            22: temp_val = ("V" - 8'h41);
            23: temp_val = ("J" - 8'h41);
            24: temp_val = ("A" - 8'h41);
            25: temp_val = ("T" - 8'h41);
            default: temp_val = 8'h00;
        endcase

        val = temp_val[4:0];
    end
    else begin
        // Reflector C
        case (code)
            0 : temp_val = ("F" - 8'h41);
            1 : temp_val = ("V" - 8'h41);
            2 : temp_val = ("P" - 8'h41);
            3 : temp_val = ("J" - 8'h41);
            4 : temp_val = ("I" - 8'h41);
            5 : temp_val = ("A" - 8'h41);
            6 : temp_val = ("O" - 8'h41);
            7 : temp_val = ("Y" - 8'h41);
            8 : temp_val = ("E" - 8'h41);
            9 : temp_val = ("D" - 8'h41);
            10: temp_val = ("R" - 8'h41);
            11: temp_val = ("Z" - 8'h41);
            12: temp_val = ("X" - 8'h41);
            13: temp_val = ("W" - 8'h41);
            14: temp_val = ("G" - 8'h41);
            15: temp_val = ("C" - 8'h41);
            16: temp_val = ("T" - 8'h41);
            17: temp_val = ("K" - 8'h41);
            18: temp_val = ("U" - 8'h41);
            19: temp_val = ("Q" - 8'h41);
            20: temp_val = ("S" - 8'h41);
            21: temp_val = ("B" - 8'h41);
            22: temp_val = ("N" - 8'h41);
            23: temp_val = ("M" - 8'h41);
            24: temp_val = ("H" - 8'h41);
            25: temp_val = ("L" - 8'h41);
            default: temp_val = 8'h00;
        endcase

        val = temp_val[4:0];
    end
    end 
    
endmodule