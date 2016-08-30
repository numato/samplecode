/////////////////////////////////////////////////////////////////////////
// AD9283 ADC Expansion Module demo code                               //
// Numato Lab                                                          //
// https://www.numato.com                                              //
// https://www.numato.cc                                               //
/////////////////////////////////////////////////////////////////////////

module top_module(  
         input           CLK    	  ,
         input           RST_n     ,
         // ADC 9283 interface
         output           ADC_CLK   ,
         output           ADC_PWR   ,
         input      [7:0] ADC_Din   ,
         output           tx			
    );
  
      wire [7:0] data_o;
  // Signals for UART submodule 
      reg        rd_uart   = 1'b0;
      reg        wr_uart   = 1'b0;
      reg        rx        = 1'b0;
      reg  [7:0] data_in   = 0   ;   
      wire [7:0] data_out        ;    
      wire       full            ;
      wire       empty           ;
     
  // Counter to set the time delay
      reg [26:0] timer_cnt      = 0;    
      reg        timer_timeout  = 1'b0;
      
  // Assuming clk frequency 12MHz
      parameter CLK_FREQ = 12000000;
      
  // Signals for Binary to BCD Conversion submodule 
      wire   [3:0]  hundreds_data;
      wire   [3:0]  tens_data    ;
      wire   [3:0]  units_data   ;
      
  // Signal for converting to string
      reg [8*3-1:0] String;  
      
  // Parameters for memory
      parameter   WIDTH     =   8  ,
                  DEPTH     =   16 ,
                  ADDR      =   4  ;
                       
  // Ram & address
      reg  [ADDR-1:0] address   = 0   ;
      wire [WIDTH-1:0] arr_mem [DEPTH-1:0];
		
  // Instantiation of ADCExpansionModule
      ADCExpansionModule ADC (   
                    .CLK           (CLK)       ,
                    .RST_n         (RST_n)     ,
                    // ADC 9283 interface
                    .ADC_CLK       (ADC_CLK)   ,
                    .ADC_PWR       (ADC_PWR)   ,
                    .ADC_Din       (ADC_Din)   ,
                    .data_out      (data_o)
                    );
						  
  // Instantiation of Binary to BCD Conversion submodule            
      Binary2BCD B2B(					
                .data_o             (data_o)       ,                       
                // Signals for converting data_out of ADC to BCD
                .hundreds_data      (hundreds_data),
                .tens_data	         (tens_data)    ,
                .units_data         (units_data)
                );
  
  // Converting BCD to String format               
      always@(*)
      begin                
				String	= {4'h3, hundreds_data, 4'h3, tens_data, 4'h3, units_data};
      end 		
     
  // Assigning data to ram memory 
      assign  arr_mem[0]  =   "A"           ;
      assign  arr_mem[1]  =   "D"           ;
      assign  arr_mem[2]  =   "C"           ;
      assign  arr_mem[3]  =   " "           ;
      assign  arr_mem[4]  =   "D"           ;
      assign  arr_mem[5]  =   "a"           ;
      assign  arr_mem[6]  =   "t"           ;
      assign  arr_mem[7]  =   "a"           ;
		assign  arr_mem[8]  =   ":"			  ;
      assign  arr_mem[9]  =   " "           ;
      assign  arr_mem[10] =   String[23:16] ;
      assign  arr_mem[11] =   String[15:8]  ;
      assign  arr_mem[12] =   String[7:0]   ;
      assign  arr_mem[13] =   "\n"          ;      //  new line character
      assign  arr_mem[14] =   8'hD          ;      //  carriage return character
    
  // Timer logic 
      always@(posedge CLK)
      begin
        if(~RST_n)
            timer_cnt   <=  0;
        else if(timer_cnt == CLK_FREQ - 1) // 11999999 = 1s , we are setting some delay to display string next time. 
        begin
            timer_timeout    <=  1'b1;
            timer_cnt        <=  0;
        end
        else if(address == 14)
            timer_timeout    <=  1'b0;    
        else
            timer_cnt   <=  timer_cnt + 1'b1;       
      end
          
  // writing data to uart and incrementing address for memory 
      always@(posedge CLK)
      begin
        if(~RST_n)
        begin
            data_in     <=  0;
            wr_uart     <=  1'b0;
        end
        else if(timer_timeout && ~full)
        begin
            wr_uart     <=  1'b1;
            data_in     <=  arr_mem[address];
            address     <=  address + 1'b1;
            if(address == 14)
                address <=  0;                 
        end
        else
            wr_uart     <=  1'b0;
      end             
                         
  // Instantiation of uart module
  // DIVISOR = 79 for 9600 baudrate, 12MHz sys clock
      uart #(    .DIVISOR        (7'd79),
                  .DVSR_BIT      (4'd7)  ,
                  .Data_Bits     (4'd8)  ,
                  .FIFO_Add_Bit  (3'd4)
       ) uart (   .clk           (CLK)			,
                  .rd_uart       (rd_uart)	,
                  .reset         (~RST_n)		,
                  .rx            (rx)			,
                  .w_data        (data_in)	,
                  .wr_uart       (wr_uart)	,
                  .r_data        (data_out)	,
                  .rx_empty      (empty)		,
                  .tx            (tx)			,
                  .tx_full       (full)
                  );                                                   
endmodule
