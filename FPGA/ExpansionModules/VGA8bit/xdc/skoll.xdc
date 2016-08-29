 # On Board LED on Saturn Expansion Connector is OFF 
 # VGA Expansion Module (Headers P1 , P2 ) is connected to header P12 & P6  of IO Breakout Module for Skoll
 # IO Breakout Module for Saturn is connected to right side of Skoll
 
 
 #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
 #                               100 MHz clock                               #
 #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
                
 set_property -dict { PACKAGE_PIN "E11"    IOSTANDARD LVCMOS33 } [get_ports { Clk }];
 set_property CFGBVS VCCO [current_design]
 set_property CONFIG_VOLTAGE 3.3 [current_design]
 
 #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
 #       VGA Expansion Header P1 - IO Breakout Module Header P12             #
 #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
  
 set_property -dict { PACKAGE_PIN "T18"    IOSTANDARD LVCMOS33 } [get_ports { Red[1]   }];
 set_property -dict { PACKAGE_PIN "U18"    IOSTANDARD LVCMOS33 } [get_ports { Red[2]   }];
 set_property -dict { PACKAGE_PIN "V18"    IOSTANDARD LVCMOS33 } [get_ports { Red[0]   }];
 set_property -dict { PACKAGE_PIN "U17"    IOSTANDARD LVCMOS33 } [get_ports { Green[2] }];
 set_property -dict { PACKAGE_PIN "AA21"   IOSTANDARD LVCMOS33 } [get_ports { Green[1] }];
 set_property -dict { PACKAGE_PIN "AB22"   IOSTANDARD LVCMOS33 } [get_ports { Green[0] }];
 set_property -dict { PACKAGE_PIN "AA18"   IOSTANDARD LVCMOS33 } [get_ports { Blue[2]  }];
 set_property -dict { PACKAGE_PIN "AB18"   IOSTANDARD LVCMOS33 } [get_ports { Blue[1]  }];
 
 #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
 #      VGA Expansion Header P2 - IO Breakout Module Header P6               #
 #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
 
 set_property -dict { PACKAGE_PIN "R21"   IOSTANDARD LVCMOS33 } [get_ports { vsync }];
 set_property -dict { PACKAGE_PIN "R22"   IOSTANDARD LVCMOS33 } [get_ports { hsync }];
 