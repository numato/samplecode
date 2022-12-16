module hearts_display
	(	
	    input wire clk,                // clock signal for synchronous roms
	    input wire [9:0] x, y,         // vga x/y signals
	    input wire [1:0] num_hearts,   // input signal of number of hearts to display
	    output wire [11:0] color_data, // output signals for rgb color_data
	    output reg hearts_on           // output signal asserted when x/y is located within the hearts locations
        );	
	
	// row and column regs to index hearts_rom
	reg [4:0] row;
	reg [3:0] col;
	
	// infer hearts rom 
	hearts_rom hearts_rom_unit(.clk(clk), .row(row), .col(col), .color_data(color_data));
	
	// based on x/y set row/col indexes for hearts_rom, assert hearts_on when color_data from rom isn't sprite background color,
	always @* 
		begin
		// defaults
		row = 0;
		col = 0;
		hearts_on = 0;
		
		// if vga pixel within heart 1 (left)
		if(x >= 240 && x < 256 && y >= 16 && y < 32)
			begin
			col = x - 240;                     // set col index
			if(num_hearts > 0)                 // if num_hearts > 0 (1,2,3) left heart is on
				row = y - 16;                  // set full heart
			else 
				row = y;                       // else set empty heart
			if(color_data != 12'b011011011110) // if color_data != sprite background color
				hearts_on = 1;                 // assert hearts_on signal
			end
		
		// if vga pixel within heart 2 (center)
		if(x >= 256 && x < 272 && y >= 16 && y < 32)
			begin
			col = x - 256;                     // set col index
			if(num_hearts > 1)                 // if num_hearts > 1 (2,3) middle heart is on
				row = y - 16;                  // set full heart
			else 
				row = y;                       // else set empty heart
			if(color_data != 12'b011011011110) // if color_data != sprite background color
				hearts_on = 1;                 // assert hearts_on signal
			end
		
		
		// if vga pixel within beart 3 (right)
		if(x >= 272 && x < 288 && y >= 16 && y < 32)
			begin
			col = x - 272;                     // set col index
			if(num_hearts > 2)                 // if num_hearts > 2 (3)right heart is on
				row = y - 16;                  // set full heart
			else 
				row = y;                       // else set empty heart
			if(color_data != 12'b011011011110) // if color_data != sprite background color
				hearts_on = 1;                 // assert hearts_on signal
			end
		end
endmodule
