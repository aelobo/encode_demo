`default_nettype none

/**
 * ASCII_to_Seven_Segment.v
 *
 * Enigma Machine
 *
 * ECE 18-500
 * Carnegie Mellon University
 *
 * 
 **/

/*----------------------------------------------------------------------------*
 *  ASCII to seven-segment display                                            *
 *----------------------------------------------------------------------------*/

module ASCII_to_Seven_Segment(
    input       [7:0]   ascii,  
    output reg  [6:0]   seven_seg_display
);

always @* begin
    case (ascii)
        8'h41: seven_seg_display = ~7'b111_0111;       // A
        8'h42: seven_seg_display = ~7'b111_1100;       // B wrong
        8'h43: seven_seg_display = ~7'b011_1001;       // C wrong
        8'h44: seven_seg_display = ~7'b101_1110;       // d wrong   
        8'h45: seven_seg_display = ~7'b111_1001;       // E backwards
        8'h46: seven_seg_display = ~7'b111_0001;       // F backwards
        8'h47: seven_seg_display = ~7'b110_1111;       // g backwards
        8'h48: seven_seg_display = ~7'b111_0100;       // H wrong
        8'h49: seven_seg_display = ~7'b011_0000;       // I 
        8'h4a: seven_seg_display = ~7'b001_1110;       // J backwards
        8'h4b: seven_seg_display = ~7'b111_0101;       // K wrong
        8'h4c: seven_seg_display = ~7'b011_1000;       // L backwards
        8'h4d: seven_seg_display = ~7'b001_0101;       // M wrong (n)
        8'h4e: seven_seg_display = ~7'b101_0100;       // n wrong
        8'h4f: seven_seg_display = ~7'b011_1111;       // O wrong
        8'h50: seven_seg_display = ~7'b111_0011;       // p backwards 
        8'h51: seven_seg_display = ~7'b110_0111;       // q backwards
        8'h52: seven_seg_display = ~7'b011_0011;       // r wrong
        8'h53: seven_seg_display = ~7'b110_1101;       // S backwards 
        8'h54: seven_seg_display = ~7'b111_1000;       // t wrong
        8'h55: seven_seg_display = ~7'b011_1110;       // U 
        8'h56: seven_seg_display = ~7'b001_1100;       // v 
        8'h57: seven_seg_display = ~7'b010_1010;       // W 
        8'h58: seven_seg_display = ~7'b111_0110;       // X wrong
        8'h59: seven_seg_display = ~7'b110_1110;       // y wrong
        8'h5a: seven_seg_display = ~7'b101_1011;       // Z backwards
        default: seven_seg_display = ~7'b000_0000; 
    endcase
end

endmodule