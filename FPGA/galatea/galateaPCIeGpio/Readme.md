# galateaPCIeGpio : PC communication with FPGA through PCI Express


  This package contains verilog source and other files necessary to build galateaPCIeGpio demo for Galatea PCI Express Spartan 6 FPGA Development Board.  
	http://numato.com/galatea-pci-express-spartan-6-fpga-development-board.html  

## Prerequisites
* Galatea PCI Express Spartan 6 FPGA Development
* Linux PC
* LED Jig
* Xilinx Platform Cable II JTAG


##  Development
  PCIe IP provided by Xilinx. It has been Enhanced for galataPCIeGpio project.  

## Building project
This project can be build using Xilinx ISE. ISE Webpack must be installed with proper license. Open the project file **galateaPCIeGpio.xise** using ISE. Right click on the "Generate Programming Files" process in the process window and select "Rerun all".

 ISE Webpack software and license is available for free at http://www.xilinx.com

## Program FPGA via SPI Flash
Galatea Spartan 6 FPGA Board features an on-board JTAG connector which facilitates easy reprogramming of on-board SPI flash through JTAG programmer like “XILINX Platform cable II USB”. Programming Galatea using JTAG requires “XILINX ISE iMPACT” software. To program the SPI flash, it is needed to generate a “.mcs” file which must be generated from the “.bit” file. Steps involving to generate mcs file is available at  

   https://docs.numato.com/doc/galatea-pci-express-spartan-6-fpga-development-board  
   After the successful completion of steps, a .mcs file should be created in the folder name bitstream.

## Software application

Hardware part is completed by programing FPGA. To check the output, You may need a application code. It is available at https://github.com/viyanumato/pcimem (source : https://github.com/billfarrow/pcimem), Then follow below steps.

1. Clone it to your local repository in your linux system.
2. Check PCIe device status using lspci -vv command on Linux terminal
3. Change directory to pcimem folder
4. Give write /read command
