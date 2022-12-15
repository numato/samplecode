module score_display
	(	
	    input wire clk, reset,   // clock, reset signal inputs for synchronous roms and registers
	    input wire new_score,    // input wire asserted when eggs module increments score
	    input wire [13:0] score, // current score routed in from eggs module
	    input wire [9:0] x, y,   // vga x/y pixel location
	    output reg [7:0] sseg,   // output seven-segment signals
	    output reg [3:0] an,     // output seven-segment digit enable signals
	    output reg score_on      // output asserted when x/y are within score location in display
        );	
	
	// route bcd values out from binary to bcd conversion circuit
	wire [3:0] bcd3, bcd2, bcd1, bcd0;
	
	// instantiate binary to bcd conversion circuit
	binary2bcd bcd_unit (.clk(clk), .reset(reset), .start(new_score),
                         .in(score), .bcd3(bcd3), .bcd2(bcd2), .bcd1(bcd1), .bcd0(bcd0));
	
	// *** seven-segment score display ***
	
	// seven-segment output decoding circuit
    	// register to route either units or tenths value to decoding circuit
        reg [3:0] decode_reg, decode_next;
        
        // infer decode value register
        always @(posedge clk, posedge reset)
	    if(reset)
		decode_reg <= 0;
	    else 
		decode_reg <= decode_next;
	
	// decode value_reg to sseg outputs
	always @*
		case(decode_reg)
			0: sseg = 8'b10000001;
			1: sseg = 8'b11001111;
			2: sseg = 8'b10010010;
			3: sseg = 8'b10000110;
			4: sseg = 8'b11001100;
			5: sseg = 8'b10100100;
			6: sseg = 8'b10100000;
			7: sseg = 8'b10001111;
			8: sseg = 8'b10000000;
			9: sseg = 8'b10000100;
			default: sseg = 8'b11111111;
		endcase
	
	// seven-segment multiplexing circuit @ 381 Hz
	reg [16:0] m_count_reg;
	
	// infer multiplexing counter register and next-state logic
	always @(posedge clk, posedge reset)
		if(reset)
			m_count_reg <= 0;
		else
			m_count_reg <= m_count_reg + 1;
	
	// multiplex two digits using MSB of m_count_reg 
	always @*
		case (m_count_reg[16:15])
			0: begin
			   an = 4'b1110;
               		   decode_next = bcd0;
                           end
			1: begin
               		   an = 4'b1101;
                           decode_next = bcd1;
                           end    
                    
            		2: begin
                           an = 4'b1011;
                           decode_next = bcd2;
                           end
                    
            		3: begin
                           an = 4'b0111;
                           decode_next = bcd3;
                           end 
		endcase
	
	// *** on screen score display ***
	
	// row and column regs to index numbers_rom
	reg [7:0] row;
	reg [3:0] col;
	
	// output from numbers_rom
	wire color_data;
	
	// infer number bitmap rom
	numbers_rom numbers_rom_unit(.clk(clk), .row(row), .col(col), .color_data(color_data));
	
	// display 4 digits on screen
	always @* 
		begin
		// defaults
		score_on = 0;
		row = 0;
		col = 0;
		
		// if vga pixel within bcd3 location on screen
		if(x >= 336 && x < 352 && y >= 16 && y < 32)
			begin
			col = x - 336;
			row = y - 16 + (bcd3 * 16); // offset row index by scaled bcd3 value
			if(color_data == 1'b1)      // if bit is 1, assert score_on output
				score_on = 1;
			end
		
		// if vga pixel within bcd2 location on screen
		if(x >= 352 && x < 368 && y >= 16 && y < 32)
			begin
			col = x - 336;
			row = y - 16 + (bcd2 * 16); // offset row index by scaled bcd2 value
			if(color_data == 1'b1)      // if bit is 1, assert score_on output
				score_on = 1;
			end
		
		// if vga pixel within bcd1 location on screen
		if(x >= 368 && x < 384 && y >= 16 && y < 32)
			begin
			col = x - 336;
			row = y - 16 + (bcd1 * 16); // offset row index by scaled bcd1 value
			if(color_data == 1'b1)      // if bit is 1, assert score_on output
				score_on = 1;
			end
		
		// if vga pixel within bcd0 location on screen
		if(x >= 384 && x < 400 && y >= 16 && y < 32)
			begin
			col = x - 336;
			row = y - 16 + (bcd0 * 16); // offset row index by scaled bcd0 value
			if(color_data == 1'b1)      // if bit is 1, assert score_on output
				score_on = 1;
			end
		end
		
endmodule
