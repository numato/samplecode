`timescale 1ns / 1ps

// Push Button Module demo code
// Numato Lab
// http://www.numato.com
// http://www.numato.cc
// License : CC BY-SA (http://creativecommons.org/licenses/by-sa/2.0/)

module PushButtonExpansionModule(

  // Assuming 100MHz input clock. My need to adjust the counter below
  // if any other input frequency is used
    input Clk,
	 
  // Inputs from the Push Buttons.When a Switch is pressed it is pull down to zero otherwise it's in pull up state
    input [7:0]Switch,
  
  // Output is shown on LED with different functionality.
    output reg [7:0]LED  
    );

// Increase the clock frequency 
wire clkout;
clock_gen  c1 (.CLK_IN(Clk),
	            .RST_IN(1'b0),
	            .CLK_OUT(clkout));
					  
// Register used internally	
reg [24:0]count;
reg enable;

// Provide the initial value to give a kick start.
initial 
  begin
    LED = 8'h01;
  end
  
// Scale down the clock so that output is easily visible.
always @(posedge clkout) begin
  count <= count+1'b1;
  enable <= count[24];
end  

// On every rising edge of enable check for the Push Button input.
always @(posedge enable)
   begin
     LED <= !Switch[0] ? 8'd1   :  
	         !Switch[1] ? 8'd2   :
				!Switch[2] ? 8'd4   :
				!Switch[3] ? 8'd8   :
				!Switch[4] ? 8'd16  :
				!Switch[5] ? 8'd32  :
				!Switch[6] ? 8'd64  :
				!Switch[7] ? 8'd128 :
				{LED[0],LED[7:1]};
   end
endmodule
