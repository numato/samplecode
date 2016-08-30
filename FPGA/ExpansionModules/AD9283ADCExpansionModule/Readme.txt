AD9283 ADC Expansion Module demo code
Numato Lab
http://www.numato.com
http://blog.numato.com

This package contains source and other files necessary to build AD9283 ADC 
Expansion Module demo for the following boards.

1. Elbert V2 Spartan 3A FPGA Development Board
   http://numato.com/elbert-v2-spartan-3a-fpga-development-board.html 

2. Mimas V2 Spartan 6 Development Board
   http://numato.com/mimas-v2-spartan-6-fpga-development-board-with-ddr-sdram.html 

3. Skoll Kintex 7 FPGA Module
   https://numato.com/skoll-kintex-7-fpga-development-board/  
   
The AD9283 ADC Expansion Module used to test this code is available at
https://numato.com/ad9283-adc-expansion-module/

----------------------------------------------------------------------------------------------------------------
Spartan 3 & 6 Series:

There are two ways to build this project. Either using Xilinx ISE or running 
easy to use batch files. ISE Webpack must be installed with proper license in 
either case. By default the project is configured to build for XC6SLX9. To 
build for a different device you need to open AD9283ADCExpansionModule.xise
in ISE and change the device in project properties and rebuild.

1. Building the project using Xilinx ISE
   Open the project file AD9283ADCExpansionModule.xise using ISE. Right 
   click on the "Generate Programming Files" process in the process window and
   select "Rerun all". You may need to add appropriate user constraints file to
   the project depending on which board you are building the project for. User
   Constraints Files for all supported boards can be found inside "ucf" folder.
   
2. Building the project using Command Line Window
   Open command line window and navigate to the folder where the project files
   are located. Invoke the batch file and give necessary input asked. Make sure
   all build steps finish successfully. You will need to register the path to Xilinx
   build tools (usually C:\Xilinx\xx.xx\ISE_DS\ISE\bin\nt) in PATH environment
   variable for the batch files to work.
   
ISE Webpack software and license is available for free at http://www.xilinx.com
   
When the build finishes successfully a .bin and a .bit file should be created in
the folder name binary.

----------------------------------------------------------------------------------------------------------------
Kintex 7 Series:

There is a "AD9283ADCExpansionModule.xpr" vivado project file. Just open it by double
clicking. By default the project is configured for Skoll. Click "Generate Bitstream"
and choose Yes in any subsequent dialog windows. 

----------------------------------------------------------------------------------------------------------------

Sr No.  Numato Lab's FPGA Board    Header Used

1       Elbert V2 *   		    P1-P6
2	Mimas V2                    P9-P8  	       
3       Skoll(IO Expansion on P5)   P12-P6

*  RXI pin of FT232RL breakout Module (http://numato.com/ft232rl-breakout-module/) connected to 7th pin of Header P4 on ElbertV2.


