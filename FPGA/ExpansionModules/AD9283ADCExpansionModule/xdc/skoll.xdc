set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

#####################################################################
#                          Clock 100 MHz                            #
#####################################################################
set_property -dict { PACKAGE_PIN "E11"   IOSTANDARD LVCMOS33 } [get_ports { CLK }];

set_property -dict { PACKAGE_PIN "K22"   IOSTANDARD LVCMOS33 PULLUP TRUE} [get_ports { RST_n }];
set_property -dict { PACKAGE_PIN "U22"   IOSTANDARD LVCMOS33 } [get_ports { tx }];

########################################################################
#       ADC9283ExpansionModule on P12 & P6 Headers of IO breakout      #
########################################################################
set_property -dict { PACKAGE_PIN "T18"   IOSTANDARD LVCMOS33 } [get_ports { ADC_Din[6] }];
set_property -dict { PACKAGE_PIN "U18"   IOSTANDARD LVCMOS33 } [get_ports { ADC_Din[7] }];
set_property -dict { PACKAGE_PIN "U17"   IOSTANDARD LVCMOS33 } [get_ports { ADC_Din[4] }];
set_property -dict { PACKAGE_PIN "V18"   IOSTANDARD LVCMOS33 } [get_ports { ADC_Din[5] }];
set_property -dict { PACKAGE_PIN "AA21"   IOSTANDARD LVCMOS33 } [get_ports { ADC_Din[2] }];
set_property -dict { PACKAGE_PIN "AB22"   IOSTANDARD LVCMOS33 } [get_ports { ADC_Din[3] }];
set_property -dict { PACKAGE_PIN "AA18"   IOSTANDARD LVCMOS33 } [get_ports { ADC_Din[0] }];
set_property -dict { PACKAGE_PIN "AB18"   IOSTANDARD LVCMOS33 } [get_ports { ADC_Din[1] }];

set_property -dict { PACKAGE_PIN "T20"   IOSTANDARD LVCMOS33 } [get_ports { ADC_PWR }];
set_property -dict { PACKAGE_PIN "U20"   IOSTANDARD LVCMOS33 } [get_ports { ADC_CLK }];

