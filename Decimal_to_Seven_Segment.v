`default_nettype none

/**
 * Decimal_to_Seven_Segment.sv
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

module Decimal_to_Seven_Segment(
    input       [4:0] decimal,  
    output reg  [6:0] out
);

    always_comb begin
        case (decimal)
            5'd00: out = 7'b111_0111;       // A
            5'd01: out = 7'b001_1111;       // B
            5'd02: out = 7'b100_1110;       // C
            5'd03: out = 7'b011_1101;       // d
            5'd04: out = 7'b100_1111;       // E
            5'd05: out = 7'b100_0111;       // F (Removed duplicate)
            5'd06: out = 7'b111_1011;       // g
            5'd07: out = 7'b011_0111;       // H
            5'd08: out = 7'b011_0000;       // I
            5'd09: out = 7'b011_1000;       // J
            5'd10: out = 7'b000_0111;       // K
            5'd11: out = 7'b000_1110;       // L
            5'd12: out = 7'b101_0100;       // M
            5'd13: out = 7'b111_0110;       // n
            5'd14: out = 7'b111_1110;       // O
            5'd15: out = 7'b110_0111;       // p (Removed duplicate)
            5'd16: out = 7'b111_0011;       // q
            5'd17: out = 7'b100_0110;       // r
            5'd18: out = 7'b101_1011;       // S
            5'd19: out = 7'b000_1111;       // t
            5'd20: out = 7'b011_1110;       // U
            5'd21: out = 7'b001_1100;       // v
            5'd22: out = 7'b010_1010;       // W
            5'd23: out = 7'b011_0001;       // X
            5'd24: out = 7'b011_1011;       // y
            5'd25: out = 7'b110_1101;       // Z
            default: out = 7'b000_0000; //optional default case
        endcase
    end

endmodule