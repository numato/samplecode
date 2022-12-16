module game_state_machine
	(	
		input wire clk, hard_reset,   // clock and reset inputs for synchronous registers
		input wire start,             // start button signal input
        	input wire collision,         // collision detection signal input
		output wire [1:0] num_hearts, // output number of hearts [0-3]
		output wire [2:0] game_state, // output game state machine's state
		output wire game_en,          // output signal asserted when game is in playing/hit states
		output reg game_reset         // output signal asserted to reset game mechanics modules (see use in display_top)
        );
	
	// positive edge detection for start button
	reg start_reg;
	wire start_posedge;
	
	// infer start signal register
	always @(posedge clk, posedge hard_reset)
		if(hard_reset)
			start_reg <= 0;
		else 
			start_reg <= start;
	
	// assert start_posedge on positive edge of start button signal
	assign start_posedge = start & ~start_reg;
	
	// symbolic state declarations
	localparam [2:0] init     = 3'b000,  // state to idle while nes controller signals settle
			 idle     = 3'b001,  // start screen 
		         playing  = 3'b010,  // playing
			 hit      = 3'b011,  // yoshi has been hit
			 gameover = 3'b100;  // game over!
	
	reg [2:0] game_state_reg, game_state_next; // FSM state register
	reg [27:0] timeout_reg, timeout_next;      // timer register to time yoshi's invincibility post ghost collision
	reg [1:0] hearts_reg, hearts_next;         // register to store number of hearts
	reg game_en_reg, game_en_next;             // register for game enable signal
	
	// infer game state, timeout timer, hearts, and game enable register
	always @(posedge clk, posedge hard_reset)
		if(hard_reset)
			begin
			game_state_reg <= init;
			timeout_reg    <= 20000000;
			hearts_reg     <= 3;
			game_en_reg    <= 0;
			end
		else
			begin
			game_state_reg <= game_state_next;
			timeout_reg    <= timeout_next;
			hearts_reg     <= hearts_next;
			game_en_reg    <= game_en_next;
			end
	
	always @*
		begin
		// defaults 
		game_state_next = game_state_reg;
		timeout_next    = timeout_reg;
		hearts_next     = hearts_reg;
		game_en_next    = game_en_reg;
		game_reset = 0;
		
		case(game_state_reg)
			
			init:
				begin	
				if(timeout_reg > 0)                   // decrement timeout_reg until 0 to let nes controller signals settle
					timeout_next = timeout_reg - 1;
				else 
					game_state_next = idle;           // go to idle game state
				end
				
			idle:
				begin
				if(start_posedge)                     // player presses start button to begin game
					begin
					game_en_next = 1;                 // game_en signal asserted next
					game_reset   = 1;                 // assert reset game signal
					game_state_next = playing;        // next state is playing
					end
				end
			
			playing:
				begin
				if(collision)                         // if yoshi collides with ghost while playing
					begin
					if(hearts_reg == 1)               // if on last heart
						begin
						hearts_next = hearts_reg - 1; // decrement hearts_reg to 0
						game_en_next = 0;             // disable game_en signal
						game_state_next = gameover;   // go to gameover state
						end
					else
						begin
						hearts_next = hearts_reg - 1; // else decrement hearts_reg 
						game_state_next = hit;        // go to hit state
						timeout_next = 200000000;     // load timeout_reg for 2 seconds of invincibility
						end
					end
				end
				
			hit:
				begin	                              // yoshi cannot be hit (have hearts decremented)
				if(timeout_reg > 0)                   // decrement timeout_reg until 0 (2 seconds)
					timeout_next = timeout_reg - 1;
				else 
					game_state_next = playing;        // go back to playing state
				end
			
			gameover:                                 // gameover state
				begin
				if(start_posedge)                     // wait for player to press start button
					begin
					hearts_next = 3;                  // reset hearts_reg to 3
					game_state_next = init;           // go to init state
					game_reset   = 1;                 // assert game_reset signal to reset all gameplay mechanics modules (see display_top)
					end
				end
				
			endcase
			end
	
	// assign output signals
	assign num_hearts = hearts_reg;
	assign game_state = game_state_reg;
	assign game_en = game_en_reg;

endmodule
