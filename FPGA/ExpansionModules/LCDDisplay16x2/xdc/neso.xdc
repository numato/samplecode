 # On Board LED on Saturn Expansion Connector is OFF 
 # Alphanumeric LCD Display Expansion Module (Headers P1) is connected to header P12 of IO Breakout Module for Neso
 # IO Breakout Module for Saturn is connected to right side of Neso
 
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#                               clk_100MHz                                  #
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#

set_property -dict { PACKAGE_PIN "F4"    IOSTANDARD LVCMOS33 } [get_ports { Clk }];

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#            LCDExpansion Module Header P1   - IO Breakout Module P12     #
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#

set_property -dict { PACKAGE_PIN "F15"   IOSTANDARD LVCMOS33 } [get_ports { rw }];
set_property -dict { PACKAGE_PIN "F16"   IOSTANDARD LVCMOS33 } [get_ports { rs }];
set_property -dict { PACKAGE_PIN "L15"   IOSTANDARD LVCMOS33 } [get_ports { en }];
set_property -dict { PACKAGE_PIN "L16"   IOSTANDARD LVCMOS33 } [get_ports { LCD_out[0] }];
set_property -dict { PACKAGE_PIN "K13"   IOSTANDARD LVCMOS33 } [get_ports { LCD_out[1] }];
set_property -dict { PACKAGE_PIN "J13"   IOSTANDARD LVCMOS33 } [get_ports { LCD_out[2] }];
set_property -dict { PACKAGE_PIN "L18"   IOSTANDARD LVCMOS33 } [get_ports { LCD_out[3] }];