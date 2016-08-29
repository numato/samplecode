# Module is connected to Header P6 of saturn expansion modle.
#
set_property IOSTANDARD LVCMOS33 [get_ports {CLK}];
set_property PACKAGE_PIN E11 [get_ports {CLK}]; # Sch=CLK1
set_property SLEW FAST [get_ports {CLK}]


set_property PACKAGE_PIN U17 [get_ports {AC97SDI}]; #IO_L6P_T0_13 Sch=GPIO-119
set_property IOSTANDARD LVCMOS33 [get_ports {AC97SDI}];
set_property SLEW FAST [get_ports {AC97SDI}]
set_property DRIVE 8 [get_ports {AC97SDI}]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {AC97BitClock}]
set_property PACKAGE_PIN V18 [get_ports {AC97BitClock}]; #IO_L6N_T0_VREF_13 Sch=GPIO-118
set_property IOSTANDARD LVCMOS33 [get_ports {AC97BitClock}];
set_property SLEW FAST [get_ports {AC97BitClock}]
set_property DRIVE 8 [get_ports {AC97BitClock}]

set_property PACKAGE_PIN AA21 [get_ports {AC97Rstn}]; #IO_L12P_T1_MRCC_13 Sch=GPIO-121
set_property IOSTANDARD LVCMOS33 [get_ports {AC97Rstn}];
set_property SLEW FAST [get_ports {AC97Rstn}]
set_property DRIVE 8 [get_ports {AC97Rstn}]

set_property PACKAGE_PIN U18 [get_ports {AC97SDO}]; #IO_L24N_T3_A00_D16_14 Sch=GPIO-122
set_property IOSTANDARD LVCMOS33 [get_ports {AC97SDO}];
set_property SLEW FAST [get_ports {AC97SDO}]
set_property DRIVE 8 [get_ports {AC97SDO}]

set_property PACKAGE_PIN AB22 [get_ports {AC97Sync}]; #IO_L12N_T1_MRCC_13 Sch=GPIO-120
set_property IOSTANDARD LVCMOS33 [get_ports {AC97Sync}];
set_property SLEW FAST [get_ports {AC97Sync}]
set_property DRIVE 8 [get_ports {AC97Sync}]


