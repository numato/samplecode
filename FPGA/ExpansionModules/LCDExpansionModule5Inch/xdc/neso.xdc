
 
# Saturn_IO_Expansion is connectd to the right side Header of the Neso board (P5 Header)
# Saturn_IO_Expansion LED module is off
#P6,P5,P4,P3 Headers of LCD_Expansion module is connected to P12,P6,P7,P11 Headers of Saturun_IO_Expansion module
#HOW TO CHECK PIN CONNECTION :5Inch LCD TFT Expansion Module --> saturn expansion module --> Neso(Header P5) 

#Clock 100 MHz                            

set_property IOSTANDARD LVCMOS33 [get_ports {clk}];
set_property PACKAGE_PIN F4 [get_ports {clk}];

set_property SLEW FAST [get_ports {rst_n}];
set_property PULLUP TRUE  [get_ports {rst_n}];
set_property DRIVE 8 [get_ports {rst_n}];
set_property IOSTANDARD LVCMOS33 [get_ports {rst_n}];
set_property PACKAGE_PIN D15 [get_ports {rst_n}]; # reset_n is connected to pin 19 of P5 header of Neso.(Reset can be connected to any free pin available in P5 header of Neso.)


set_property SLEW FAST [get_ports {D_EN}];
set_property DRIVE 8 [get_ports {D_EN}];
set_property IOSTANDARD LVCMOS33 [get_ports {D_EN}];
set_property PACKAGE_PIN F16 [get_ports {D_EN}]; 

set_property SLEW FAST [get_ports {D_ON}];
set_property DRIVE 8 [get_ports {D_ON}];
set_property IOSTANDARD LVCMOS33 [get_ports {D_ON}];
set_property PACKAGE_PIN E16 [get_ports {D_ON}]; #E16  it is connected to pin 22 of P5 header of Neso.(D_ON Signal can be connected to any free pin available in P5 header of Neso.)

set_property SLEW FAST [get_ports {D_CLK}];
set_property DRIVE 8 [get_ports {D_CLK}];
set_property IOSTANDARD LVCMOS33 [get_ports {D_CLK}];
set_property PACKAGE_PIN P18 [get_ports {D_CLK}]; 


set_property SLEW FAST [get_ports {H_Sync}];
set_property DRIVE 8 [get_ports {H_Sync}];
set_property IOSTANDARD LVCMOS33 [get_ports {H_Sync}];
set_property PACKAGE_PIN L16 [get_ports {H_Sync}]; 

set_property SLEW FAST [get_ports {V_Sync}];
set_property DRIVE 8 [get_ports {V_Sync}];
set_property IOSTANDARD LVCMOS33 [get_ports {V_Sync}];
set_property PACKAGE_PIN F15 [get_ports {V_Sync}]; 

set_property SLEW FAST [get_ports  {Red[*]}];
set_property DRIVE 8 [get_ports {Red[*]}];
set_property IOSTANDARD LVCMOS33 [get_ports {Red[*]}];
set_property PACKAGE_PIN R11 [get_ports {Red[0]}]; 
set_property PACKAGE_PIN R10 [get_ports {Red[1]}]; 
set_property PACKAGE_PIN U13  [get_ports {Red[2]}]; 
set_property PACKAGE_PIN T13  [get_ports {Red[3]}];
set_property PACKAGE_PIN T16  [get_ports {Red[4]}];
set_property PACKAGE_PIN R16  [get_ports {Red[5]}];
set_property PACKAGE_PIN V15  [get_ports {Red[6]}];
set_property PACKAGE_PIN V16  [get_ports {Red[7]}];

set_property SLEW FAST [get_ports  {Green[*]}];
set_property DRIVE 8 [get_ports {Green[*]}];
set_property IOSTANDARD LVCMOS33 [get_ports {Green[*]}];
set_property PACKAGE_PIN U18 [get_ports {Green[0]}]; 
set_property PACKAGE_PIN R12 [get_ports {Green[1]}]; 
set_property PACKAGE_PIN R13  [get_ports {Green[2]}]; 
set_property PACKAGE_PIN N14  [get_ports {Green[3]}];
set_property PACKAGE_PIN P14  [get_ports {Green[4]}];
set_property PACKAGE_PIN H17  [get_ports {Green[5]}];
set_property PACKAGE_PIN G17  [get_ports {Green[6]}];
set_property PACKAGE_PIN H16  [get_ports {Green[7]}];

set_property SLEW FAST [get_ports  {Blue[*]}];
set_property DRIVE 8 [get_ports {Blue[*]}];
set_property IOSTANDARD LVCMOS33 [get_ports {Blue[*]}];
set_property PACKAGE_PIN G16 [get_ports {Blue[0]}]; 
set_property PACKAGE_PIN J14 [get_ports {Blue[1]}]; 
set_property PACKAGE_PIN H15  [get_ports {Blue[2]}]; 
set_property PACKAGE_PIN L18  [get_ports {Blue[3]}];
set_property PACKAGE_PIN M18  [get_ports {Blue[4]}];
set_property PACKAGE_PIN K13  [get_ports {Blue[5]}];
set_property PACKAGE_PIN J13  [get_ports {Blue[6]}];
set_property PACKAGE_PIN L15  [get_ports {Blue[7]}];





