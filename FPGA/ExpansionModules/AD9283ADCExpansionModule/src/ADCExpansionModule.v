`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.08.2016 14:33:25
// Design Name: 
// Module Name: ADCExpansionModule
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ADCExpansionModule(  
        input           CLK       ,
		input           RST_n     ,
		// ADC 9283 interface
		output           ADC_CLK   ,
		output           ADC_PWR   ,
		input      [7:0] ADC_Din   ,
		output reg [7:0] data_out
        );
        
    //Internal signals
    reg       clock     ;
    reg       pwr       ;
    reg [50:0]counter   ;
    wire [7:0]temp_data ;
    
    // Assignment of the final result on the output signal.    
    assign ADC_PWR      = pwr;
    assign ADC_CLK      = clock;
    //assign temp_data    = ADC_Din;
    
    // Counter logic to generate clock signal for ADC
    always@(posedge CLK)
    begin 
        if(!RST_n)
            counter <= 0;
        else
        begin
            counter <= counter + 1'b1;
            clock   <= counter[19];
        end
    end
    
    // Power down logic 
    always@(posedge clock)
    begin
        if(!RST_n)
            pwr <= 1'b1;
        else
            pwr <= 1'b0;
    end
    
    always@(posedge clock)
    begin
        if(!RST_n)
            data_out    <=  0;
        else if(~pwr)
            data_out    <=  ADC_Din;
        /*begin
            if((temp_data <= 'hFF) && (temp_data > 'h9A)) 
                data_out <= "F";
            else if ((temp_data <= 'h9A) && (temp_data > 'h66))
                data_out <= "E";
            else if ((temp_data <= 'h66) && (temp_data > 'h34))
                data_out <= "D";
            else if ((temp_data <= 'h34) && (temp_data > 'h1C)) 
                data_out <= "C";
            else if ((temp_data <= 'h1C) && (temp_data >= 'h0B)) 
                data_out <= "B";
            else if ((temp_data <= 'h0B) && (temp_data >= 'h00)) 
                data_out <= "A";
            else
                data_out <= "X";
        end*/
    end
endmodule
