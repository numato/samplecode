/////////////////////////////////////////////////////////////////////////
// AD9283 ADC Expansion Module                                         //
// Numato Lab                                                          //
// https://www.numato.com                                              //
// https://www.numato.cc                                               //
// Design Name : ADCExpansionModule                                    //
// Description : Generating ADC clock and power down signals           //
/////////////////////////////////////////////////////////////////////////                                              

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
    
    // Assignment of the final result on the output signal.    
    assign ADC_PWR      = pwr;
    assign ADC_CLK      = clock;
    
    // Counter logic to generate clock signal for ADC
    always@(posedge CLK)
    begin 
        if(!RST_n)
            counter <= 0;
        else
        begin
            counter <= counter + 1'b1;
            clock   <= counter[16];
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
    end
endmodule
