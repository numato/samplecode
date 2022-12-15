module platforms
    (
        input wire clk,                    // input clock signal for synchronous ROMs
        input wire video_on,               // input from vga_sync signaling when video signal is on
        input wire [9:0] x, y,             // current pixel coordinates from vga_sync circuit
        output reg [11:0] rgb_out,         // output rgb signal for current pixel
        output reg platforms_on            // output signal asserted when vga x/y pixel is within platform location in display area
    );
	
	// registers to index roms
	reg [6:0] row;
	reg [3:0] col;
	// output vectors from walls and blocks roms
	wire [11:0] walls_color_data, blocks_color_data;
	
	walls_rom walls_unit (.clk(clk), .row(row[4:0]), .col(col), .color_data(walls_color_data));
	
    	blocks_rom blocks_unit (.clk(clk), .row(row), .col(col), .color_data(blocks_color_data));
	
    	localparam offset = 16; // determines block tiles used
	
	// always block to set rom index regs row/col, rgb_out, and platforms_on, depending on input x/y
	always @*
		begin
		// defaults
		platforms_on = 0;
		row = 0;
		col = 0;
		rgb_out = 12'h000;
		
		if(video_on)
			begin
			// 'A'
			if((y > 131 && y < 148 && x >= 16 && x < 160))  // if x/y within platform 'A'
				begin
				row = y - 132 + offset;                     // set row
				col = x + 16;                               // set col
				if(blocks_color_data != 12'b011011011110)   // if color_data at row/col isn't sprite background color
					begin
					platforms_on = 1;                       // assert platforms_on
					rgb_out = blocks_color_data;            // route color_data to rgb_out output
					end
				end 
			
			// 'B'                                          // ...
			if((y > 131 && y < 148 && x >= 480 && x < 624))
				begin
				row = y - 132 + offset;
				col = x;
				if(blocks_color_data != 12'b011011011110)
					begin
					platforms_on = 1;
					rgb_out = blocks_color_data;
					end
				end 
			
			// 'C'
			if((y > 214 && y < 231 && x > 80 && x < 561))
				begin
				row = y - 215 + offset;
				col = x - 81;
				if(blocks_color_data != 12'b011011011110)
					begin
					platforms_on = 1;
					rgb_out = blocks_color_data;
					end
				end 
				
			// 'D'
			if((y > 297 && y < 314 && x >= 16 && x < 256))
				begin
				row = y - 298 + offset;
				col = x;
				if(blocks_color_data != 12'b011011011110)
					begin
					platforms_on = 1;
					rgb_out = blocks_color_data;
					end
				end 
				
			// 'E'
			if((y > 297 && y < 314 && x >= 384 && x < 624))
				begin
				row = y - 298 + offset;
				col = x;
				if(blocks_color_data != 12'b011011011110)
					begin
					platforms_on = 1;
					rgb_out = blocks_color_data;
					end
				end 
				
			// 'F'
			if((y > 380 && y < 397 && x > 112 && x < 529))
				begin
				row = y - 381 + offset;
				col = x - 113;
				if(blocks_color_data != 12'b011011011110)
					begin
					platforms_on = 1;
					rgb_out = blocks_color_data;
					end
				end

			// 'G' bottom row 
			if(y > 463)
				begin
				row = y - 464;
				col = x;
				if(walls_color_data != 12'b011011011110)
					begin
					platforms_on = 1;
					rgb_out = walls_color_data;
					end
				end
				
			// top row
			if(y >= 0 && y < 16)
				begin
				row = y;
				col = x;
				if(walls_color_data != 12'b011011011110)
					begin
					platforms_on = 1;
					rgb_out = walls_color_data;
					end
				end
			
			// left column
			if(x < 16)
				begin
				row = y;
				col = x;
				if(walls_color_data != 12'b011011011110)
					begin
					platforms_on = 1;
					rgb_out = walls_color_data;
					end
				end

			// right column
			if(x > 623)
				begin
				row = y;
				col = x;
				if(walls_color_data != 12'b011011011110)
					begin
					platforms_on = 1;
					rgb_out = walls_color_data;
					end
				end	
			end	
		end
endmodule 
