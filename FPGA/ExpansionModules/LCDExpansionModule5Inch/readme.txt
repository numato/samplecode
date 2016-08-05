5 Inch LCD Expansion Module demo code
Numato Lab
http://www.numato.com
http://www.numato.cc

This package contains source and other files necessary to build 5 Inch LCD Expansion Module
demo for the following boards.

1. Elbert V2 Development Board
   http://numato.com/elbert-v2-spartan-3a-fpga-development-board.html

2. Mimas V2 Spartan 6 Development Board
   http://numato.com/mimas-v2-spartan-6-fpga-development-board-with-ddr-sdram.html  

3. Saturn Spartan 6 Module with LPDDR
   http://numato.com/saturn-spartan-6-fpga-development-board-with-ddr-sdram.html
   
4. Neso Artix 7 FPGA Module
   https://numato.com/neso-artix-7-fpga-development-board/

5. Skoll Kintex 7 FPGA Module
   https://numato.com/skoll-kintex-7-fpga-development-board/   
   
The 5 Inch LCD Expansion Module used to test this code is available at
http://numato.com/fpga-boards/expansion-modules.html

----------------------------------------------------------------------------------------------------------------
Spartan 3 & 6 Series:

IO Breakout Boards make it easier to attach expansion modules to Saturn. 
Please see links to IO Breakout boards below.
http://numato.com/fpga-boards/expansion-modules/io-breakout-module-for-saturn.html
   
There are two ways to build this project. Either using Xilinx ISE or running 
easy to use batch files. ISE Webpack must be installed with proper license in 
either case. By default the project is configured to build for XC6SLX9. To 
build for a different device you need to open LCDExpansionModule5Inch.xise
in ISE and change the device in project properties and rebuild.

1. Building the project using Xilinx ISE
   Open the project file LCDExpansionModule5Inch.xise using ISE. Right 
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
Artix and Kintex 7 Series:

There is a "LCDExpansionModule5Inch.xpr" vivado project file. Just open it by double
clicking. By default the project is configured for Skoll. Click "Generate Bitstream"
and choose Yes in any subsequent dialog windows. For building for Neso, change the
FPGA device to XC7A100T-CSG324 from "Project Settings" and set the "Neso" constraints 
set to "Active". You may now select "Generate Bitstream" to build the project.

----------------------------------------------------------------------------------------------------------------
Sr No.  Numato Lab's FPGA Board    Header Used
        
1          Elbert V2                  P4-P2-P6-P1
2          Mimas*                     -
3          Mimas V2                   P6-P7-P8-P9
4          Saturn LX16**              P12-P7-P8-P11
5          Saturn LX45**              P12-P7-P8-P11
6          Waxwing Carrier            -
7          Waxwing Dev Board          -
8         Neso(IO Expansion on P5)   P12-P6-P7-P11
9         Skoll(IO Expansion on P5)  P12-P6-P7-P11

*  Mimas Expansion Connector connected to Header P1 of Mimas.
** Saturn Expansion Connector connected to Header P2 of Saturn Spartan 6 Development Board.