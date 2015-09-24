`timescale 1ns / 1ps

// LM4550 Audio Expansion module demo code
// Numato Lab
// http://www.numato.com
// http://www.numato.cc

module LM4550AudioExpansionModule

// Parameter define to control the volume. More the value more will be the volume. 
#(parameter MasterVolume    = 5'd22,                    
            HPVolume        = 5'd22,                    
            LineInVolume    = 5'd22
 )  
(
  // Assume the input clock of 100 MHz with active high reset.
   input CLK,
   input Rst, 
   
 //Interface to LM4550 AC97 CODEC
    input AC97SDI,                                        // Serial data line from LM4550 Audio Expansion module.
    input AC97BitClock,                                   // Clock from LM4550 Audio Expansion Module. (12.288 MHz)
    output reg AC97Rstn,                                  // Active Low reset for LM4550 Audio Expansion Module.
    output AC97SDO,                                       // Serial data to LM4550 Audio Expansion Module.
    output AC97Sync                                       // Sync signal for LM4550 Audio Expansion Module.(48 KHz)  
);  

// Implementation:
// LM4550 Audio Expansion module provide high quality sample rate Conversion from 4 kHz to 48kHz in 1 Hz increments.
// It is boarded with two input namely Line-in and Mic-in and two output Headphone out and Line-out. It has the crystal 
// of frequency 24.576 MHz which gives the Bit clock of 12.288 MHz. This clock along with the Sync signal is use to synchronize 
// the data flow from and to the module.For the purpose of initializing LM4550 command are passed to the register. The command 
// with register is better explained in national Semiconductor datasheet for LM4550. 
 
 // Register and wire are used for internal purpose.
   reg [9:0] rst_count;
    
 // Monitor input clock and the reset signal. Whenever the reset is triggered wait for
 // 1us or more before the command are send to LM4550.
 
   always @(posedge CLK or posedge Rst) begin
      if (Rst) begin
         AC97Rstn = 1'b0;
         rst_count = 0;
      end else if (rst_count == 200)
        AC97Rstn = 1'b1;
      else
        rst_count = rst_count + 1;
   end

   wire [7:0] Register;
   wire [15:0] command;
   wire validate;
   wire done;

  // Instantiate the Controller which controls the flow of data from and to the module.   
   AC97Controller controller( .AC97SDO(AC97SDO), 
                              .AC97SDI(AC97SDI), 
                              .AC97Sync(AC97Sync), 
                              .AC97BitClock(AC97BitClock), 
                              .Rst(Rst),
                              .done(done),
                              .Register(Register), 
                              .command(command), 
                              .validate(validate));
 
  // Instantiate command module which send necessary command to initialize LM4550.
   AC97Commands    #(.MasterVolume(MasterVolume),
                    .HPVolume(HPVolume),
                    .LineInVolume(LineInVolume)
                    )
  command_data     (.CLK(CLK),
                    .Rst(Rst),          
                    .done(done), 
                    .Register(Register), 
                    .command(command),
                    .validate(validate));

endmodule
