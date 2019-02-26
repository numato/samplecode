Mimas A7 UART Migen Code
Numato Lab

https://www.numato.com

https://blog.numato.com

License : CC BY-SA ( http:-creativecommons.org/licenses/by-sa/2.0/ )

This package contains source, bitstream to build UART democode in Migen for the following boards.

Mimas Artix 7 FPGA development board.

Tools Required:

1. Vivado 2018.2 or later
2. Python 3.7
3. Mimas Artix 7 FPGA Development Board or a similar board.
4. Tenagra or XC3SProg.


To run the Migen code you need to install Migen. Once Migen is installed, copy the Migen code from the src and save it as a Python file and run this Python file.

After running the code, in the directory where the Python file is saved, you will find a folder named “build”. 
In this build folder, you will get .bit and .bin file. Using Tenagra or XC3SProg, program the .bit or .bin file to Mimas A7 FPGA Board. 
To observe the output, open any serial terminal (PuTTY, Tera Term etc) to the corresponding COM Port of the board and set its BaudRate to 115200. 
After the board is programmed, you will observe the following output in serial terminal

