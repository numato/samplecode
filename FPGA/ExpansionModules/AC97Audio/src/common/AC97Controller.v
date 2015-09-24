`timescale 1ns / 1ps

module AC97Controller(  
    // Input from the AC97 Audio module and command module.
        input AC97SDI,
        input AC97BitClock, 
        input Rst,
        input [7:0] Register,
        input [15:0] command,
        input validate,
		
    // Output for the AC97 Audio module. 
        output reg AC97SDO,
        output reg done,
        output reg AC97Sync
       );  

   // Register and wire used for internal purpose.
   reg [7:0] counter;
   
   // Monitor Bit clock and Rst in asynchronous fashion.   
   always @(posedge AC97BitClock or posedge Rst) 
     begin
	// When reset is pulled high reset all the variables. 
      if (Rst)
        begin
         done      <= 1'b0;
         AC97SDO   <= 1'b0;
         AC97Sync  <= 1'b0;
         counter   <= 8'h00;
        end
       else
         begin
	// Validate the frame , register and the command for LM4550	 
          if ((counter >= 0) && (counter <= 15))
            case (counter[3:0])
              4'h0: AC97SDO  <= 1'b1;      
              4'h1: AC97SDO  <= validate;   
              4'h2: AC97SDO  <= validate;  
              default: AC97SDO <= 1'b0;
            endcase
	// Serially output the register contained. 		
          else if ((counter >= 16) && (counter <= 23))
            AC97SDO <=  Register[23-counter];
			
	// Serially output the command for that register.
          else if ((counter >= 36) && (counter <= 51))
            AC97SDO <=  command[51-counter];
	
	// When done PULLDOWN the SDO line
          else
            AC97SDO <= 1'b0;
    
    // Generate the Sync signal for AC97 at 48 KHz and done signal for fetching next command.	
          if (counter == 255)
               AC97Sync <= 1'b1;
          else if (counter == 128)
               done <= 1'b1;
          else if (counter == 15)
               AC97Sync <= 1'b0;  
          else if (counter == 2)
                done <= 1'b0; 
          counter <= counter+1;
        end
   end 

endmodule

