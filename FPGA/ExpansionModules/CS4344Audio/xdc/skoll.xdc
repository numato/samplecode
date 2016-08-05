# CS4344 Audio Expansion Module  module.
# On Board LED on Saturn Expansion Connector is ON because it is connected left side of skoll board 
# Module is connected to Header P12 of saturn expansion modle.
#
set_property IOSTANDARD LVCMOS33 [get_ports {Clk}];
set_property PACKAGE_PIN E11 [get_ports {Clk}]; # Sch=CLK1
set_property SLEW FAST [get_ports {Clk}]

set_property PACKAGE_PIN C13 [get_ports {SDIN}]; #IO_L33P_0
set_property IOSTANDARD LVCMOS33 [get_ports {SDIN}];
set_property SLEW FAST [get_ports {SDIN}]
set_property DRIVE 8 [get_ports {SDIN}]

set_property PACKAGE_PIN B16 [get_ports {SCLK}]; #IO_L33P_0
set_property IOSTANDARD LVCMOS33 [get_ports {SCLK}];
set_property SLEW FAST [get_ports {SCLK}]
set_property DRIVE 8 [get_ports {SCLK}]

set_property PACKAGE_PIN C17 [get_ports {LRCK}]; #IO_L33P_0
set_property IOSTANDARD LVCMOS33 [get_ports {LRCK}];
set_property SLEW FAST [get_ports {LRCK}]
set_property DRIVE 8 [get_ports {LRCK}]

set_property PACKAGE_PIN B18 [get_ports {MCLK}]; #IO_L33P_0
set_property IOSTANDARD LVCMOS33 [get_ports {MCLK}];
set_property SLEW FAST [get_ports {MCLK}]
set_property DRIVE 8 [get_ports {MCLK}]


 