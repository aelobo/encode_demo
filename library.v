`default_nettype none

module Synchronizer #(parameter WIDTH=1) (
    input clock,
    input [WIDTH-1:0] async,

    output reg [WIDTH-1:0] sync
);

    reg [WIDTH-1:0] temp;

    always @(posedge clock) begin
        temp <= async;
        sync <= temp;
    end

endmodule