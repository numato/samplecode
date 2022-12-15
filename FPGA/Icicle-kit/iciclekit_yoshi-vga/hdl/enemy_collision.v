module enemy_collision
	(
		input direction,                // current direction of yoshi
		input wire [9:0] y_x, y_y,      // yoshi x/y
		input wire [9:0] g_c_x, g_c_y,  // ghost_crazy x/y
		input wire [9:0] g_t_x, g_t_y,  // ghost_top x/y
		input wire [9:0] g_b_x, g_b_y,  // ghost_bottom x/y
		output wire collision           // output signal asserted when ghost and yoshi collide
    );
	
	// symbolic states for left and right motion
    localparam LEFT = 0;
    localparam RIGHT = 1;
	
	// register for collision state
	reg collide;
	
	always @*
		begin
		// default
		collide = 0;
		
		// if yoshi facing left
		if(direction == LEFT)
			begin
			// if yoshi and ghost_crazy are within each other, assert collide
			if((g_c_x + 13 > y_x && g_c_x < y_x + 13 && g_c_y + 13 > y_y && g_c_y < y_y + 13) ||
			   (g_c_x + 13 > y_x + 9 && g_c_x < y_x + 16 && g_c_y + 13 > y_y + 13 && g_c_y < y_y + 18))
			  collide = 1;
			  
			// if yoshi and ghost_top are within each other, assert collide  
			else if((g_t_x + 13 > y_x && g_t_x < y_x + 13 && g_t_y + 13 > y_y && g_t_y < y_y + 13) ||
			        (g_t_x + 13 > y_x + 9 && g_t_x < y_x + 16 && g_t_y + 13 > y_y + 13 && g_t_y < y_y + 18))
			  collide = 1;
			  
			// if yoshi and ghost_bottom are within each other, assert collide  
			else if((g_b_x + 13 > y_x && g_b_x < y_x + 13 && g_b_y + 13 > y_y && g_b_y < y_y + 13) ||
			        (g_b_x + 13 > y_x + 9 && g_b_x < y_x + 16 && g_b_y + 13 > y_y + 13 && g_b_y < y_y + 18))
			  collide = 1;
			end
		
		// if yoshi facing right	
		if(direction == RIGHT)
			begin
			// if yoshi and ghost_crazy are within each other, assert collide
			if((g_c_x + 13 > y_x + 9 && g_c_x < y_x + 16 && g_c_y + 13 > y_y && g_c_y < y_y + 13) ||
			   (g_c_x + 13 > y_x && g_c_x < y_x + 13 && g_c_y + 13 > y_y + 13 && g_c_y < y_y + 18))
			  collide = 1;
			
			// if yoshi and ghost_top are within each other, assert collide
			else if((g_t_x + 13 > y_x + 9 && g_t_x < y_x + 16 && g_t_y + 13 > y_y && g_t_y < y_y + 13) ||
			        (g_t_x + 13 > y_x && g_t_x < y_x + 13 && g_t_y + 13 > y_y + 13 && g_t_y < y_y + 18))
			  collide = 1;
			
			// if yoshi and ghost_bottom are within each other, assert collide
			else if((g_b_x + 13 > y_x + 9 && g_b_x < y_x + 16 && g_b_y + 13 > y_y && g_b_y < y_y + 13) ||
			        (g_b_x + 13 > y_x && g_b_x < y_x + 13 && g_b_y + 13 > y_y + 13 && g_b_y < y_y + 18))
			  collide = 1;
			end
		end
	
	// assert output signal
	assign collision = collide;
			
endmodule