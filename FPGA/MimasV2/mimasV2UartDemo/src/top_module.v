`timescale 1ns / 1ps

//--------------------------------------------------------------------//
// MimasV2 UART RTL Sample Code
// Numato Lab
// http://www.numato.com
// http://www.numato.cc
// License : CC BY-SA (http:-creativecommons.org/licenses/by-sa/2.0/)
//--------------------------------------------------------------------//

module top_module(      
    output     tx,
	input      clk,        
	input      reset
);
                 
    // Signals for UART submodule 
    reg        rd_uart   = 1'b0;
    reg        wr_uart   = 1'b0;
    reg        rx        = 1'b0;
    reg  [7:0] data_in   = 0   ;   
    wire [7:0] data_out        ;    
    wire       full            ;
    wire       empty           ;
   
    // Counter to set the time delay
    reg [26:0] timer_cnt      = 1'b0;    
    reg        timer_timeout  = 1'b0;
    
    // Parameters for memory
    parameter   WIDTH     =   8 ,
                DEPTH     =   16,
                ADDR      =   4 ;
                 
    // Ram & address
    reg  [ADDR-1:0] address   = 0   ;
    wire [WIDTH-1:0] arr_mem [DEPTH-1:0];
    
    // Assuming clk frequency 100MHz
    parameter CLK_FREQ = 100000000;
    
    // Assigning data to ram memory 
    assign  arr_mem[0]  =   "H";
    assign  arr_mem[1]  =   "e";
    assign  arr_mem[2]  =   "l";        
    assign  arr_mem[3]  =   "l";         
    assign  arr_mem[4]  =   "o";        
    assign  arr_mem[5]  =   " ";         
    assign  arr_mem[6]  =   "W";        
    assign  arr_mem[7]  =   "o";         
    assign  arr_mem[8]  =   "r";         
    assign  arr_mem[9]  =   "l";        
    assign  arr_mem[10] =   "d";        
    assign  arr_mem[11] =   "!";         
    assign  arr_mem[12] =   "\n";      //  new line character
    assign  arr_mem[13] =   "\r";      //  carriage return character 
    
    // Timer logic 
    always@(posedge clk)
    begin
        if(reset)
            timer_cnt   <=  0;
        else if(timer_cnt == CLK_FREQ-1) // 99999999 = 1s , we are setting some delay to display string next time. 
        begin
            timer_timeout    <=  1'b1;
            timer_cnt        <=  0;
        end
        else if(address == 13)
            timer_timeout    <=  0; 
        else
            timer_cnt   <=  timer_cnt + 1'b1;
    end
    
    // writing data to uart and incrementing address for memory 
    always@(posedge clk)
    begin
        if(reset)
        begin
            data_in     <=  0;
            address     <=  0;
        end
        else if(timer_timeout && ~full)
        begin
            wr_uart     <=  1'b1;
            data_in     <=  arr_mem[address];
            address     <=  address + 1'b1;
            if(address == 13)
                address <=  0;
        end
        else
            wr_uart     <=  1'b0;
    end                                             
    
    // Instantiation of uart module
    // DIVISOR = 326 for 19200 baudrate, 100MHz sys clock
    uart #(     .DIVISOR		(9'd326),   
                .DVSR_BIT		(4'd9)	,
                .Data_Bits		(4'd8)	,
                .FIFO_Add_Bit	(3'd4)
    ) uart (    .clk			(clk),
                .rd_uart		(rd_uart)	,
                .reset			(reset)		,	
                .rx				(rx)		,
                .w_data			(data_in)	,
                .wr_uart		(wr_uart)	,
                .r_data			(data_out)	,
                .rx_empty		(empty)		,
                .tx				(tx)		,
                .tx_full		(full)
           );             
endmodule
