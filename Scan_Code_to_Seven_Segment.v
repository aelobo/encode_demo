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
    output reg  [6:0]   out
);

    always_comb begin
        case (scan_code)
            8'h1C: out = ~7'b111_0111;       // A
            8'h32: out = ~7'b001_1111;       // B
            8'h21: out = ~7'b100_1110;       // C
            8'h23: out = ~7'b011_1101;       // d
            8'h24: out = ~7'b100_1111;       // E
            8'h2B: out = ~7'b100_0111;       // F
            8'h34: out = ~7'b111_1011;       // g
            8'h33: out = ~7'b011_0111;       // H
            8'h43: out = ~7'b011_0000;       // I
            8'h3B: out = ~7'b011_1000;       // J
            8'h42: out = ~7'b000_0111;       // K
            8'h4B: out = ~7'b000_1110;       // L
            8'h3A: out = ~7'b101_0100;       // M
            8'h31: out = ~7'b111_0110;       // n
            8'h44: out = ~7'b111_1110;       // O
            8'h4D: out = ~7'b110_0111;       // p
            8'h15: out = ~7'b111_0011;       // q
            8'h2D: out = ~7'b100_0110;       // r
            8'h1B: out = ~7'b101_1011;       // S
            8'h2C: out = ~7'b000_1111;       // t
            8'h3C: out = ~7'b011_1110;       // U
            8'h2A: out = ~7'b001_1100;       // v
            8'h1D: out = ~7'b010_1010;       // W
            8'h22: out = ~7'b011_0001;       // X
            8'h35: out = ~7'b011_1011;       // y
            8'h1A: out = ~7'b110_1101;       // Z
            default: out = ~7'b000_0000; 
        endcase
    end

endmodule