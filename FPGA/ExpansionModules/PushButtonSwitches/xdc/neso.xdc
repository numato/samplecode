set_property CFGBVS VCCO [current_design];
set_property CONFIG_VOLTAGE 3.3 [current_design];

set_property -dict { PACKAGE_PIN "F4"    IOSTANDARD LVCMOS33 } [get_ports {Clk}];

## IO Expansion Module connected to right side of Neso

# Port P12 of IO Expansion Module
set_property -dict { PACKAGE_PIN "F15"    IOSTANDARD LVCMOS33 } [get_ports { LED[0] }];
set_property -dict { PACKAGE_PIN "F16"    IOSTANDARD LVCMOS33 } [get_ports { LED[1] }];
set_property -dict { PACKAGE_PIN "L15"    IOSTANDARD LVCMOS33 } [get_ports { LED[2] }];
set_property -dict { PACKAGE_PIN "L16"    IOSTANDARD LVCMOS33 } [get_ports { LED[3] }];
set_property -dict { PACKAGE_PIN "K13"    IOSTANDARD LVCMOS33 } [get_ports { LED[4] }];
set_property -dict { PACKAGE_PIN "J13"    IOSTANDARD LVCMOS33 } [get_ports { LED[5] }];
set_property -dict { PACKAGE_PIN "L18"    IOSTANDARD LVCMOS33 } [get_ports { LED[6] }];
set_property -dict { PACKAGE_PIN "M18"    IOSTANDARD LVCMOS33 } [get_ports { LED[7] }];

# Port P7 of IO Expansion Module
set_property -dict { PACKAGE_PIN "R12"    IOSTANDARD LVCMOS33 } [get_ports { Switch[0] }];
set_property -dict { PACKAGE_PIN "R13"    IOSTANDARD LVCMOS33 } [get_ports { Switch[1] }];
set_property -dict { PACKAGE_PIN "N17"    IOSTANDARD LVCMOS33 } [get_ports { Switch[2] }];
set_property -dict { PACKAGE_PIN "P18"    IOSTANDARD LVCMOS33 } [get_ports { Switch[3] }];
set_property -dict { PACKAGE_PIN "U17"    IOSTANDARD LVCMOS33 } [get_ports { Switch[4] }];
set_property -dict { PACKAGE_PIN "U18"    IOSTANDARD LVCMOS33 } [get_ports { Switch[5] }];
set_property -dict { PACKAGE_PIN "V15"    IOSTANDARD LVCMOS33 } [get_ports { Switch[6] }];
set_property -dict { PACKAGE_PIN "V16"    IOSTANDARD LVCMOS33 } [get_ports { Switch[7] }];
