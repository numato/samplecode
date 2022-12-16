module gameover_display
    (
        input wire clk,             // input clock signal for synchronous rom
        input wire [9:0] x, y,      // current pixel coordinates from vga_sync circuit
        output wire [11:0] rgb_out, // output rgb signal for current pixel
        output wire gameover_on     // output signal asserted when x/y are within gameover on display
    );
	
	// vectors to index game_logo_rom
	wire [3:0] row;
	wire [6:0] col;
	assign row = y - 72;
	assign col = x - 282;
	
	// assert game_logo_on when vga x/y is located within logo on screen and color_data doesn't equal background color_data
	assign gameover_on = (x >= 282 && x < 360 && y >= 72 && y < 86 && rgb_out != 12'b011011011110) ? 1 : 0;
	
	// instantiate game_logo_rom
	gameover_rom gameover_rom_unit (.clk(clk), .row(row), .col(col), .color_data(rgb_out));

endmodule