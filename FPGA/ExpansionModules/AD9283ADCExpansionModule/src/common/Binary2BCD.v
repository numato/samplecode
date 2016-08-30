`timescale 1ns / 1ps
 
module Binary2BCD(	
				input			[7:0]	data_o			,
				output reg 	[3:0]	hundreds_data	, 
				output reg 	[3:0]	tens_data		, 
				output reg 	[3:0]	units_data		
				);
   
   // Internal variable for storing bits
   reg [19:0] shift;
   integer i;
   
   always @(data_o)
   begin
      // Clear previous number and store new number in shift register
      shift[19:8] = 0;
      shift[7:0] = data_o;
      
      // Loop eight times
      for (i=0; i<8; i=i+1) begin
         if (shift[11:8] >= 5)
            shift[11:8] = shift[11:8] + 3;
            
         if (shift[15:12] >= 5)
            shift[15:12] = shift[15:12] + 3;
            
         if (shift[19:16] >= 5)
            shift[19:16] = shift[19:16] + 3;
         
         // Shift entire register left once
         shift = shift << 1;
      end
      
      // Push decimal numbers to output
      hundreds_data 	= shift[19:16];
      tens_data     	= shift[15:12];
      units_data     = shift[11:8];
   end
	
endmodule