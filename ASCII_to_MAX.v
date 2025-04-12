`default_nettype none

/**
 * ASCII_to_MAX.v
 *
 * Enigma Machine
 *
 * ECE 18-500
 * Carnegie Mellon University
 *
 * 
 **/

/*----------------------------------------------------------------------------*
 *  ASCII to MAX                                                              *
 *----------------------------------------------------------------------------*/

module ASCII_to_MAX (
    input       [7:0]   ascii,  
    output reg  [7:0]   seven_seg_display
);

always @* begin
    case (ascii)
        8'h41: seven_seg_display = 8'b0111_0111; // A
        8'h42: seven_seg_display = 8'b0001_1111; // B
        8'h43: seven_seg_display = 8'b0100_1110; // C
        8'h44: seven_seg_display = 8'b0011_1101; // D
        8'h45: seven_seg_display = 8'b0100_1111; // E
        8'h46: seven_seg_display = 8'b0100_0111; // F
        8'h47: seven_seg_display = 8'b0111_1011; // G
        8'h48: seven_seg_display = 8'b0001_0111; // H
        8'h49: seven_seg_display = 8'b0000_0110; // I
        8'h4A: seven_seg_display = 8'b0011_1100; // J
        8'h4B: seven_seg_display = 8'b0101_0111; // K
        8'h4C: seven_seg_display = 8'b0000_1110; // L
        8'h4D: seven_seg_display = 8'b0101_0100; // M
        8'h4E: seven_seg_display = 8'b0001_0101; // N
        8'h4F: seven_seg_display = 8'b0111_1110; // O
        8'h50: seven_seg_display = 8'b0110_0111; // P
        8'h51: seven_seg_display = 8'b0111_0011; // Q
        8'h52: seven_seg_display = 8'b0110_0110; // R
        8'h53: seven_seg_display = 8'b0101_1011; // S
        8'h54: seven_seg_display = 8'b0000_1111; // T
        8'h55: seven_seg_display = 8'b0011_1110; // U
        8'h56: seven_seg_display = 8'b0001_1100; // V
        8'h57: seven_seg_display = 8'b0010_1010; // W
        8'h58: seven_seg_display = 8'b0011_0111; // X
        8'h59: seven_seg_display = 8'b0011_1011; // Y
        8'h5A: seven_seg_display = 8'b0110_1101; // Z
        default: seven_seg_display = 8'b0000_0000;
    endcase
end

endmodule