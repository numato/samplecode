 # On Board LED on Saturn Expansion Connector is OFF 
 # Seven Segment Expansion Module (Headers P1 , P2 ) is connected to header P10 & P8  of IO Breakout Module for skoll
 # IO Breakout Module for Saturn is connected to right side of skoll
 
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#                               clk_100MHz                                  #
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#

set_property -dict { PACKAGE_PIN "E11"    IOSTANDARD LVCMOS33 } [get_ports { clk }];

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#                               Reset                                       #
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#

set_property -dict { PACKAGE_PIN "E9"    IOSTANDARD LVCMOS33 } [get_ports { rst_n }];    # P9 pin of 6

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#  			Seven Segment Display Header P2 - IO Breakout Module P8  	    #
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#

set_property -dict { PACKAGE_PIN "N17"   IOSTANDARD LVCMOS33 } [get_ports { enable[3] }];
set_property -dict { PACKAGE_PIN "P16"   IOSTANDARD LVCMOS33 } [get_ports { enable[2] }];
set_property -dict { PACKAGE_PIN "AB20"   IOSTANDARD LVCMOS33 } [get_ports { enable[1] }];
set_property -dict { PACKAGE_PIN "AA19"   IOSTANDARD LVCMOS33 } [get_ports { enable[0] }];

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#            Seven Segment Display Header P1   - IO Breakout Module P10     #
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#

set_property -dict { PACKAGE_PIN "Y17"   IOSTANDARD LVCMOS33 } [get_ports { sevensegment[7] }];    #a
set_property -dict { PACKAGE_PIN "W17"   IOSTANDARD LVCMOS33 } [get_ports { sevensegment[6] }];    #b
set_property -dict { PACKAGE_PIN "AB15"   IOSTANDARD LVCMOS33 } [get_ports { sevensegment[5] }];   #c
set_property -dict { PACKAGE_PIN "Y14"   IOSTANDARD LVCMOS33 } [get_ports { sevensegment[4] }];    #d
set_property -dict { PACKAGE_PIN "W14"   IOSTANDARD LVCMOS33 } [get_ports { sevensegment[3] }];    #e
set_property -dict { PACKAGE_PIN "R17"   IOSTANDARD LVCMOS33 } [get_ports { sevensegment[2] }];    #f
set_property -dict { PACKAGE_PIN "P17"   IOSTANDARD LVCMOS33 } [get_ports { sevensegment[1] }];    #g
set_property -dict { PACKAGE_PIN "AB16"   IOSTANDARD LVCMOS33 } [get_ports { sevensegment[0] }];   #dot