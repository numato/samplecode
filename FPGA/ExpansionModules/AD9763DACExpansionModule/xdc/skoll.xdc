#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
# This file is a .xdc for AD9763 DAC Expansion Modules on Saturn Expansion Connector            #
# To use it in your project :                                                                   #
# * Remove or comment the lines corresponding to unused pins                                    #
# * Rename the used signals according to the your project                                       #
#																								#
#	*DAC Expansion module with Skoll Kintex 7 Board.                                            #
#	*Input is from DAC Expansion module															#
#	*DAC Expansion module (P2, P3 & P4)is connected to Saturn Expansion module 					#
#    Headers (P6, P7 & P11)																		#
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#


#############################################################################
#                               clk_100MHz                                  #
#############################################################################

set_property -dict { PACKAGE_PIN "E11"    IOSTANDARD LVCMOS33 } [get_ports { clk }];
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

#####################################################################
#                              RST                                  #
#####################################################################

set_property -dict { PACKAGE_PIN "N17"    IOSTANDARD LVCMOS33 } [get_ports { rst_n }];

################### INPUTs & OUTPUTs #######################################

##############################################################################
#                                 SELECT LINES    						 #
##############################################################################

set_property -dict { PACKAGE_PIN "T18"   IOSTANDARD LVCMOS33 PULLUP TRUE } [get_ports { sel_n[3]  }]; 
set_property -dict { PACKAGE_PIN "U18"   IOSTANDARD LVCMOS33 PULLUP TRUE } [get_ports { sel_n[2]  }];  
set_property -dict { PACKAGE_PIN "U17"   IOSTANDARD LVCMOS33 PULLUP TRUE } [get_ports { sel_n[1]  }]; 
set_property -dict { PACKAGE_PIN "V18"   IOSTANDARD LVCMOS33 PULLUP TRUE } [get_ports { sel_n[0]  }]; 
   


#############################################################################
#                       DAC Header P4 ,P3,P2                                #
#############################################################################




set_property -dict { PACKAGE_PIN "AA15"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp2[7] }];  #INP17
set_property -dict { PACKAGE_PIN "AA14"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp2[6] }];  #INP16
set_property -dict { PACKAGE_PIN "H8"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp2[5] }];    #INP15
set_property -dict { PACKAGE_PIN "H9"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp2[4] }];    #INP14
set_property -dict { PACKAGE_PIN "V17"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp2[3] }];   #INP13
set_property -dict { PACKAGE_PIN "U16"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp2[2] }];   #INP12
set_property -dict { PACKAGE_PIN "W15"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp2[1] }];   #INP11
set_property -dict { PACKAGE_PIN "V15"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp2[0] }];   #INP10


set_property -dict { PACKAGE_PIN "J16"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp2[9] }];  #INP19
set_property -dict { PACKAGE_PIN "J17"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp2[8] }];  #INP18
set_property -dict { PACKAGE_PIN "T15"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_wrt2 }];
set_property -dict { PACKAGE_PIN "U15"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_wrt1 }];
set_property -dict { PACKAGE_PIN "R16"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_clk1 }];
set_property -dict { PACKAGE_PIN "T16"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_clk2 }];
set_property -dict { PACKAGE_PIN "AA20"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp1[0] }];  #INP0
set_property -dict { PACKAGE_PIN "AB21"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp1[1] }];  #INP1


set_property -dict { PACKAGE_PIN "R21"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp1[9] }];  #INP9
set_property -dict { PACKAGE_PIN "R22"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp1[8] }];  #INP8
set_property -dict { PACKAGE_PIN "T20"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp1[7] }];  #INP7
set_property -dict { PACKAGE_PIN "U20"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp1[6] }];  #INP6
set_property -dict { PACKAGE_PIN "V19"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp1[5] }];  #INP5
set_property -dict { PACKAGE_PIN "W19"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp1[4] }];  #INP4
set_property -dict { PACKAGE_PIN "AB17"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp1[3] }]; #INP3
set_property -dict { PACKAGE_PIN "AA16"   IOSTANDARD LVCMOS33 } [get_ports { ad9763_dac_dbp1[2] }]; #INP2

