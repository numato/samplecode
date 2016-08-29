#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
# This file is a .xdc for AD9763 DAC Expansion Modules on Saturn Expansion Connector            #
# To use it in your project :                                                                   #
# * Remove or comment the lines corresponding to unused pins                                    #
# * Rename the used signals according to the your project                                       #
#																								#
#	*DAC Expansion module with Neso Kintex 7 Board.                                            #
#	*Input is from DAC Expansion module															#
#	*DAC Expansion module (P2, P3 & P4)is connected to Saturn Expansion module 					#
#    Headers (P6, P7 & P11)																		#
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#


#############################################################################
#                               clk_100MHz                                  #
#############################################################################

set_property -dict { PACKAGE_PIN "F4"    IOSTANDARD LVCMOS33 } [get_ports { clk }];
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

#####################################################################
#                              RST                                  #
#####################################################################

set_property -dict { PACKAGE_PIN "U11"    IOSTANDARD LVCMOS33 } [get_ports { rst_n }];

################### INPUTs & OUTPUTs #######################################

##############################################################################
#                                 SELECT LINE      						 #
##############################################################################

set_property -dict { PACKAGE_PIN "F15"   IOSTANDARD LVCMOS33 PULLUP TRUE  } [get_ports { sel_n[3]  }]; 
set_property -dict { PACKAGE_PIN "F16"   IOSTANDARD LVCMOS33 PULLUP TRUE } [get_ports { sel_n[2]  }];  
set_property -dict { PACKAGE_PIN "L15"   IOSTANDARD LVCMOS33 PULLUP TRUE } [get_ports { sel_n[1]  }]; 
set_property -dict { PACKAGE_PIN "L16"   IOSTANDARD LVCMOS33  PULLUP TRUE} [get_ports { sel_n[0]  }]; 
   


#############################################################################
#                       DAC Header P4 ,P3,P2                                #
#############################################################################




set_property -dict { PACKAGE_PIN "T16"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp2[7] }];  #INP17
set_property -dict { PACKAGE_PIN "R16"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp2[6] }];  #INP16
set_property -dict { PACKAGE_PIN "U13"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp2[5] }];    #INP15
set_property -dict { PACKAGE_PIN "T13"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp2[4] }];    #INP14
set_property -dict { PACKAGE_PIN "R11"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp2[3] }];   #INP13
set_property -dict { PACKAGE_PIN "R10"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp2[2] }];   #INP12
set_property -dict { PACKAGE_PIN "V12"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp2[1] }];   #INP11
set_property -dict { PACKAGE_PIN "U12"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp2[0] }];   #INP10


set_property -dict { PACKAGE_PIN "V15"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp2[9] }];  #INP19
set_property -dict { PACKAGE_PIN "V16"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp2[8] }];  #INP18
set_property -dict { PACKAGE_PIN "U17"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_wrt2 }];
set_property -dict { PACKAGE_PIN "U18"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_wrt1 }];
set_property -dict { PACKAGE_PIN "N17"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_clk1 }];
set_property -dict { PACKAGE_PIN "P18"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_clk2 }];
set_property -dict { PACKAGE_PIN "R12"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp1[0] }];  #INP0
set_property -dict { PACKAGE_PIN "R13"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp1[1] }];  #INP1


set_property -dict { PACKAGE_PIN "J14"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp1[9] }];  #INP9
set_property -dict { PACKAGE_PIN "H15"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp1[8] }];  #INP8
set_property -dict { PACKAGE_PIN "H16"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp1[7] }];  #INP7
set_property -dict { PACKAGE_PIN "G16"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp1[6] }];  #INP6
set_property -dict { PACKAGE_PIN "H17"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp1[5] }];  #INP5
set_property -dict { PACKAGE_PIN "G17"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp1[4] }];  #INP4
set_property -dict { PACKAGE_PIN "N14"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp1[3] }]; #INP3
set_property -dict { PACKAGE_PIN "P14"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp1[2] }]; #INP2

