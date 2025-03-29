
module PS2_Sim ();
    reg				CLOCK_50 = 0;
    reg		[3:0]	KEY;
    reg             reset;

    reg				PS2_CLK = 0;
    reg				PS2_DAT = 1;

    wire			PS2_CLK_OUT;
    wire			PS2_DAT_OUT;

    wire	[7:0]	ps2_key_data;
    wire			ps2_key_pressed;
    reg		[7:0]	last_data_received;

    wire            o_ready;
    wire    [7:0]   o_outputData;
    wire            o_valid;

    reg    [4:0]   encoded_data;

	always
		#(5) CLOCK_50 <= ~CLOCK_50;

    always
        #(100000) PS2_CLK <= ~PS2_CLK;


    always @(posedge CLOCK_50)
    begin
        if (KEY[0] == 1'b0)
            last_data_received <= 8'h00;
        else if (ps2_key_pressed == 1'b1)
            last_data_received <= ps2_key_data;
    end

    
    always @(posedge CLOCK_50)
    begin
        if (KEY[0] == 1'b0)
            encoded_data <= 8'h00;
        else if (o_valid == 1'b1)
            encoded_data <= o_outputData;
    end


    initial
    begin
        reset = 1'b1;
        #200000;
        reset = 1'b0;
        
        #200000;
        PS2_DAT = 1'b1; #200000; //idle
        PS2_DAT = 1'b1; #200000; //idle
        PS2_DAT = 1'b1; #200000; //idle

        PS2_DAT = 1'b0; #200000; //start

        PS2_DAT = 1'b0; #200000; //data
        PS2_DAT = 1'b0; #200000; //data
        PS2_DAT = 1'b1; #200000; //data
        PS2_DAT = 1'b1; #200000; //data
        PS2_DAT = 1'b1; #200000; //data
        PS2_DAT = 1'b0; #200000; //data
        PS2_DAT = 1'b0; #200000; //data
        PS2_DAT = 1'b0; #200000; //data

        PS2_DAT = 1'b1; #200000; //parity
        PS2_DAT = 1'b1; #200000; //stop
        #600000;

        #200000;
        PS2_DAT = 1'b1; #200000; //idle
        PS2_DAT = 1'b1; #200000; //idle
        PS2_DAT = 1'b1; #200000; //idle

        PS2_DAT = 1'b0; #200000; //start

        PS2_DAT = 1'b0; #200000; //data
        PS2_DAT = 1'b0; #200000; //data
        PS2_DAT = 1'b1; #200000; //data
        PS2_DAT = 1'b1; #200000; //data
        PS2_DAT = 1'b1; #200000; //data
        PS2_DAT = 1'b0; #200000; //data
        PS2_DAT = 1'b0; #200000; //data
        PS2_DAT = 1'b0; #200000; //data

        PS2_DAT = 1'b1; #200000; //parity
        PS2_DAT = 1'b1; #200000; //stop
        #600000;

        #200000;
        PS2_DAT = 1'b1; #200000; //idle
        PS2_DAT = 1'b1; #200000; //idle
        PS2_DAT = 1'b1; #200000; //idle

        PS2_DAT = 1'b0; #200000; //start

        PS2_DAT = 1'b0; #200000; //data
        PS2_DAT = 1'b0; #200000; //data
        PS2_DAT = 1'b1; #200000; //data
        PS2_DAT = 1'b1; #200000; //data
        PS2_DAT = 1'b1; #200000; //data
        PS2_DAT = 1'b0; #200000; //data
        PS2_DAT = 1'b0; #200000; //data
        PS2_DAT = 1'b0; #200000; //data

        PS2_DAT = 1'b1; #200000; //parity
        PS2_DAT = 1'b1; #200000; //stop
        #600000;

        #200000;
        PS2_DAT = 1'b1; #200000; //idle
        PS2_DAT = 1'b1; #200000; //idle
        PS2_DAT = 1'b1; #200000; //idle

        PS2_DAT = 1'b0; #200000; //start

        PS2_DAT = 1'b0; #200000; //data
        PS2_DAT = 1'b0; #200000; //data
        PS2_DAT = 1'b1; #200000; //data
        PS2_DAT = 1'b1; #200000; //data
        PS2_DAT = 1'b1; #200000; //data
        PS2_DAT = 1'b0; #200000; //data
        PS2_DAT = 1'b0; #200000; //data
        PS2_DAT = 1'b0; #200000; //data

        PS2_DAT = 1'b1; #200000; //parity
        PS2_DAT = 1'b1; #200000; //stop
        #600000;

		#200000;
		$finish;
	end


    PS2_Controller PS2 (
        // Inputs
        .CLOCK_50			(CLOCK_50),
        .reset				(reset),

        // Bidirectionals
        .PS2_CLK			(PS2_CLK),
        .PS2_DAT			(PS2_DAT),

        .PS2_CLK_OUT		(PS2_CLK_OUT),
        .PS2_DAT_OUT		(PS2_DAT_OUT),

        // Outputs
        .received_data		(ps2_key_data),
        .received_data_en	(ps2_key_pressed)
    );


    reg [6:0]  scan_code_7seg, encoded_7seg;
    reg [7:0]  i_inputData;

    // Convert plaintext scan code to letter
    Scan_Code_to_Seven_Segment Segment3 (
        .scan_code          (last_data_received),
        .out                (scan_code_7seg)
    );

    // Convert scan code to ASCII for encryption
    Scan_Code_to_ASCII ASCII (
        .scan_code          (last_data_received),
        .i_inputData        (i_inputData) // input as ASCII
    );

    State_Machine Enigma (
        .i_clock			(CLOCK_50),
        .reset				(reset),
        .i_ready            (ps2_key_pressed),
        .i_inputData        (i_inputData),

        .o_ready		    (o_ready),
        .o_outputData	    (o_outputData), // final output (in decimal)
        .o_valid            (o_valid)
    );


    Decimal_to_Seven_Segment Segment5 (
        .decimal            (encoded_data), // final output (in decimal)
        .out                (encoded_7seg) // HEX5
    );

    // // Plaintext hex scan code on seven segment 0
    // Hexadecimal_To_Seven_Segment Segment0 (
    //     .hex_number			(last_data_received[3:0]),
    //     .seven_seg_display	(HEX0)
    // );

    // // Plaintext hex scan code on seven segment 1
    // Hexadecimal_To_Seven_Segment Segment1 (
    //     .hex_number			(last_data_received[7:4]),
    //     .seven_seg_display	(HEX1)
    // );


endmodule
