 # On Board LED on Saturn Expansion Connector is OFF 
 # Alphanumeric LCD Display Expansion Module (Headers P1 ) is connected to header P12 of IO Breakout Module for skoll
 # IO Breakout Module for Saturn is connected to right side of skoll
 
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#                               clk_100MHz                                  #
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#

set_property -dict { PACKAGE_PIN "E11"    IOSTANDARD LVCMOS33 } [get_ports { Clk }];

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#            LCDExpansion Module Header P1   - IO Breakout Module P12     #
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#

set_property -dict { PACKAGE_PIN "T18"   IOSTANDARD LVCMOS33 } [get_ports { rw }];
set_property -dict { PACKAGE_PIN "U18"   IOSTANDARD LVCMOS33 } [get_ports { rs }];
set_property -dict { PACKAGE_PIN "U17"   IOSTANDARD LVCMOS33 } [get_ports { en }];
set_property -dict { PACKAGE_PIN "V18"   IOSTANDARD LVCMOS33 } [get_ports { LCD_out[0] }];
set_property -dict { PACKAGE_PIN "AA21"   IOSTANDARD LVCMOS33 } [get_ports { LCD_out[1] }];
set_property -dict { PACKAGE_PIN "AB22"   IOSTANDARD LVCMOS33 } [get_ports { LCD_out[2] }];
set_property -dict { PACKAGE_PIN "AA18"   IOSTANDARD LVCMOS33 } [get_ports { LCD_out[3] }];
