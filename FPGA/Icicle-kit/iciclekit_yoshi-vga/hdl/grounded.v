module grounded
    (
        input wire clk, reset,     // clock, reset signals for synchrnous registers
        input wire [9:0] y_x, y_y, // current pixel coordinates from vga_sync circuit
        input wire jumping_up,     // input signal asserted when yoshi is in jumping_up state
	input wire direction,       // input signal conveying yoshi's direction
	output wire grounded       // output signal asserted when yoshi is in contact with a platform 
    );
   
    // constant declarations
    // max pixel coordinates for VGA display area
    localparam MAX_X = 640;
    localparam MAX_Y = 480;
   
    // tile width and height
    localparam T_W = 16;
    localparam T_H = 16;
   
    // maximum x dimension for combines tiles of yoshi (see diagram)
    localparam X_MAX = 25;
   
    // difference in head and torso tile placement in x dimension (see diagram)
    localparam X_D   = 9;
    localparam LA    = 19;
    localparam LB    = 13;
    localparam RA    = 11;
    localparam RB    =  5;
    localparam LEFT  =  0;
    localparam RIGHT =  1;
	
    // register for grounded signal
    reg grounded_reg, grounded_next;
	
    // infer grounded signal
    always @(posedge clk, posedge reset)
	if(reset)
		grounded_reg <= 1;
	else
		grounded_reg <= grounded_next;
	
    // next-state logic for grounded signal
    always @*
		begin
		// default
		grounded_next = grounded_reg;
		
		// yoshi is allowed to jump up over a platform and then land on it,
        	// only assert grounded when not jumping_up.
		// check if yoshi is on each platform, if so change grounded signal to be asserted
		if(!jumping_up)
			begin
			
			// 'A'	
			if(direction == LEFT && (y_y == 132 - 2*T_H) && (y_x >= 16) && (y_x < 160 - LB))
				grounded_next = 1;
			
			else if(direction == RIGHT && (y_y == 132 - 2*T_H) && (y_x >= 16) && (y_x < 160 - RB))
				grounded_next = 1;
			
			// 'B'
			else if(direction == LEFT && (y_y == 132 - 2*T_H) && (y_x >= 480 - LA) && (y_x < 624))
				grounded_next = 1;
			
			else if(direction == RIGHT && (y_y == 132 - 2*T_H) && (y_x >= 480 - RA) && (y_x < 624))
				grounded_next = 1;
			
			// 'C'
			else if(direction == LEFT && (y_y == 215 - 2*T_H) && (y_x >= 80 - LA) && (y_x < 561 - LB))
				grounded_next = 1;
			
			else if(direction == RIGHT && (y_y == 215 - 2*T_H) && (y_x >= 80 - RA) && (y_x < 561 - RB))
				grounded_next = 1;
			
			// 'D'
			else if(direction == LEFT && (y_y == 298 - 2*T_H) && (y_x >= 16) && (y_x < 256 - LB))
				grounded_next = 1;
			
			else if(direction == RIGHT && (y_y == 298 - 2*T_H) && (y_x >= 16) && (y_x < 256 - RB))
				grounded_next = 1;
				
			// 'E'
			else if(direction == LEFT && (y_y == 298 - 2*T_H) && (y_x >= 384 - LA) && (y_x < 624 - LB))
				grounded_next = 1;
			
			else if(direction == RIGHT && (y_y == 298 - 2*T_H) && (y_x >= 384 - RA) && (y_x < 624 - RB))
				grounded_next = 1;
			
			// 'F'
			else if(direction == LEFT && (y_y == 381 - 2*T_H) && (y_x > 112 - LA) && (y_x < 529 - LB))
				grounded_next = 1;
			
			else if(direction == RIGHT && (y_y == 381 - 2*T_H) && (y_x > 112 - RA) && (y_x < 529 - RB))
				grounded_next = 1;
				
			// 'G'
			else if((y_y == MAX_Y - 2*T_H - 16))
				grounded_next = 1;
	
			else 
				grounded_next = 0;
			end
		else 
			grounded_next = 0;
		end	
	
	assign grounded = grounded_reg;
endmodule 
