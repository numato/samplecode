`timescale 1ns / 1ps

// 16 X 2 LCD display module demo code
// Numato Lab
// http://www.numato.com
// http://www.numato.cc
// License : CC BY-SA (http://creativecommons.org/licenses/by-sa/2.0/)

module LCDExpansionModule(

  // Assuming 100MHz input clock. My need to adjust the counter below
  // if any other input frequency is used
    input Clk,
    
 // Register Select(rs), Enable(en), Read/Write(rw) and Data Pins of LCD  	
    output reg rs,en,rw,                                 
    output reg [3:0] LCD_out                             
     );

	 
// Specify the depth of block memory where the data and command are to be saved.
parameter Length=43;

// Intermediate register used internally                                     
reg [30:0]counter;                                       
integer pointer;                                         
reg count;             

 // Memory created to store the required data of 8 bits and two rs and rw signals                                  
wire [9:0]memory[0:Length-1];                  
         
// Implementation :
// 16 x 2 LCD that is liquid crystal display is used to display Alphanumeric and special Character.
// LCD here is made to work on 4 bits mode i.e, data/command pins (DB4-DB7), thus reducing the requirement of IO's. 
// For displaying this character on the LCD, initializing LCD is very important.That is done by passing the predefine initialization command to LCD. 
// Here the character which are to be displayed on the LCD are stored in the memory with the initialization command.
// The first two MSB bit's represent the status on rs and rw register respectively. 
// Whenever rs is '0' then it's a command for LCD and when '1' it's data that should be displayed on LCD.
// The rw pin is set to '0' for write operation and '1' for read operation.
                                                        
// Function Set: 4-bit, 2 Line, 5x7 Dots. 
assign	 memory[0]={2'b00,8'h28};
        
// Entry Mode.                       
assign	 memory[2]={2'b00,8'h0E};
 
// Display on Cursor on.                              
assign	 memory[1]={2'b00,8'h06}; 
      
// Clear Display (also clear DDRAM content).                        
assign	 memory[3]={2'b00,8'h01};
 
// The memory location in middle are kept empty so that the LCD is properly initialized and is ready to expect any data that is thrown to it. 
// Space that should appear on LCD.
assign	 memory[18]={2'b10," "};

// Shift the display right.
assign	 memory[19]={2'b00,8'h1C}; 

// Character that should be displayed on the LCD.
assign	 memory[20]={2'b10,"W"};
assign	 memory[21]={2'b10,"E"};
assign	 memory[22]={2'b10,"L"};
assign	 memory[23]={2'b10,"C"};
assign	 memory[24]={2'b10,"O"};
assign	 memory[25]={2'b10,"M"};
assign	 memory[26]={2'b10,"E"};
assign	 memory[27]={2'b10," "};
assign	 memory[28]={2'b10,"T"};
assign	 memory[29]={2'b10,"O"};

// Shift to second Line of LCD
assign	 memory[30]={2'b00,8'h40};

// Space that should appear on LCD.                              
assign	 memory[31]={2'b10," "};

// Shift the display right 
assign	 memory[32]={2'b00,8'h1C};                              

// Character that should be displayed on the LCD. 	 
assign	 memory[33]={2'b10,"N"};
assign	 memory[34]={2'b10,"U"};
assign	 memory[35]={2'b10,"M"};
assign	 memory[36]={2'b10,"A"};
assign	 memory[37]={2'b10,"T"};
assign	 memory[38]={2'b10,"O"};
assign	 memory[39]={2'b10," "};

assign	 memory[40]={2'b10,"L"};
assign	 memory[41]={2'b10,"A"};
assign	 memory[42]={2'b10,"B"};

// Scale down the the clock such that it satisfy the timing characteristics of LCD 
always @(posedge Clk)
 begin
     counter=counter+1'b1;
	 
// Check if all the memory location are covered.
// Once it's done disable the enable pin has no more data has to be send.	 
     if(pointer==Length+1)                                  
	    en = 'b0;
	  else
	    en=counter[15];                                          	  
 end                                                        

// Depending on the edge of the enable(en) signal send the command and data to LCD 
always @(negedge en)                                         
  begin
  
// MSB bit of a memory location is Register select(rs) signal    
     rs=memory[pointer][9];                                 

// Only the write operation is performed so permanently send active low signal to rw pin.	 
     rw=1'b0;                                               
	 
// First send the upper 4 bits data/command and then then lower 4 bits data/command.   	 
   if (!count)
	  begin
	    LCD_out=memory[pointer][7:4];
		 count=count+1'b1;
	  end
	else
	   begin
		  LCD_out=memory[pointer][3:0];
		  
// Once the data/command is send move to next location.  		  
		  pointer=pointer+1;
		  count=count+1'b1;
      end                                     
  end                                                      	  
endmodule                                                 
 
