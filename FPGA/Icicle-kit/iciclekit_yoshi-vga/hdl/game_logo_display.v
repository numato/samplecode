module game_logo_display
    (
        input wire clk,             // input clock signal for synchronous rom
        input wire [9:0] x, y,      // current pixel coordinates from vga_sync circuit
        output wire [11:0] rgb_out, // output rgb signal for current pixel
        output wire game_logo_on    // output signal asserted when x/y are within game_logo on display
    );
	
	// vectors to index game_logo_rom
	wire [5:0] row;
	wire [8:0] col;
	assign row = y - 64;
	assign col = x - 136;
	
	// assert game_logo_on when vga x/y is located within logo on screen and color_data doesn't equal background color_data
	assign game_logo_on = (x >= 136 && x < 504 && y >= 64 && y < 99 && rgb_out != 12'b011011011110) ? 1 : 0;
	
	// instantiate game_logo_rom
	game_logo_rom game_logo_rom_unit (.clk(clk), .row(row), .col(col), .color_data(rgb_out));

endmodule