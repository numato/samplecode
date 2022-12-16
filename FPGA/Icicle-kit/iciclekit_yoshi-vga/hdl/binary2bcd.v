module binary2bcd
	(
		input wire clk, reset,        // clock, reset input signals for synchronous registers                
		input wire start,             // input signal to start binary to bcd conversion
		input wire [13:0] in,         // signal for binary input to convert
		output wire [3:0] bcd3, bcd2, // converted bcd signals routed out
  		                  bcd1, bcd0
	);
	
	// registers
	reg  state_reg, state_next;                                // FSM state register
	reg [13:0] input_reg, input_next;                          // reg to store in value when beginning conversion
	reg [3:0] count_reg, count_next;                           // counter reg to count number of iterations
	reg [3:0] bcd_3_reg, bcd_2_reg, bcd_1_reg, bcd_0_reg,      // regs to store bcd values,
              bcd_3_next, bcd_2_next, bcd_1_next, bcd_0_next;  // regs to store next state bcd values
    	wire [3:0] bcd_3_temp, bcd_2_temp, bcd_1_temp, bcd_0_temp; // regs to temporarily store bcd values
	
	
			  
	// FSM symbolic states
	localparam idle    = 1'b0,
		   convert = 1'b1;
			   
	// infer all the registers
	always @(posedge clk, posedge reset)
		if (reset)
			begin
			state_reg <= idle;
		    	input_reg <= 0;
		    	count_reg <= 0;
		    	bcd_3_reg <= 0;
		    	bcd_2_reg <= 0;
		    	bcd_1_reg <= 0;
		    	bcd_0_reg <= 0;
	            	end
		else
			begin
            		state_reg <= state_next;
            		input_reg <= input_next;
            		count_reg <= count_next;
            		bcd_3_reg <= bcd_3_next;
            		bcd_2_reg <= bcd_2_next;
            		bcd_1_reg <= bcd_1_next;
            		bcd_0_reg <= bcd_0_next;
			end
			
	// FSM next-state logic
	always @*
		begin
		// defaults
		state_next = state_reg;
		input_next = input_reg;
		count_next = count_reg;
		bcd_0_next = bcd_0_reg;
		bcd_1_next = bcd_1_reg;
		bcd_2_next = bcd_2_reg;
		bcd_3_next = bcd_3_reg;
		
		case (state_reg)
			
			idle:
				begin
				if (start)
					begin
                     			state_next = convert; // go to convert state
                     			bcd_0_next = 0;       // reset bcd register values
                     			bcd_1_next = 0;
                     			bcd_2_next = 0;
                     			bcd_3_next = 0;
                     			count_next = 0;       // reset iteration count register
                     			input_next = in;      // store input to input_reg
					 end
				end
				
			convert:
				begin
				
               			input_next = input_reg << 1;                     // left shift input
               			bcd_0_next = {bcd_0_temp[2:0], input_reg[13]};   // left shift in MSB of input to LSB of bcd_0
               			bcd_1_next = {bcd_1_temp[2:0], bcd_0_temp[3]};   // left shift MSB of bcd_0 into LSB of bcd_1
               			bcd_2_next = {bcd_2_temp[2:0], bcd_1_temp[3]};   // left shift MSB of bcd_1 into LSB of bcd_2
               			bcd_3_next = {bcd_3_temp[2:0], bcd_2_temp[3]};   // left shift MSB of bcd_2 into LSB of bcd_3, MSB is lost
			   
			   	// increment count reg
               			count_next = count_reg + 1;
               
			  	 // if done with algorithm go back to idle state
			  	 if (count_next== 14)
                  			 state_next = idle;
            			end
		endcase
		end
	
	// make adjustment if neccesary
	assign bcd_0_temp = (bcd_0_reg > 4) ? bcd_0_reg + 3 : bcd_0_reg;
	assign bcd_1_temp = (bcd_1_reg > 4) ? bcd_1_reg + 3 : bcd_1_reg;
	assign bcd_2_temp = (bcd_2_reg > 4) ? bcd_2_reg + 3 : bcd_2_reg;
	assign bcd_3_temp = (bcd_3_reg > 4) ? bcd_3_reg + 3 : bcd_3_reg;
	
	// output
	assign bcd0 = bcd_0_reg;
	assign bcd1 = bcd_1_reg;
	assign bcd2 = bcd_2_reg;
	assign bcd3 = bcd_3_reg;

endmodule
