
# TCL script for creating a microblaze based design for Skoll Kintex 7 FPGA Module

The provided TCL script `skollMicroblaze.tcl`, once run, will automatically create a new project in the directory from where it is run. It will then create a microblaze based design, synthesize and implement it. It will then create a bitstream and finally launch SDK once everything is done. User can then create their applications in SDK.

## Block Design IPs used:
1. Microblaze and associated peripherals
2. UART
3. DDR3

User can also add their own IPs after the script is run, by opening the created project in Vivado and editing the block design.

## Requirements:

1. Vivado Design Suite with SDK installed. (Preferred 2015.2 and above)
2. Provided Tcl Script
3. [Numato Skoll BSB files](/NumatoVivadoBSB) for Vivado installed (**Important!**) [How To: [NumatoVivadoBSB/README.md](/NumatoVivadoBSB/README.md) ]
4. Xilinx Platform Cable JTAG debugger (only used when actually programming the FPGA )
5. Skoll Kintex 7 FPGA Module (only needed to program your design to FPGA)

## Getting Started:

The provided tcl script can be run in either of two ways. User only need to use **any one** method

* **Method I** : Through Vivado TCL console
* **Method II**: Through Commandline

### Method I:Run tcl script through Vivado TCL console

You can go through the following steps to run the tcl script.
* **Step 1:** Start Vivado Design Suite. You can see a tcl console on the left bottom of Vivado Design Suite.  
* **Step 2:** Move the course to bottom of the line (i.e to 'type a tcl command here').  
* **Step 3:** Switch to your folder location where you are having tcl script using `pwd`, `cd` commands.(In author case it is "C:/Users/Numato_Pc/Desktop/skollMicroblaze").  
* **Step 4:** Once you changed your directory,Make sure that you are having tcl script in that location using 'dir' command.  
* **Step 5:** Run the script using the command `source filename.tcl` (In author case it is `source skollMicroblaze.tcl` ).
* **Step 6:** Now you can see the Vivado design suite started to create design as per the TCL script demand.Wait for some minute to complete the procedure including generating the bit stream.
* **Step 7:** If all the steps so far went as planned, you will have SDK window open. And, now you can your application programs like `Hello World` or `Memory Tests`.


### Method II: Run tcl script through Commandline

You can go through the following steps to run the tcl script.

* **Step 1:** (Windows 10) Start Vivado 2015.2 tcl shell through `Start button-->All apps-->Xilinx Design Tools-->Vivado 2015.2 Tcl Shell`. Now You can see a Vivado 2015.2 tcl shell commandline.
* **Step 2:** Switch to your folder location where you are having tcl script using `pwd`, `cd` commands.(In author case it is `C:/Users/Numato_Pc/Desktop/skollMicroblaze`).
* **Step 3:** Once you changed your directory, make sure that your tcl script is present in that location using `dir` command.
* **Step 4:** Run the script using the command `source filename.tcl` (In author case it is `source skollMicroblaze.tcl` ).
* **Step 5:** Now you can see the Vivado design suite started to create design as per the TCL script demand. Wait for some minute to complete the procedure including generating the bit stream.
* **Step 6:** If all the steps so far went as planned, you will have SDK window open. And, now you can your application programs like `Hello World` or `Memory Tests`.
