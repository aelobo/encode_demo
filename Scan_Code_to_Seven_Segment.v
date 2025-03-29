`default_nettype none

/**
 * Scan_Code_to_Seven_segment.v
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

module Scan_Code_to_Seven_Segment(
    input       [7:0]   scan_code,  
    output reg  [6:0]   seven_seg_display
);

always @* begin
    case (scan_code)
        8'h1C: seven_seg_display = ~7'b111_0111;       // A
        8'h32: seven_seg_display = ~7'b111_1100;       // B wrong
        8'h21: seven_seg_display = ~7'b011_1001;       // C wrong
        8'h23: seven_seg_display = ~7'b101_1110;       // d wrong   
        8'h24: seven_seg_display = ~7'b111_1001;       // E backwards
        8'h2B: seven_seg_display = ~7'b111_0001;       // F backwards
        8'h34: seven_seg_display = ~7'b110_1111;       // g backwards
        8'h33: seven_seg_display = ~7'b111_0100;       // H wrong
        8'h43: seven_seg_display = ~7'b011_0000;       // I 
        8'h3B: seven_seg_display = ~7'b001_1110;       // J backwards
        8'h42: seven_seg_display = ~7'b111_0101;       // K wrong
        8'h4B: seven_seg_display = ~7'b011_1000;       // L backwards
        8'h3A: seven_seg_display = ~7'b001_0101;       // M wrong (n)
        8'h31: seven_seg_display = ~7'b101_0100;       // n wrong
        8'h44: seven_seg_display = ~7'b011_1111;       // O wrong
        8'h4D: seven_seg_display = ~7'b111_0011;       // p backwards 
        8'h15: seven_seg_display = ~7'b110_0111;       // q backwards
        8'h2D: seven_seg_display = ~7'b011_0011;       // r wrong
        8'h1B: seven_seg_display = ~7'b110_1101;       // S backwards 
        8'h2C: seven_seg_display = ~7'b111_1000;       // t wrong
        8'h3C: seven_seg_display = ~7'b011_1110;       // U 
        8'h2A: seven_seg_display = ~7'b001_1100;       // v 
        8'h1D: seven_seg_display = ~7'b010_1010;       // W 
        8'h22: seven_seg_display = ~7'b111_0110;       // X wrong
        8'h35: seven_seg_display = ~7'b110_1110;       // y wrong
        8'h1A: seven_seg_display = ~7'b101_1011;       // Z backwards
        default: seven_seg_display = ~7'b000_0000; 
    endcase
end

endmodule