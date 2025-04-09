`default_nettype none

/**
 * Scan_Code_to_MAX.v
 *
 * Enigma Machine
 *
 * ECE 18-500
 * Carnegie Mellon University
 *
 * 
 **/

/*----------------------------------------------------------------------------*
 *  Scan code to seven-segment display                                        *
 *----------------------------------------------------------------------------*/

module Scan_Code_to_MAX (
    input       [7:0]   scan_code,  
    output reg  [6:0]   seven_seg_display
);

always @* begin
    case (scan_code)
        8'h1C: seven_seg_display = 8'b0111_0111;
        8'h32: seven_seg_display = 8'b0001_1111;
        8'h21: seven_seg_display = 8'b0100_1110;
        8'h23: seven_seg_display = 8'b0011_1101;
        8'h24: seven_seg_display = 8'b0100_1111;
        8'h2B: seven_seg_display = 8'b0100_0111;
        8'h34: seven_seg_display = 8'b0111_1011;
        8'h33: seven_seg_display = 8'b0001_0111;
        8'h43: seven_seg_display = 8'b0000_0110;
        8'h3B: seven_seg_display = 8'b0011_1100;
        8'h42: seven_seg_display = 8'b0101_0111;
        8'h4B: seven_seg_display = 8'b0000_1110;
        8'h3A: seven_seg_display = 8'b0101_0100;
        8'h31: seven_seg_display = 8'b0001_0101;
        8'h44: seven_seg_display = 8'b0111_1110;
        8'h4D: seven_seg_display = 8'b0110_0111;
        8'h15: seven_seg_display = 8'b0111_0011;
        8'h2D: seven_seg_display = 8'b0110_0110;
        8'h1B: seven_seg_display = 8'b0101_1111;
        8'h2C: seven_seg_display = 8'b0000_1111;
        8'h3C: seven_seg_display = 8'b0011_1110;
        8'h2A: seven_seg_display = 8'b0001_1100;
        8'h1D: seven_seg_display = 8'b0010_1010;
        8'h22: seven_seg_display = 8'b0011_0111;
        8'h35: seven_seg_display = 8'b0011_1111;
        8'h1A: seven_seg_display = 8'b0110_1101;
        default: seven_seg_display = 8'b0000_0000;
    endcase
end

endmodule