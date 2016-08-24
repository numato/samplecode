	
#### ElbertV2 UART RTL Sample Code
Numato Lab

https://www.numato.com

https://blog.numato.com

License : CC BY-SA ( http:-creativecommons.org/licenses/by-sa/2.0/ )

This package contains source, third party and other necessary files to build ElbertV2 UART demo code for the following boards.

1. ElbertV2 Spartan3a FPGA development board.
   http://numato.com/elbert-v2-spartan-3a-fpga-development-board.html
   
2. FT232RL breakout Module 
   http://numato.com/ft232rl-breakout-module/

ISE Webpack must be installed with proper license in either case.

###### Building the project using Xilinx ISE
Open the project file **`elbertV2UartDemo.xise`** using ISE. Right click on the "Generate Programming Files" process in the process window and select "Rerun all". You may need to add appropriate user constraints file to the project depending on which board you are building the project for. User Constraints Files for all supported boards can be found inside "ucf" folder.

RXI pin of FT232RL breakout Module connected to 7th pin of Header P4 on ElbertV2. In constraint file, connect "tx" signal to "P130" (Header_P4[7]).  
 
When the build finishes successfully a .bin and a .bit file should be created in the directory. 
	
Program by using .bin or .bit and observe output on your serial terminal at **`9600 baudrate`** (like putty, TeraTerm etc...,).


