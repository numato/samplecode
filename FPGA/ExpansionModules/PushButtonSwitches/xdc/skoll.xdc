set_property CFGBVS VCCO [current_design];
set_property CONFIG_VOLTAGE 3.3 [current_design];

set_property -dict { PACKAGE_PIN "E11"    IOSTANDARD LVCMOS33 } [get_ports {Clk}];

## IO Expansion Module connected to right side of Skoll

# Port P12 of IO Expansion Module
set_property -dict { PACKAGE_PIN "T18"    IOSTANDARD LVCMOS33 } [get_ports { LED[0] }];
set_property -dict { PACKAGE_PIN "U18"    IOSTANDARD LVCMOS33 } [get_ports { LED[1] }];
set_property -dict { PACKAGE_PIN "U17"    IOSTANDARD LVCMOS33 } [get_ports { LED[2] }];
set_property -dict { PACKAGE_PIN "V18"    IOSTANDARD LVCMOS33 } [get_ports { LED[3] }];
set_property -dict { PACKAGE_PIN "AA21"   IOSTANDARD LVCMOS33 } [get_ports { LED[4] }];
set_property -dict { PACKAGE_PIN "AB22"   IOSTANDARD LVCMOS33 } [get_ports { LED[5] }];
set_property -dict { PACKAGE_PIN "AA18"   IOSTANDARD LVCMOS33 } [get_ports { LED[6] }];
set_property -dict { PACKAGE_PIN "AB18"   IOSTANDARD LVCMOS33 } [get_ports { LED[7] }];

# Port P7 of IO Expansion Module
set_property -dict { PACKAGE_PIN "AA20"   IOSTANDARD LVCMOS33 } [get_ports { Switch[0] }];
set_property -dict { PACKAGE_PIN "AB21"   IOSTANDARD LVCMOS33 } [get_ports { Switch[1] }];
set_property -dict { PACKAGE_PIN "R16"    IOSTANDARD LVCMOS33 } [get_ports { Switch[2] }];
set_property -dict { PACKAGE_PIN "T16"    IOSTANDARD LVCMOS33 } [get_ports { Switch[3] }];
set_property -dict { PACKAGE_PIN "T15"    IOSTANDARD LVCMOS33 } [get_ports { Switch[4] }];
set_property -dict { PACKAGE_PIN "U15"    IOSTANDARD LVCMOS33 } [get_ports { Switch[5] }];
set_property -dict { PACKAGE_PIN "J16"    IOSTANDARD LVCMOS33 } [get_ports { Switch[6] }];
set_property -dict { PACKAGE_PIN "J17"    IOSTANDARD LVCMOS33 } [get_ports { Switch[7] }];
