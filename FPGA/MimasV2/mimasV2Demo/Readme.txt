Mimas V2 demo project
Numato Lab
http://www.numato.com
http://www.numato.cc
License : CC BY-SA (http://creativecommons.org/licenses/by-sa/2.0/)

This package contains source and other files necessary to build Mimas V2 demo for the following boards.

1. Mimas V2 Spartan3a development board.

ISE Webpack must be installed with proper license in either case.

Building the project using Xilinx ISE
   Open the project file mimasV2Demo.xise using ISE. Right click on the "Generate Programming Files" process in the process window and select "Rerun all". You may need to add appropriate user constraints file to the project depending on which board you are building the project for. User Constraints Files for all supported boards can be found inside "ucf" folder.

   
When the build finishes successfuly a .bin and a .bit file should be created in the directory.