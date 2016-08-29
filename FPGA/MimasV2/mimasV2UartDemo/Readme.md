	
#### MimasV2 UART RTL Sample Code
Numato Lab

https://www.numato.com

https://blog.numato.com

License : CC BY-SA ( http:-creativecommons.org/licenses/by-sa/2.0/ )

This package contains source, third party and other necessary files to build MimasV2 UART democode for the following boards.
1. MimasV2 Spartan6 FPGA development board.

ISE Webpack must be installed with proper license in either case.

###### Building the project using Xilinx ISE
Open the project file **`mimasV2UartDemo.xise`** using ISE. Right click on the "Generate Programming Files" process in the process window and select "Rerun all". You may need to add appropriate user constraints file to the project depending on which board you are building the project for. User Constraints Files for all supported boards can be found inside "ucf" folder.

When the build finishes successfuly a .bin and a .bit file should be created in the directory. 
	
Program by using .bin or .bit and observe output on your serial terminal at **`19200 baudrate`** (like putty, TeraTerm etc...,).
