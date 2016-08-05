
 #On Board LED on Saturn Expansion Connector is OFF 
#5Inch LCD TFT Expansion Module (Headers P6 , P5 , P4 , P3) is connected to header P12 , P6 , P7 & P11 of saturn expansion module
#Saturn expansion module is connected to right side of Skoll board(kintex7)
#HOW TO CHECK PIN CONNECTION :5Inch LCD TFT Expansion Module --> saturn expansion module --> Skoll(Header P5) 
        

#############clk_100MHz####################        
set_property -dict { PACKAGE_PIN "E11"    IOSTANDARD LVCMOS33 } [get_ports { clk }];
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
        

#######RST#################

set_property -dict { PACKAGE_PIN "N17"    IOSTANDARD LVCMOS33 } [get_ports { rst_n }];



##### Inputs & Outputs ##################

######LCD Header P3#######

set_property -dict { PACKAGE_PIN "AA15"   IOSTANDARD LVCMOS33 } [get_ports { Red[4] }];
set_property -dict { PACKAGE_PIN "AA14"   IOSTANDARD LVCMOS33 } [get_ports { Red[5] }];
set_property -dict { PACKAGE_PIN "H8"   IOSTANDARD LVCMOS33 } [get_ports { Red[2] }];
set_property -dict { PACKAGE_PIN "H9"   IOSTANDARD LVCMOS33 } [get_ports { Red[3] }];
set_property -dict { PACKAGE_PIN "V17"   IOSTANDARD LVCMOS33 } [get_ports { Red[0] }];
set_property -dict { PACKAGE_PIN "U16"   IOSTANDARD LVCMOS33 } [get_ports { Red[1] }];
set_property -dict { PACKAGE_PIN "W15"   IOSTANDARD LVCMOS33 } [get_ports { D_ON }];

######LCD Header P4#######

set_property -dict { PACKAGE_PIN "AA20"   IOSTANDARD LVCMOS33 } [get_ports { Green[1] }];
set_property -dict { PACKAGE_PIN "AB21"   IOSTANDARD LVCMOS33 } [get_ports { Green[2] }];
set_property -dict { PACKAGE_PIN "T16"   IOSTANDARD LVCMOS33 } [get_ports { D_CLK }];
set_property -dict { PACKAGE_PIN "U15"   IOSTANDARD LVCMOS33 } [get_ports { Green[0] }];
set_property -dict { PACKAGE_PIN "J16"   IOSTANDARD LVCMOS33 } [get_ports { Red[6] }];
set_property -dict { PACKAGE_PIN "J17"   IOSTANDARD LVCMOS33 } [get_ports { Red[7] }];

######LCD Header P5#######

set_property -dict { PACKAGE_PIN "R21"   IOSTANDARD LVCMOS33 } [get_ports { Blue[1] }];
set_property -dict { PACKAGE_PIN "R22"   IOSTANDARD LVCMOS33 } [get_ports { Blue[2] }];
set_property -dict { PACKAGE_PIN "T20"   IOSTANDARD LVCMOS33 } [get_ports { Green[7] }];
set_property -dict { PACKAGE_PIN "U20"   IOSTANDARD LVCMOS33 } [get_ports { Blue[0] }];
set_property -dict { PACKAGE_PIN "V19"   IOSTANDARD LVCMOS33 } [get_ports { Green[5] }];
set_property -dict { PACKAGE_PIN "W19"   IOSTANDARD LVCMOS33 } [get_ports { Green[6] }];
set_property -dict { PACKAGE_PIN "AA16"   IOSTANDARD LVCMOS33 } [get_ports { Green[3] }];
set_property -dict { PACKAGE_PIN "AB17"   IOSTANDARD LVCMOS33 } [get_ports { Green[4] }];

######LCD Header P6#######

set_property -dict { PACKAGE_PIN "T18"   IOSTANDARD LVCMOS33 } [get_ports { V_Sync }];
set_property -dict { PACKAGE_PIN "U18"   IOSTANDARD LVCMOS33 } [get_ports { D_EN }];
set_property -dict { PACKAGE_PIN "U17"   IOSTANDARD LVCMOS33 } [get_ports { Blue[7] }];
set_property -dict { PACKAGE_PIN "V18"   IOSTANDARD LVCMOS33 } [get_ports { H_Sync }];
set_property -dict { PACKAGE_PIN "AA21"   IOSTANDARD LVCMOS33 } [get_ports { Blue[5] }];
set_property -dict { PACKAGE_PIN "AB22"   IOSTANDARD LVCMOS33 } [get_ports { Blue[6] }];
set_property -dict { PACKAGE_PIN "AA18"   IOSTANDARD LVCMOS33 } [get_ports { Blue[3] }];
set_property -dict { PACKAGE_PIN "AB18"   IOSTANDARD LVCMOS33 } [get_ports { Blue[4] }];