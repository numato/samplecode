`timescale 1ns / 1ps

// Seven segment LED display module demo code
// Numato Lab
// http://www.numato.com
// http://www.numato.cc
// License : CC BY-SA (http://creativecommons.org/licenses/by-sa/2.0/)

module SevenSegmentExpansionModule 

// Seven segment display have 8 data pins. Such 4 Seven Segment are enabled
#(parameter Datawidth = 8,           
            NumberOfDisp = 4
 )
 (
  // Assuming 100 MHz input clock and active low reset
  input clk, 
  input rst_n,
  // Seven segments of the display. The displays are multiplexed
  // So we need only 7 common IOs for all displays
  output [Datawidth-1:0]sevensegment,  
  // Enable pins for each Seven Segment display module
  output [NumberOfDisp-1:0]enable                                          
 );
 


   // Registers used internally
   reg [Datawidth-1:0]sevensegment_d,sevensegment_q;
   reg [NumberOfDisp-1:0]enable_d,enable_q;	 
   integer bcd_count_d,bcd_count_q;
	integer delay_count_d,delay_count_q;
   
	
	assign enable = enable_q;
	assign sevensegment = sevensegment_q;
	
	reg [18:0]count;
	reg clock;
	
   // Frequency assumed to be 100 MHz, scale down the 
   always @(posedge clk or negedge rst_n) begin
	    if (rst_n == 0) begin
		     count <= 0;
			  clock <= 0;
		 end
		 else begin
	        count <= count + 1; 
	        clock <= count[18];
		 end
   end

// Implementation:
// The seven segment LED display expansion module uses multiplexed
// topology to reduce the number of IOs required. In this topology,
// each segment of a display is connected to the corresponding 
// segments of all other displays. i.e., all 'a' segments connected 
// together, all 'b' segments connected together and so on..
// Each display has separate enable inputs that will turn a particular
// display module on or off. This code enables each display module one
// at a time and output the data to it. This keeps happening Indefinitely.
// Though only one display is on at any given time, persistence of vision
// causes it to look like all display are on at all times. 

    // Aysnchronous reset
    always @(posedge clock or negedge rst_n) begin
	     // Set to default state when reset is given 
	     if (rst_n == 0) begin
		      enable_q       <= {{NumberOfDisp-1{1'b1}} , 1'b0};
				sevensegment_q <= {Datawidth{1'b0}};
				bcd_count_q    <= 0;
				delay_count_q  <= 0;
		  end
		  else begin
		      enable_q       <= enable_d;
				sevensegment_q <= sevensegment_d;
				bcd_count_q    <= bcd_count_d;
				delay_count_q  <= delay_count_d;
		  end
	 end
	  
	 always @(*) begin
	     // Verify that the data is not missed
		  enable_d       <= enable_q;                      
		  sevensegment_d <= sevensegment_q;
		  bcd_count_d    <= bcd_count_q;
		  delay_count_d  <= delay_count_q;

        enable_d       <= {enable_q[NumberOfDisp-2:0],enable_q[NumberOfDisp-1]};	
		  
	     if(delay_count_q == 200) begin
			   bcd_count_d <= bcd_count_q + 1;
			   delay_count_d <= 0; 
		  end
	     else
	         delay_count_d <= delay_count_q + 1;
         

         // This module uses Common Anode configuration. Each display module is enabled one at a time
         // and corresponding segment data is output. 
                         
			//        a    
			//      ____
			//   f |    | b
			//     |_g__| 
			//   e |    | c
			//     |____| .h
			//       d
		   //	                          abcdefgh
			case (bcd_count_q)
			
			    0 : sevensegment_d <= 8'b00000010;
				 1 : sevensegment_d <= 8'b10011110;
				 2 : sevensegment_d <= 8'b00100100;
				 3 : sevensegment_d <= 8'b00001100;
				 4 : sevensegment_d <= 8'b10011000;
				 5 : sevensegment_d <= 8'b01001000;
				 6 : sevensegment_d <= 8'b01000000;
				 7 : sevensegment_d <= 8'b00011110;
				 8 : sevensegment_d <= 8'b00000000;
				 9 : sevensegment_d <= 8'b00011000;
				 default : sevensegment_d <= 8'b11111111;
			 endcase
		end
endmodule
