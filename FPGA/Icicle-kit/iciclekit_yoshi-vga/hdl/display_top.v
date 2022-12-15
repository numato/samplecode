module display_top
	(
		input wire clk_in,  // clock signal, reset signal from switch
        input hard_reset_n,       // hard reset select pin
//		input wire data,             // input data from nes controller to FPGA
//		output wire latch, nes_clk,  // outputs from FPGA to nes controller
        input wire KEY_START,
		input wire KEY_UP,
		input wire KEY_LEFT,
		input wire KEY_RIGHT,

		output wire hsync, vsync,    // outputs VGA signals to VGA port
		//output wire [11:0] rgb      // output rgb signals to VGA DAC
        output [2:0] red, 
        output [2:0] green, 
        output [1:0] blue
        
	);

	
	// *** routing signals and registers ***
    wire clk_buf;
    wire clkin;
    //
    RCLKINT clkr0(
    .A(clk_in),
    .Y(clkin)
    );
    
    wire clk, clk1, PLL_LOCK_0;
    PF_CCC_C0 PF_CCC_C0_0(
    //// Inputs
    .REF_CLK_0(clkin),
    //// Outputs
    .OUT0_FABCLK_0(clk),
    .OUT1_FABCLK_0(clk1),
    .PLL_LOCK_0(PLL_LOCK_0)
    );
    
    //always @ (posedge clock)
    //begin
      //clk = ~clk;
    //end
	
    // VGA signals
    wire [11:0] rgb;
    assign red[2:0] = rgb[11:9];
    assign green[2:0] = rgb[7:5];
    assign blue[1:0] = rgb[3:2]; 
    wire hard_reset = ~hard_reset_n;
    wire up, left, right, start;                                  // route nes controller outputs to sprite circuit
	localparam idle = 3'b001;                                     // symbolic state constant representing game state idle
	localparam gameover = 3'b100;                                 // symbolic state constant representing game state gameover
	wire [1:0] num_hearts;                                        // route signal conveying number of hearts yoshi has, and to display
	wire [2:0] game_state;                                        // route current game state from game_state_machine
	wire game_en;                                                 // route signal conveying is game is enabled (playing mode)
	wire game_reset;                                              // route signal to trigger reset in other modules from inside game_state_machine
    wire reset;                                                   // reset signal
	assign reset = hard_reset || game_reset;                      // assert reset when either hard_reset or game_reset are asserted
	wire [9:0] x, y;                                              // location of VGA pixel
	wire video_on, pixel_tick;                                    // route VGA signals
	reg [11:0] rgb_reg, rgb_next;                                 // RGB data register to route out to VGA DAC
	wire [9:0] y_x, y_y;                                          // vector to route yoshi's x/y location
	wire [9:0] g_c_x, g_c_y;                                      // vector to route ghost_crazy's x/y location
	wire [9:0] g_t_x, g_t_y;                                      // vector to route ghost_top's x/y location
	wire [9:0] g_b_x, g_b_y;                                      // vector to route ghost_bottom's x/y location
	wire grounded, jumping_up, direction;                         // signals to route status signals for yoshi
	wire collision;                                               // signal asserted from enemy_collision
	wire [13:0] score;                                            // route score value from eggs to score_display
	wire new_score;                                               // signal asserted for new score, used to start binary to bcd conversion
	wire [11:0] yoshi_rgb, platforms_rgb, ghost_crazy_rgb,        // RGB regs for various sprite units, to route RGB data to VGA circuit
				 ghost_bottom_rgb, ghost_top_rgb, bg_rgb,
				 eggs_rgb, hearts_rgb, game_logo_rgb,
				 gameover_rgb;
	wire yoshi_on, platforms_on, ghost_crazy_on, ghost_bottom_on, // on signals for various sprite units
	     ghost_top_on, eggs_on, score_on, hearts_on, game_logo_on,
	     gameover_on;
		 
	wire [25:0] speed_offset; // amount of speed increase is calculated from current game score and routed to ghosts
	assign speed_offset = (({14'b0, score[13:2]} << 12) < 2750000) ? ({14'b0, score[13:2]} << 12) : 2750000;
	
	// nes controller signals are only routed to yoshi_sprite
    	// when in playing state and game_en is asserted
	wire yoshi_up, yoshi_left, yoshi_right;
	assign yoshi_up = up & game_en;
	assign yoshi_left = left & game_en;
	assign yoshi_right = right & game_en;
	
	// game_over signal routed to yoshi to signal when to display yoshi ghost
	wire game_over_yoshi;
	assign game_over_yoshi = (game_state == gameover) ? 1 : 0;
	
	wire [7:0] ssegp;
    wire [3:0] an;
    
    assign start = ~KEY_START;
    assign left = ~KEY_LEFT;
    assign right = ~KEY_RIGHT;
    assign up = ~KEY_UP;
	
	// *** instantiate sub modules ***
	
	// instantiate vga_sync circuit
	vga_sync vsync_unit (.clk(clk1), .reset(hard_reset), .hsync(hsync), .vsync(vsync),
                             .video_on(video_on), .p_tick(pixel_tick), .x(x), .y(y));

	// instantiate nes controller
//	nes_controller controller (.clk(clk), .reset(hard_reset), .data(data), .latch(latch), .nes_clk(nes_clk),
//				   .A(up), .B(), .select(), .start(start), .up(), .down(), .left(left), .right(right));
	
	// instantiate yoshi sprite circuit
	yoshi_sprite yoshi_unit (.clk(clk), .reset(reset), .btnU(yoshi_up),
				 .btnL(yoshi_left), .btnR(yoshi_right), .video_on(video_on), .x(x), .y(y),
				 .grounded(grounded), .game_over_yoshi(game_over_yoshi), .collision(collision),
				 .rgb_out(yoshi_rgb),.yoshi_on(yoshi_on), .y_x(y_x), .y_y(y_y), 
				 .jumping_up(jumping_up), .direction(direction));
	
	// instantiate crazy ghost circuit						 
	ghost_crazy ghost_crazy_unit (.clk(clk), .reset(reset), .y_x(y_x), .y_y(y_y),
				      .x(x), .y(y), .speed_offset(speed_offset), .g_c_x(g_c_x), .g_c_y(g_c_y),
				      .ghost_crazy_on(ghost_crazy_on), .rgb_out(ghost_crazy_rgb));
	
	// instantiate top ghost circuit
	ghost_top ghost_top_unit (.clk(clk), .reset(reset), .y_x(y_x), .y_y(y_y),
				  .x(x), .y(y), .speed_offset(speed_offset), .g_t_x(g_t_x), .g_t_y(g_t_y),
				  .ghost_top_on(ghost_top_on), .rgb_out(ghost_top_rgb));
	
	// instantiate bottom ghost circuit
	ghost_bottom ghost_bottom_unit (.clk(clk), .reset(reset), .y_x(y_x), .y_y(y_y),
					.x(x), .y(y), .speed_offset(speed_offset), .g_b_x(g_b_x), .g_b_y(g_b_y),
					.ghost_bottom_on(ghost_bottom_on), .rgb_out(ghost_bottom_rgb));
    
	// instantiate platform sprites circuit
    	platforms platforms_unit (.clk(clk), .video_on(video_on), .x(x), .y(y), .rgb_out(platforms_rgb),
	                      .platforms_on(platforms_on));
	
	// instantate circuit that determines if yoshi sprite is on the ground or a platform
	grounded grounded_unit (.clk(clk), .reset(reset), .y_x(y_x), .y_y(y_y), .jumping_up(jumping_up),
                        	.direction(direction), .grounded(grounded));
	
	// instantiate background rom circuit
	background_ghost_rom background_unit (.clk(clk), .row(y[7:0]), .col(x[7:0]), .color_data(bg_rgb));
	
	// instantiate enemy collision detection circuit
	enemy_collision enemy_collision_unit (.direction(direction), .y_x(y_x), .y_y(y_y), .g_c_x(g_c_x),
                                              .g_c_y(g_c_y), .g_t_x(g_t_x), .g_t_y(g_t_y), .g_b_x(g_b_x),
					      .g_b_y(g_b_y), .collision(collision)); 
	
	// instantiate eggs circuit
	eggs eggs_unit(.clk(clk), .reset(reset), .y_x(y_x), .y_y(y_y), .direction(direction),
		       .x(x), .y(y), .eggs_on(eggs_on), .rgb_out(eggs_rgb), .score(score), .new_score(new_score));
    
    // instantiate score display circuit
	score_display score_display_unit (.clk(clk), .reset(reset), .new_score(new_score), .score(score),
					  .x(x), .y(y), .sseg(ssegp), .an(an), .score_on(score_on));	
	
	// instantiate hearts display circuit
	hearts_display hearts_display_unit (.clk(clk), .x(x), .y(y), .num_hearts(num_hearts),
					    .color_data(hearts_rgb), .hearts_on(hearts_on));
	
	// instantate game FSM circuit
	game_state_machine game_FSM (.clk(clk), .hard_reset(hard_reset), .start(start), .collision(collision),
				     .num_hearts(num_hearts), .game_state(game_state), .game_en(game_en),
				     .game_reset(game_reset));
	
	// instantiate start screen logo display circuit
	game_logo_display game_logo_display_unit (.clk(clk), .x(x), .y(y), .rgb_out(game_logo_rgb),
	                                          .game_logo_on(game_logo_on));
	
	// instantiate gameover display circuit
	gameover_display gameover_display_unit (.clk(clk), .x(x), .y(y), .rgb_out(gameover_rgb),
	                                        .gameover_on(gameover_on));

	//  *** RGB multiplexing circuit ***
	// routes correct RGB data depending on video_on, < >_on signals, and game_state signal
    	always @*
		begin
        	if (~video_on)
			rgb_next = 12'b0; // black
        	else if(score_on)
			rgb_next = 12'hFFF;
				
		else if(hearts_on)
			rgb_next = hearts_rgb;
			
		else if(game_logo_on && game_state == idle)
			rgb_next = game_logo_rgb;
				
		else if(gameover_on && game_state == gameover)
			rgb_next = gameover_rgb;
				
            	else if(ghost_crazy_on && game_state != idle)	
			rgb_next = ghost_crazy_rgb;
				
		else if(ghost_bottom_on && game_state != idle)
			rgb_next = ghost_bottom_rgb;
				
		else if(ghost_top_on && game_state != idle)
			rgb_next = ghost_top_rgb;
				
		else if (yoshi_on && game_state != idle)
			rgb_next = yoshi_rgb;       
				
		else if (eggs_on && game_en)
			rgb_next = eggs_rgb;
		
		else if(platforms_on)
                	rgb_next = platforms_rgb;
				
            	else
                	rgb_next = bg_rgb;			
		end
	
	// rgb buffer register
	always @(posedge clk)
		if (pixel_tick)
			rgb_reg <= rgb_next;		
			
	// output rgb data to VGA DAC
	assign rgb = rgb_reg;

endmodule
