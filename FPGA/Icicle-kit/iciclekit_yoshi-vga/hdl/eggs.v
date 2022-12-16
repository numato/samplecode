module eggs
    (
        input wire clk, reset,             // clock / reset signals for synchronous registers
        input wire [9:0] y_x, y_y,         // current pixel location of yoshi
        input direction,                   // direction of yoshi
        input wire [9:0] x, y,             // current pixel coordinates from vga_sync circuit
        output eggs_on,                    // on signal: vga pixel within sprite location
        output wire [11:0] rgb_out,        // output rgb signal for current pixel
        output wire [13:0] score,          // output score register value
	output wire new_score              // output signal that is asserted when a new score is calculated
    );
   
    // symbolic states for left and right motion of yoshi
    localparam LEFT = 0;
    localparam RIGHT = 1;
   
    // register to oscillate through platforms to spawn egg onto (see platform diagram)
    reg [2:0] platform_select_reg;
    wire [2:0] platform_select_next;
	
    // infer platform select register
    always @(posedge clk, posedge reset)
        if(reset)
            platform_select_reg <= 5;
        else
            platform_select_reg <= platform_select_next;
	
	assign  platform_select_next = platform_select_reg + 1;
   
    // location of egg and type registers
    reg [9:0] egg_x_reg, egg_x_next, egg_y_reg, egg_y_next;
    reg [5:0] egg_type_reg, egg_type_next;
   
	// infer egg location and type registers
    always @(posedge clk, posedge reset)
        if(reset)
            begin
            egg_x_reg    <= 296;
            egg_y_reg    <= 364;
            egg_type_reg <= 0;
            end
        else
            begin
            egg_x_reg    <= egg_x_next;
            egg_y_reg    <= egg_y_next;
            egg_type_reg <= egg_type_next;
            end
           
    // platform location registers:
    // when a new egg spawns, the platform_select_reg determines which platform, while the corresponding
    // platform location registers determine where on the platform the new egg will spawn.
    reg[7:0] A_reg; // [ 16, 144]
    reg[9:0] B_reg; // [480, 608]
    reg[9:0] C_reg; // [ 80, 545]
    reg[8:0] D_reg; // [ 16, 240]
    reg[9:0] E_reg; // [384, 608]
    reg[9:0] F_reg; // [112, 513]
    reg[9:0] G_reg; // [ 16, 608]
   
    // infer registers and next-state logic
    always @(posedge clk, posedge reset)
        if(reset)
            begin
            A_reg <=  16;
            B_reg <= 480;
            C_reg <=  80;
            D_reg <=  16;
            E_reg <= 384;
            F_reg <= 296;
            G_reg <=  16;
            end
        else
            begin
            A_reg <= (A_reg <= 144)? A_reg + 1 :  16;
            B_reg <= (B_reg <= 608)? B_reg + 1 : 480;
            C_reg <= (C_reg <= 545)? C_reg + 1 :  80;
            D_reg <= (D_reg <= 240)? D_reg + 1 :  16;
            E_reg <= (E_reg <= 608)? E_reg + 1 : 384;
            F_reg <= (F_reg <= 513)? F_reg + 1 : 112;
            G_reg <= (G_reg <= 608)? G_reg + 1 :  16;
            end
 
    // egg FSM state register
    reg [1:0] state_reg, state_next;
    
	// infer egg state register
    always @(posedge clk, posedge reset)
        if(reset)
            state_reg <= waiting;
        else
            state_reg <= state_next;
			
    // new_score register, signals when a new score is calculated
    reg new_score_reg, new_score_next; 
	
    // infer new_score register
    always @(posedge clk, posedge reset)
    if(reset)
	    new_score_reg <= 0;
    else
            new_score_reg <= new_score_next;
	
    // assign new_score output
    assign new_score = new_score_reg;
   
    // symbolic state representations for egg FSM
    localparam  waiting    = 1'b0, // waiting for yoshi to get egg
                respawn    = 1'b1; // yoshi acquired egg, respawn new egg
    
    // egg FSM next-state logic
    always @*
        begin
	// defaults
        state_next = state_reg;
        egg_x_next = egg_x_reg;
        egg_y_next = egg_y_reg;
        egg_type_next = egg_type_reg;
	new_score_next = 0;
       
        case(state_reg)
           
            waiting: // egg already spawned, waiting for yoshi to get it
                begin
		// if yoshi collides with egg facing LEFT
                if(direction == LEFT && (egg_x_reg + 13 > y_x && egg_x_reg < y_x + 13 && egg_y_reg + 13 > y_y && egg_y_reg < y_y + 13) ||
                  (egg_x_reg + 13 > y_x + 9 && egg_x_reg < y_x + 16 && egg_y_reg + 13 > y_y + 13 && egg_y_reg < y_y + 18))
                    begin
		    new_score_next = 1;    // signal new score ready
		    state_next = respawn; // go to respawn state
		    end
                
		// else if yoshi collides with egg facing RIGHT
                else if(direction == RIGHT && (egg_x_reg + 13 > y_x + 9 && egg_x_reg < y_x + 16 && egg_y_reg + 13 > y_y && egg_y_reg < y_y + 13) ||
                       (egg_x_reg + 13 > y_x && egg_x_reg < y_x + 13 && egg_y_reg + 13 > y_y + 13 && egg_y_reg < y_y + 18))
                    begin
		    new_score_next = 1;    // signal new score ready
		    state_next = respawn; // go to respawn state
		    end
                end

            respawn: // respawn new egg at current platform_select_reg platform,
         	     // and at this platform's location register value
                begin
                if(platform_select_reg == 0) // 'A'
                    begin
                    egg_y_next    = 116;
                    egg_x_next    = A_reg;
                    egg_type_next = A_reg[5:0];
                    end
                else if(platform_select_reg == 1) // 'B'
                    begin
                    egg_y_next    = 116;
                    egg_x_next    = B_reg;
                    egg_type_next = B_reg[5:0];
                    end
                else if(platform_select_reg == 2) // 'C'
                    begin
                    egg_y_next    = 199;
                    egg_x_next    = C_reg;
                    egg_type_next = C_reg[5:0];
                    end
                else if(platform_select_reg == 3) // 'D'
                    begin
                    egg_y_next    = 282;
                    egg_x_next    = D_reg;
                    egg_type_next = D_reg[5:0];
                    end
                else if(platform_select_reg == 4) // 'E'
                    begin
                    egg_y_next    = 282;
                    egg_x_next    = E_reg;
                    egg_type_next = E_reg[5:0];
                    end
                else if(platform_select_reg == 5) // 'F'
                    begin
                    egg_y_next    = 365;
                    egg_x_next    = F_reg;
                    egg_type_next = F_reg[5:0];
                    end
                else // 6, 7 :'G'
                    begin
                    egg_y_next    = 448;
                    egg_x_next    = G_reg;
                    egg_type_next = G_reg[5:0];
                    end
               
                state_next = waiting; // go back to waiting state
                end
        endcase
        end
   
    // assign egg_type_offset depending on cycling egg_type_reg value
    // Green, Red, Blue, Yellow, Special in order of decreasing probability
    wire [6:0] egg_type_offset;
    assign egg_type_offset = (egg_type_reg <= 29) ? 0 :
                             (egg_type_reg > 29  && egg_type_reg <= 44) ? 16 :
                             (egg_type_reg > 44  && egg_type_reg <= 54) ? 32 :
                             (egg_type_reg > 54  && egg_type_reg <= 62) ? 48 : 64;
    
    // score reg and next-state logic
    reg [13:0] score_reg;
    wire [13:0] score_next;
	
    // infer score register
    always @(posedge clk, posedge reset)
    if(reset)
	    score_reg <= 0;
    else
            score_reg <= score_next;
	
    // score updates on new_score_reg tick depending on egg_type_offset (egg color)
    assign score_next = (reset || new_score_next && score_reg == 9999) ? 0 : 
			new_score_next && egg_type_offset ==  0 ? score_reg +   20: // green   egg: p = 30/64, score =  10
			new_score_next && egg_type_offset == 16 ? score_reg +   40: // red     egg: p = 15/64, score =  20
			new_score_next && egg_type_offset == 32 ? score_reg +   60: // blue    egg: p = 10/64, score =  50
			new_score_next && egg_type_offset == 48 ? score_reg +  200: // yellow  egg: p = 08/64, score =  100
			new_score_next && egg_type_offset == 64 ? score_reg +  500: // special egg: p = 01/64, score =  500
			score_reg;
	
    // assign score to output
    assign score = score_reg;
   
    // sprite coordinate addreses, from upper left corner
    // used to index ROM data
    wire [3:0] col;
    wire [6:0] row;
   
    // current pixel coordinate minus current sprite coordinate gives ROM index
    assign col = x - egg_x_reg;
    // row index value depends on offset for which tile to display
    assign row = y + egg_type_offset - egg_y_reg;
   
    // infer egg sprites rom
    eggs_rom eggs_rom_unit(.clk(clk), .row(row), .col(col), .color_data(rgb_out));
   
    // signal asserted when x/y vga pixel values are within sprite in current location
    assign eggs_on = (x >= egg_x_reg && x < egg_x_reg + 16 && y >= egg_y_reg && y < egg_y_reg + 16)
                     && (rgb_out != 12'b011011011110) ? 1 : 0;                    
endmodule
