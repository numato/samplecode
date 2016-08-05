 # On Board LED on Saturn Expansion Connector is OFF 
 # VGA Expansion Module (Headers P1 , P2 ) is connected to header P12 & P6  of IO Breakout Module for Neso
 # IO Breakout Module for Saturn is connected to right side of Neso
 
 
 #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
 #                               100 MHz clock                               #
 #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
                
 set_property -dict { PACKAGE_PIN "F4"    IOSTANDARD LVCMOS33 } [get_ports { Clk }];
 set_property CFGBVS VCCO [current_design]
 set_property CONFIG_VOLTAGE 3.3 [current_design]
 
 #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
 #       VGA Expansion Header P1 - IO Breakout Module Header P12             #
 #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
  
 set_property -dict { PACKAGE_PIN "F15"    IOSTANDARD LVCMOS33 } [get_ports { Red[1]   }];
 set_property -dict { PACKAGE_PIN "F16"    IOSTANDARD LVCMOS33 } [get_ports { Red[2]   }];
 set_property -dict { PACKAGE_PIN "L16"    IOSTANDARD LVCMOS33 } [get_ports { Red[0]   }];
 set_property -dict { PACKAGE_PIN "L15"    IOSTANDARD LVCMOS33 } [get_ports { Green[2] }];
 set_property -dict { PACKAGE_PIN "K13"    IOSTANDARD LVCMOS33 } [get_ports { Green[1] }];
 set_property -dict { PACKAGE_PIN "J13"    IOSTANDARD LVCMOS33 } [get_ports { Green[0] }];
 set_property -dict { PACKAGE_PIN "L18"    IOSTANDARD LVCMOS33 } [get_ports { Blue[2]  }];
 set_property -dict { PACKAGE_PIN "M18"    IOSTANDARD LVCMOS33 } [get_ports { Blue[1]  }];
 
 #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
 #      VGA Expansion Header P2 - IO Breakout Module Header P6               #
 #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
 
 set_property -dict { PACKAGE_PIN "J14"   IOSTANDARD LVCMOS33 } [get_ports { vsync }];
 set_property -dict { PACKAGE_PIN "H15"   IOSTANDARD LVCMOS33 } [get_ports { hsync }];
 