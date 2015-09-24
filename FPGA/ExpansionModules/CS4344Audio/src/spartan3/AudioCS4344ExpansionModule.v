`timescale 1ns / 1ps

// Audio CS4344 Module demo code
// Numato Lab
// http://www.numato.com
// http://www.numato.cc
// License : CC BY-SA (http://creativecommons.org/licenses/by-sa/2.0/)

module AudioCS4344ExpansionModule (  
                               
    // Assuming 12MHz input clock.My need to adjust the counter below
    // if any other input frequency is used
	    input Clk,   

    // Output to CS4344 		
		 output reg SDIN,							   
       output reg SCLK,                    
		 output reg LRCK,
		 output  MCLK
		);

wire clkout;
clock_gen  c1 (.CLK_IN(Clk),
	            .RST_IN(1'b0),
	            .CLK_OUT(clkout));
						
// Register used internally
reg [31:0]counter=0;
reg [15:0]count=0;
reg pwm;

// pwm count define to switch between the Audio
integer pwmcount=99;

// Reduce the Clock Frequency
parameter freq = 100000000/60000;

// Implementation: The CS4344, a 24-Bit, 192 kHz Stereo D/A Converter which enables producing high
// quality stereo audio from a digital source.Here the demo code uses the simple PWM to generate the Audio.
// PWM is generated is such a way that it satisfy the frequency parameter for CS4344.To switch between the 
// frequency counter is provided different value every time it counts down to zero.Thus the data pin for the
// CS4344 i.e., SDIN is toggle at different rate.
 
assign MCLK = clkout;
always @(posedge clkout)
 begin
   if (count==0)                                           
	  begin
	   pwm <= (pwmcount==19)? counter[28] : counter[24];  
		pwmcount <= (pwmcount==0)? 99:pwmcount-1;
	
    // Count Register value is changed to obtain the output tone.	
	    if (pwm) begin                                              
	      count <= freq/68;
    
	// It gives the switching between the left and right audio.
         LRCK <= 1'b0;
       end			
		 else begin
		   count <= freq/70;
			LRCK <= 1'b1;
			SCLK <= ~SCLK;
		 end
		 
    // The data pin for CS4344.
		 SDIN <= ~SDIN;                                             
     end
	else 
	   count <= count-1;
	  counter <= counter+1;
  end
endmodule 