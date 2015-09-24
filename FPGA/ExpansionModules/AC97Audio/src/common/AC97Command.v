`timescale 1ns / 1ps

module AC97Commands

// Parameter declared to control the volume.
#(parameter MasterVolume    = 5'd11,                    
            HPVolume        = 5'd11,                    
            LineInVolume    = 5'd11
 )  
(
  // Input clock assume to be 100 MHz, with active high reset. 
   input CLK,
   input Rst,
  
  // Done signal use to issue next command.  
   input done,  
  // Output for LM4550 telling which register to operate and the code for it.
  // For better understanding refer LM4550 user guide.  
   output [7:0] Register,
   output [15:0] command,
   output reg validate
);
  // Variable used for internal purpose. 
   reg [23:0] cmd;
   reg previous_done;
   reg [3:0] state;
  
  // Load the value of Register and the command for the register.  
   assign Register = cmd[23:16];
   assign command = cmd[15:0];

  // Volume control, more the value lesser will be the attenuation so the volume will be more.  
   wire [4:0] HP_vol;
   wire [4:0] Master_vol;
   wire [4:0] LineIn_vol;
    
   assign HP_vol = 31-HPVolume;
   assign LineIn_vol = 31-LineInVolume;
   assign Master_vol = 31-MasterVolume;

   // Monitoring clock and reset in asynchronous fashion.
   always @(posedge CLK or posedge Rst) begin
    // when reset is pulled the LM45501 should be reset along with the internally used variable.
       if (Rst) begin
          validate <= 0;
          previous_done <= 0;
          state <= 0;
        end  
	// verify whether the all the command is transferred serially to LM4550  	
      else if (done && (!previous_done)) begin
        state <= state+1;
        validate <= 1'b1;
		  previous_done <= done;
		end
		
      case (state)
             0: cmd <= {8'h7C, 16'b0100111001010011};                      // Read the vendor ID 1
             1: cmd <= {8'h7E, 16'b0100001101010000};                      // Read the vendor ID 2
             2: cmd <= {8'h02, 3'b000,Master_vol,3'b000,Master_vol};       // Control the Master Volume level
             3: cmd <= {8'h04, 3'b000,HP_vol, 3'b000,HP_vol};              // Control the volume for the Headphone
             4: cmd <= {8'h10, 3'b000,LineIn_vol, 3'b000,LineIn_vol};      // Control the volume for Line-in.
             5: cmd <= {8'h1A, 16'b0000000000000000};                      // Record select register.
             6: cmd <= {8'h1C, 16'b0000111100001111};                      // Record gain register.
             7: cmd <= {8'h0E, 16'b0000000001001000};                      // Provide the gain for Mic-in (20dB). 
			                                                                  // If direct input from source provided to Mic-in output volume can be very high.
             8: cmd <= {8'h20, 16'b0000000000000000};                      // General purpose register
             default: $display ("LM4550 Initialized");              
      endcase 
      
      
   end

endmodule
