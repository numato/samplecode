`timescale 1ns / 1ps

module AC97Controller
// Parameter declared to control the volume.
#(parameter MasterVolume    = 5'd11,                    
            HPVolume        = 5'd11,                    
            LineInVolume    = 5'd11
 )(
    // Input from the AC97 Audio module and command module.
    input AC97SDI,
    input AC97BitClock,
    input [19:0] Register,
    input [19:0] command,
    input validate,
    
// Output for the AC97 Audio module. 
    output reg AC97SDO,
    output reg done,
    output reg AC97Sync
   );  

// Register and wire used for internal purpose.
reg [7:0] counter;
reg [3:0] f_cnt;
reg done;
reg state;
reg  previous_done;
reg [23:0] cmd;

wire [4:0] HP_vol;
wire [4:0] Master_vol;
wire [4:0] LineIn_vol;
    
// Volume control, more the value lesser will be the attenuation so the volume will be more. 
   assign HP_vol = 31-HPVolume;
   assign LineIn_vol = 31-LineInVolume;
   assign Master_vol = 31-MasterVolume;
   
//initial conditions for resting all the internal signals and also the AC97-Serial data out and Synchronization signal pins   
initial
begin
   done      <= 1'b1;
   AC97SDO   <= 1'b0;
   AC97Sync  <= 1'b0;
   counter   <= 8'h00;
   f_cnt     <=4'h0;
   done      <=1'b0;
 previous_done <=1'b0;
   state     <=4'h0;
end

// Monitor Bit clock.   
always @(posedge AC97BitClock) 
 begin
// Validate the frame , register and the command for LM4550     
      if ((counter >= 0) && (counter <= 15))
        case (counter[3:0])
          4'h0: AC97SDO  <= 1'b1;      
          4'h1: AC97SDO  <= done;   
          4'h2: AC97SDO  <= done;  
          default: AC97SDO <= 1'b0;
        endcase
// Serially output the register contained.         
      else if ((counter >= 16) && (counter <= 35))
        AC97SDO <=  Register[35-counter];
        
// Serially output the command for that register.
      else if ((counter >= 36) && (counter <= 55))
        AC97SDO <=  command[55-counter];

// When done PULLDOWN the SDO line
      else
        AC97SDO <= 1'b0;

// Generate the Sync signal for AC97 at 48 KHz and done signal for fetching next command.    
  if (counter == 255)
begin
     AC97Sync <= 1'b1;
     f_cnt<=f_cnt+1;
end     
else if (counter == 128)
begin
     done <= 1'b1;
end     
else if (counter == 15)
begin
     AC97Sync <= 1'b0;
 end      
else if (counter == 2)
begin
      done <= 1'b0;
 end      
counter <= counter+1;
end 

//Monitoring the Frame count signal
  always @(f_cnt)
     begin
     // verify whether the all the command is transferred serially to LM4550
       if (done && (!previous_done)) 
       begin
           previous_done = done;
       end
       case (f_cnt)
       4'h0:
       begin
        cmd = {8'h02,3'b000,Master_vol,3'b000,Master_vol};     // Control the Master Volume level
       end
       4'h1:
       begin
        cmd = {8'h04,3'b000,HP_vol,3'b000,HP_vol};            // Control the volume for the Headphone
       end
       4'h2:
       begin
        cmd ={8'h10,3'b000,5'b00000,3'b000,5'b00000};       // Control the volume for Line-in.
       end
       default:
       begin
        cmd = 24'hFC_0000; // Read vendor ID
       end
     endcase
   end
   
// Load the value of Register and the command for the register.  
   assign Register = {cmd[23:16],12'h000};
   assign command = {cmd[15:0],4'h0};


endmodule
