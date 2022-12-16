module yoshi_sprite
    (
        input wire clk, reset,       // clock/reset inputs for synchronous registers 
        input wire btnU, btnL, btnR, // inputs used to move sprite across screen
        input wire video_on,         // input from vga_sync signaling when video signal is on
        input wire [9:0] x, y,       // current pixel coordinates from vga_sync circuit
	input wire grounded,         // input signal conveying when Yoshi is grounded on a platform
	input wire game_over_yoshi,  // input signal conveying when game state is gameover
	input wire collision,        // input signal conveying when yoshi collides with ghost
        output reg [11:0] rgb_out,   // output rgb signal for current yoshi pixel
        output reg yoshi_on,         // output signal asserted when input x/y are within yoshi sprite in display area
        output wire [9:0] y_x, y_y,  // output signals for yoshi sprite's current location within display area
	output wire jumping_up,      // output signal asserted when yoshi is jumping up
	output wire direction        // output signal conveying yoshi's direction of motion
    );
   
    // constant declarations
    // pixel coordinate boundaries for VGA display area
    localparam MAX_X = 640;
    localparam MAX_Y = 480;
    localparam MIN_Y =  16;
   
    // tile width and height
    localparam T_W = 16;
    localparam T_H = 16;
   
    // maximum x dimension for combines tiles of yoshi (see diagram)
    localparam X_MAX = 25;
   
    // difference in head and torso tile placement in x dimension (see diagram)
    localparam X_D = 9;
   
    /***********************************************************************************/
    /*                           sprite location registers                             */  
    /***********************************************************************************/
    // Yoshi sprite location regs, pixel location with respect to top left corner
    reg [9:0] s_x_reg, s_y_reg;
    reg [9:0] s_x_next, s_y_next;
   
    // infer registers for sprite location
    always @(posedge clk, posedge reset)
        if (reset)
            begin
            s_x_reg     <= 320;                 // initialize to middle of screen,
            s_y_reg     <= MAX_Y - 2*T_H - 16;  // on bottom floor
            end
        else
            begin
            s_x_reg     <= s_x_next;
            s_y_reg     <= s_y_next;
            end
   
    /***********************************************************************************/
    /*                                direction register                               */  
    /***********************************************************************************/
    // determines if yoshi sprite tiles are displayed normally or mirrored in x dimension
   
    // symbolic states for left and right motion
    localparam LEFT = 0;
    localparam RIGHT = 1;
   
    reg dir_reg, dir_next;
   
    // infer register
    always @(posedge clk, posedge reset)
        if (reset)
            dir_reg     <= RIGHT;
        else
            dir_reg     <= dir_next;
    
	// direction register next-state logic
    always @*
        begin
        dir_next = dir_reg;   // default, stay the same
       
        if(btnL && !btnR)     // if left button pressed, change value to LEFT
            dir_next = LEFT;  
           
        if(btnR && !btnL)     // if right button pressed, change value to RIGHT
            dir_next = RIGHT;
        end
   
    /***********************************************************************************/
    /*                           FSMD for x motion and momentum                        */  
    /***********************************************************************************/
   
    // symbolic state representations for FSM
    localparam [1:0] no_dir = 2'b00,
                     left = 2'b01,
                    right = 2'b10;      

    // to simulate x axis motion and momentum there is a countdown register x_time_reg that must decrement
    // on clk edges to 0 between sprite position updates. The initial value sets the speed of motion. This
    // register decrements from a smaller value each successive move when a directional button is held, such that 
    // the sprite will slowly speed up to a maximum speed, which is given by a minimum countdown time value. 
    // When yoshi is grounded, the momentum in x can change to another direction instantaneously. When he is 
    // in the air and moving in a particular direction, momentum in that x direction is constant and he will
    // continue to follow a parabolic trajectory through space. The x momentum can be adjusted  midair by pressing
    // the button opposite of the current direction, but this change follows the 2D game physics standard that has
    // the momentum slowly decrease until a minimum until it begins increasing in the new direction. This allows
    // yoshi to change his motion midair but with a delay due to overcoming initial momentum. 	
                     
    // constant parameters that determine x direction speed              
    localparam TIME_START_X  =   800000;  // starting value for x_time & x_start registers
    localparam TIME_STEP_X   =     6000;  // increment/decrement step for x_time register between sprite position updates
    localparam TIME_MIN_X    =   500000;  // minimum time_x reg value (fastest updates between position movement
               
    reg [1:0] x_state_reg, x_state_next;  // register for FSMD x motion state
    reg [19:0] x_time_reg, x_time_next;   // register to keep track of count down/up time for x motion
    reg [19:0] x_start_reg, x_start_next; // register to keep track of start time for count down/up for x motion
   
    // infer registers for FSMD state and x motion time
    always @(posedge clk, posedge reset)
        if (reset)
            begin
            x_state_reg <= no_dir;
            x_start_reg <= 0;
            x_time_reg  <= 0;
            end
        else
            begin
            x_state_reg <= x_state_next;
            x_start_reg <= x_start_next;
            x_time_reg  <= x_time_next;
            end
   
    // FSM next-state logic and data path
    always @*
        begin
        // defaults
        s_x_next     = s_x_reg;
        x_state_next = x_state_reg;
        x_start_next = x_start_reg;
        x_time_next  = x_time_reg;
       
        case (x_state_reg)
            
            no_dir:
                begin
                if(btnL && !btnR && (s_x_reg >= 1))                             // if left button pressed and can move left                  
                    begin
                    x_state_next = left;                                        // go to left state
                    x_time_next  = TIME_START_X;                                // set x_time reg to start time
                    x_start_next = TIME_START_X;                                // set start time reg to start time
                    end
                else if(!btnL && btnR && (s_x_reg + 1 < MAX_X - T_W - X_D + 1)) // if right button pressed and can move right
                    begin
                    x_state_next = right;                                       // go to right state
                    x_time_next  = TIME_START_X;                                // set x_time reg to start time
                    x_start_next = TIME_START_X;                                // set start time reg to start time
                    end
                end
               
            left:
                begin
                if(x_time_reg > 0)                                              // if x_time reg > 0,
                    x_time_next = x_time_reg - 1;                               // decrement
                   
                else if(x_time_reg == 0)                                        // if x_time reg = 0
                    begin 
                    if(s_x_reg >= 17)                                           // is sprite can move left,
                        s_x_next = s_x_reg - 1;                                 // move left
                    
		    if(btnL && x_start_reg > TIME_MIN_X)                    	// if left button pressed and x_start_reg > min,
                        begin                                                   // make sprite move faster in x direction,
                        x_start_next = x_start_reg - TIME_STEP_X;               // set x_start_reg to decremented start time
                        x_time_next  = x_start_reg - TIME_STEP_X;               // set x_time_reg to decremented start time
                        end
                       
                    else if(btnR && x_start_reg < TIME_START_X)                 // if sprite isnt on ground, and right button is pressed,
                        begin                                                   // and x_start_reg is < start time, slow down left motion
                        x_start_next = x_start_reg + TIME_STEP_X;               // set x_start_reg to incremented start time
                        x_time_next  = x_start_reg + TIME_STEP_X;               // set x_time_reg  to incremented start time
                        end
                    else                                                        // else left motion stays the same
                        begin
                        x_start_next = x_start_reg;                             // x_start_reg stays the same
                        x_time_next  = x_start_reg;                             // x_time_reg  stays the same
                        end
                    end
                   
                if(grounded && (!btnL || (btnL && btnR)))                       // if yoshi grounded, and left button unpressed, or both pressed
                    x_state_next = no_dir;                                      // go to no direction state
                else if(!grounded && btnR && x_start_reg >= TIME_START_X)       // if mid air and right button pressed and left momentum minimized
                    begin
		    x_state_next = right;                                       // go to right state and start moving right
		    x_time_next  = TIME_START_X;                                // set x_time reg to start time
                    x_start_next = TIME_START_X;                                // set start time reg to start time
		    end
		end
			
	    right:
                begin
		if(x_time_reg > 0)                                              // if x_time reg > 0,
			x_time_next = x_time_reg - 1;                           // decrement
				
		else if(x_time_reg == 0)                                        // if x_time reg = 0
			begin
			if(s_x_reg + 1 < MAX_X - T_W - X_D - 15)                // is sprite can move right,
			s_x_next = s_x_reg + 1;                                 // move right
						
			if(btnR && x_start_reg > TIME_MIN_X)                    // if right button pressed and x_start_reg > min,
				begin                                           // make sprite move faster in x direction,
				x_start_next = x_start_reg - TIME_STEP_X;       // set x_start_reg to decremented start time
				x_time_next  = x_start_reg - TIME_STEP_X;       // set x_time_reg to decremented start time
				end
			else if(btnL && x_start_reg < TIME_START_X)             // if sprite isnt on ground, and left button is pressed,
				begin                                           // and x_start_reg is < start time, slow down left motion
				x_start_next = x_start_reg + TIME_STEP_X;       // set x_start_reg to incremented start time
				x_time_next  = x_start_reg + TIME_STEP_X;       // set x_time_reg  to incremented start time
				end
						
			else                                                        // else right motion stays the same
				begin
				x_start_next = x_start_reg;                         // x_start_reg stays the same
				x_time_next  = x_start_reg;                         // x_time_reg  stays the same
				end
			end
				
		if(grounded && (!btnR || (btnL && btnR)))                       // if yoshi grounded, and right button unpressed, or both pressed
			x_state_next = no_dir;                                  // go to no direction state
		else if(!grounded && btnL && x_start_reg >= TIME_START_X)       // if mid air and left button pressed and right momentum minimized
			begin
			x_state_next = left;                                        // go to left state and start moving left
			x_time_next  = TIME_START_X;                                // set x_time reg to start time
                        x_start_next = TIME_START_X;                                // set start time reg to start time
			end
		end	
		endcase
		end    
                   
    /***********************************************************************************/
    /*              FSMD for Sprite standing/walking states, and y motion              */  
    /***********************************************************************************/  
   
    // motion in the y dimension follows a scheme that simulates gravity with a terminal velocity. When the jump/up
    // button is pressed it loads a start countdown value to the jump_t_reg, wich decrements on clk edges until 0,
    // when the y position is updated. Between each y position update the start time loaded to the register increases
    // which slows down the sprite's y position updates until a max time value is reached, upon which the sprite will
    // move downward. While moving downward, the jump_t_reg decrements to 0, when it updates the sprite position. Between
    // position updates, the loaded time to jump_t_reg decreses until reaching a terminal value. In effect, this scheme 
    // allows yoshi to jump up, slowing down until reaching a peak, then falling down, speeding up until reaching a terminal
    // falling speed. 
    // When jump/up button is initially pressed, the duration it is held increments the extra_up_reg, which will allow yoshi
    // to jump higher depending on the time the button is held. 
    // Since jumping requires yoshi to be drawn differently depending on whether going up or down, how yoshi is drawn standing 
    // or while walking is determined in the same FSM.
   
    // symbolic state representations
    localparam [2:0] standing   = 3'b000, // idle, no buttons pressed
                     walking    = 3'b001, // walking state
                     jump_up    = 3'b010, // jumping up
                     jump_extra = 3'b011, // extra jumping distance
                     jump_down  = 3'b100; // jumping down
                     
    // constant parameters that determine jump speed and height, and walking animation speed                
    localparam TIME_START_Y      =   100000;  // starting time to load when beginning to jump up
    localparam TIME_STEP_Y       =     8000;  // increment/decrement value to time loaded to jump_t_reg after position update
    localparam TIME_MAX_Y        =   600000;  // maximum time reached at peak of jump
    localparam TIME_TERM_Y       =   250000;  // terminal time reached when jumping down
    localparam BEGIN_COUNT_EXTRA =   450000;  // when jumping up and load value exceeds this value, start incrementing extra_up_reg
    localparam TILE_1_MAX        =  7000000;  // values used to...
    localparam TILE_2_MAX        = 14000000;  // determine which...
    localparam WALK_T_MAX        = 21000000;  // torso tile to draw while walk_t reg cycles in walking state
   
    reg [2:0] state_reg_y, state_next_y;    // register for FSMD state
    reg [24:0] walk_t_reg, walk_t_next;     // register to keep track of time between walking frames
    reg [19:0] jump_t_reg, jump_t_next;     // register to keep track of count down/up time for jumping
    reg [19:0] start_reg_y, start_next_y;   // register to keep track of start time for count down/up for jumping
    reg [6:0] dy;                           // reg to determine displacement for row signal, changing torso tiles
    reg [25:0] extra_up_reg, extra_up_next; // reg to count number of extra pixels up to jump for amount of time btnU held
   
   
    // signals for up-button positive edge signal
    reg [7:0] btnU_reg;
    wire btnU_edge;
    assign btnU_edge = ~(&btnU_reg) & btnU;
   
    // infer registers used for FSMD and up-button state reg
    always @(posedge clk, posedge reset)
        if(reset)
            begin
            state_reg_y  <= standing;
            walk_t_reg   <= 0;
            jump_t_reg   <= 0;
            start_reg_y  <= 0;
            extra_up_reg <= 0;
            btnU_reg     <= 0;
            end
        else
            begin
            state_reg_y  <= state_next_y;
            walk_t_reg   <= walk_t_next;
            jump_t_reg   <= jump_t_next;
            start_reg_y  <= start_next_y;
            extra_up_reg <= extra_up_next;
            btnU_reg     <= {btnU_reg[6:0], btnU};
            end
           
    // FSMD next-state logic and data path        
    always @*
        begin
        // defaults
        state_next_y  = state_reg_y;
        walk_t_next   = walk_t_reg;
        jump_t_next   = jump_t_reg;
        start_next_y  = start_reg_y;
        extra_up_next = extra_up_reg;
        s_y_next      = s_y_reg;
        dy            = 0;
       
        case (state_reg_y)
           
            standing:
                begin
                dy = 0;                                 // standing tile for torso
				
                if((btnL && !btnR)  || (!btnL && btnR)) // if L or R button pressed
                    begin
                    state_next_y = walking;             // go to first walking state
                    walk_t_next = 0;                    // set walk_t_reg counter to 0
                    end
                   
                if(btnU_edge)                           // if up button pressed
                    begin
                    state_next_y = jump_up;             // go to jump up state
                    start_next_y = TIME_START_Y;        // load start time in start time reg
                    jump_t_next = TIME_START_Y;         // load start time in jump time reg
                    extra_up_next = 0;
                    end
                end
       
            walking:
                begin
		if(!grounded)
		    begin
                    state_next_y = jump_down;           // go to jump down state
                    start_next_y = TIME_MAX_Y;          // load max time in start time reg
                    jump_t_next  = TIME_MAX_Y;          // load max time in jumpt time reg
                    end
				
		if((!btnL && !btnR) || (btnL && btnR))  // if no L/R buttons pressed, or both pressed
                    state_next_y = standing;                 // no more walking, go to standing state
				
		if(btnU_edge)                           // if up button pressed
                    begin
                    state_next_y = jump_up;             // go to jump up state
                    start_next_y = TIME_START_Y;        // load start time in start time reg
                    jump_t_next = TIME_START_Y;         // load start time in jump time reg
                    extra_up_next = 0;                  // set extra up count 0
                    end
					
                if(walk_t_reg < WALK_T_MAX)             // if walk_t_reg is less than maximum
                    walk_t_next = walk_t_reg + 1;       // increment value      
                else
                    walk_t_next = 0;                    // else reset to 0
               
                // which walking tile?
                if(walk_t_reg <= TILE_1_MAX)            // if walk_t_reg in first walking tile time range
                    dy = T_H;                           // adjust row to first walking tile
                else if (walk_t_reg <= TILE_2_MAX)      // if walk_t_reg in second walking tile time range
                    dy = 2*T_H;                         // adjust row to second walking tile
                else if(walk_t_reg < WALK_T_MAX)        // if walk_t_reg in last walking tile time range
                    dy = 0;                             // adjust row to last walking tile
                end
 
            jump_up:
                begin
                dy = 3*T_H;                                       // jumping tile for torso
               
                if(jump_t_reg > 0)                                // if jump time reg > 0
                    begin
                    jump_t_next = jump_t_reg - 1;                 // decrement reg
                    end
                   
                if(jump_t_reg == 0)                               // if jump time reg = 0
                    begin
                    if(btnU && start_reg_y > BEGIN_COUNT_EXTRA)   // if btnU still pressed, after certain time
                        extra_up_next = extra_up_reg + 1;         // increment extra up count
                    
		    if( s_y_next > MIN_Y)                 	// if yoshi can go up
			s_y_next = s_y_reg - 1;                   // move yoshi sprite up by one pixel
                else 				                  // else if yoshi will hit ceiling
			begin
			state_next_y = jump_down;                 // go to jump down state
			start_next_y = TIME_MAX_Y;                // load max time in start time reg
                        jump_t_next  = TIME_MAX_Y;                // load max time in jump time reg
			end
						
		    if(start_reg_y <= TIME_MAX_Y)                 // if start time reg < maximum
                        begin
                        start_next_y = start_reg_y + TIME_STEP_Y; // increment start time reg
                        jump_t_next = start_reg_y + TIME_STEP_Y;  // set jump time reg to new start value
                        end
                    else                                          // else if start time reg > maximum
                        begin
                        state_next_y = jump_extra;                // go to jump down state
                        extra_up_next = extra_up_reg << 1;
                        start_next_y = TIME_MAX_Y;                // load max time in start time reg
                        jump_t_next  = TIME_MAX_Y;                // load max time in jump time reg
                        end
                    end
                end
               
            jump_extra:
                begin
                dy = 3*T_H;                                 // jumping tile for torso
               
                if(extra_up_reg == 0)                       // extra jumping is done
                    begin
                    state_next_y = jump_down;               // go to jump down state
                    start_next_y = TIME_MAX_Y;              // load max time in start time reg
                    jump_t_next  = TIME_MAX_Y;              // load max time in jumpt time reg
                    end
               
                if(jump_t_reg > 0)                          // if jump time reg > 0
                    begin
                    jump_t_next = jump_t_reg - 1;           // decrement reg
                    end
                   
                if(jump_t_reg == 0)                         // if jump time reg = 0
                    begin
                    extra_up_next = extra_up_reg - 1;       // decrement extra jump up count reg
                    
		    if( s_y_next > MIN_Y)                   // if yoshi can go up
			s_y_next = s_y_reg - 1;             // move yoshi sprite up by one pixel
                    else 									// else if yoshi will hit ceiling
			state_next_y = jump_down;           // go to jump down state
	
		    start_next_y = TIME_MAX_Y;              // reset start time reg to max time
                    jump_t_next = TIME_MAX_Y;               // reset jump time reg to max time
                    end
                end
           
            jump_down:
                begin
                dy = 2*T_H;                                           // jumping down tile for torso is second walking tile
                if(jump_t_reg > 0)                                    // if jump time reg > 0
                    begin
                    jump_t_next = jump_t_reg - 1;                     // decrement reg
                    end
                   
                if(jump_t_reg == 0)                                   // if jump time reg = 0
                    begin
                    if(!grounded)                                      // if yoshi sprite is on ground or platform
                        begin
                        s_y_next = s_y_reg + 1;                       // move sprite down one pixel
                        if(start_reg_y > TIME_TERM_Y)                 // if time start reg isn't down to start time
                            begin
                            start_next_y = start_reg_y - TIME_STEP_Y; // dercrement time start reg
                            jump_t_next = start_reg_y - TIME_STEP_Y;  // set jump time reg to new start time
                            end
                        else
                            begin  
                            jump_t_next = TIME_TERM_Y;
                            end
                        end
                    else                                              // else if sprite position is at bottom
                        state_next_y = standing;                      // go to standing state
                    end
                end
        endcase
        end
       
    /***********************************************************************************/
    /*                                     ROM indexing                                */  
    /***********************************************************************************/  
                   
    // sprite coordinate addreses, from upper left corner
    // used to index ROM data
    wire [3:0] col;
    wire [6:0] row;
   
    // current pixel coordinate minus current sprite coordinate gives ROM index
	// column indexing depends on direction, and whether drawing head or torso to screen 
    assign col = (dir_reg == RIGHT && head_on)  ? (X_D + T_W - 1 - (x - s_x_reg)) :
                 (dir_reg == LEFT  && head_on)  ?                 ((x - s_x_reg)) :
                 (dir_reg == RIGHT && torso_on) ?       (T_W - 1 - (x - s_x_reg)) :
                 (dir_reg == LEFT  && torso_on) ?           ((x - s_x_reg - X_D)) : 0;
    
    // row indexing depends on whether drawing head or torso to screen	
    assign row = head_on  ? (y - s_y_reg):
                 torso_on ? (dy + y - s_y_reg): 0;
				 
    // either a normal yoshi or ghost yoshi is drawn depending on the game state routed into this module
   
    // vector for ROM color_data output
    wire [11:0] color_data_yoshi, color_data_yoshi_ghost;
   
    // instantiate yoshi ROM circuit
    yoshi_rom yoshi_rom_unit (.clk(clk), .row(row), .col(col), .color_data(color_data_yoshi));
	
    // instantiate yoshi ghost ROM circuit
    yoshi_ghost_rom yoshi_ghost_rom_unit (.clk(clk), .row(row), .col(col), .color_data(color_data_yoshi_ghost));
	
    // vector to signal when vga_sync pixel is within head or torso tile (see diagram)
    wire head_on, torso_on;
    assign head_on = (dir_reg == RIGHT) && (x >= s_x_reg + X_D) && (x <= s_x_reg + X_MAX - 1) && (y >= s_y_reg) && (y <= s_y_reg + T_H - 1) ? 1
                   : (dir_reg == LEFT) && (x >= s_x_reg) && (x <= s_x_reg + T_W - 1) && (y >= s_y_reg) && (y <= s_y_reg + T_H - 1) ? 1 : 0;
   
    assign torso_on = (dir_reg == RIGHT) && (x >= s_x_reg) && (x <= s_x_reg + T_W - 1) && (y >= s_y_reg + T_H) && (y <= s_y_reg + 2*T_H - 1) ? 1
                    : (dir_reg == LEFT) && (x >= s_x_reg + X_D) && (x <= s_x_reg + X_MAX - 1) && (y >= s_y_reg + T_H) && (y <= s_y_reg + 2*T_H - 1) ? 1 : 0;
   
    // assign module output signals
    assign y_x = s_x_reg;
    assign y_y = s_y_reg;
    assign jumping_up = (state_reg_y == jump_up) ? 1 : 0;
    assign direction = dir_reg;
	
    // if collision occurs, turn yoshi into a ghost for 2 seconds (200000000 clock cycles);
    reg [27:0] collision_time_reg;
    wire [27:0] collision_time_next;
	
    // infer ghost_yoshi_time register
    always @(posedge clk, posedge reset)
	if(reset)
		collision_time_reg <= 0;
	else 
		collision_time_reg <= collision_time_next;
	
    // when collision occurs, set reg to 2 seconds of clk cycles, else decrement until 0
    assign collision_time_next = collision ? 200000000 : 
								 collision_time_reg > 0 ? collision_time_reg - 1 : 0;
       
    // rgb output
    always @*
		begin
		// defaults
		yoshi_on = 0;
		rgb_out = 0;
		
		if(head_on || torso_on && video_on)               // if x/y in head/torso region  
			begin
			if(game_over_yoshi || collision_time_reg > 0) // if game in gameover state or collision occured        
				rgb_out = color_data_yoshi_ghost;         // output rgb data for yoshi_ghost
			else
				rgb_out = color_data_yoshi;               // else output rgb data for yoshi
		
			if(rgb_out != 12'b011011011110)               // if rgb data isn't sprite background color
					yoshi_on = 1;                         // assert yoshi_on signal to let display_top draw current pixel   
			end
        end
endmodule
