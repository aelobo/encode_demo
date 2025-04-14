`default_nettype none

/**
 * scan_to_ascii.sv
 *
 * Enigma Machine
 *
 * ECE 18-500
 * Carnegie Mellon University
 *
 * This is the ps2 scan code to seven segment display mapping
 **/

/*----------------------------------------------------------------------------*
 *  Scan code to seven-segment display                                        *
 *----------------------------------------------------------------------------*/

module Scan_Code_to_ASCII(
    input       [7:0]  scan_code,  
    output reg  [7:0]  ascii_plaintext
);

    always @* begin
        case (scan_code)
            8'h1C: ascii_plaintext = "A";       // A
            8'h32: ascii_plaintext = "B";       // B
            8'h21: ascii_plaintext = "C";       // C
            8'h23: ascii_plaintext = "D";       // d
            8'h24: ascii_plaintext = "E";       // E
            8'h2B: ascii_plaintext = "F";       // F
            8'h34: ascii_plaintext = "G";       // g
            8'h33: ascii_plaintext = "H";       // H
            8'h43: ascii_plaintext = "I";       // I
            8'h3B: ascii_plaintext = "J";       // J
            8'h42: ascii_plaintext = "K";       // K
            8'h4B: ascii_plaintext = "L";       // L
            8'h3A: ascii_plaintext = "M";       // M
            8'h31: ascii_plaintext = "N";       // n
            8'h44: ascii_plaintext = "O";       // O
            8'h4D: ascii_plaintext = "P";       // p
            8'h15: ascii_plaintext = "Q";       // q
            8'h2D: ascii_plaintext = "R";       // r
            8'h1B: ascii_plaintext = "S";       // S
            8'h2C: ascii_plaintext = "T";       // t
            8'h3C: ascii_plaintext = "U";       // U
            8'h2A: ascii_plaintext = "V";       // v
            8'h1D: ascii_plaintext = "W";       // W
            8'h22: ascii_plaintext = "X";       // X
            8'h35: ascii_plaintext = "Y";       // y
            8'h1A: ascii_plaintext = "Z";       // Z
            default: ascii_plaintext = 8'b000_0000;
        endcase
    end

endmodule