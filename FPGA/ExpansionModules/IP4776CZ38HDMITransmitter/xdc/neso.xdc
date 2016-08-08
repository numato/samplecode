#HDMI cable is connected to IP4776CZ38ExpansionModuleTransmitter
#On Board LED on Saturn Expansion Connector is OFF 
#IP4776CZ38ExpansionModuleTransmitter module is connected to header P8 & P10 of saturn expansion module
#Saturn expansion module is connected to right side of Neso board(kintex7)
#HOW TO CHECK PIN CONNECTION
        #IP4776CZ38ExpansionModuleTransmitter --> saturn expansion module --> Neso(Header P5) 
        
#####################################################################
#                          Clocks 100 MHz                            #
#####################################################################

set_property IOSTANDARD LVCMOS33 [get_ports {clk100}]
set_property PACKAGE_PIN F4 [get_ports {clk100}]; # Sch=CLK1

#####################################################################
#                         Input & Outputs                            #
#####################################################################
#set_property SLEW FAST [get_ports  {hdmi_tx_p[*]}];
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_p[*]}];

#set_property SLEW FAST [get_ports  {hdmi_tx_n[*]}];
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_n[*]}];

#####################################################################
#Header P8 & P10(expansion module right side) 
#####################################################################

set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_p[0]}]
set_property PACKAGE_PIN P15 [get_ports {hdmi_tx_p[0]}];          #   (D0+)

set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_p[1]}]
set_property PACKAGE_PIN K15 [get_ports {hdmi_tx_p[1]}];           #  (D1+)

set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_p[2]}]
set_property PACKAGE_PIN M16 [get_ports {hdmi_tx_p[2]}];           #  (D2+)

set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_clk_p}]
set_property PACKAGE_PIN N15 [get_ports {hdmi_tx_clk_p}];         #    (CK+)

set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_n[0]}]
set_property PACKAGE_PIN R15 [get_ports {hdmi_tx_n[0]}];            

set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_n[1]}]
set_property PACKAGE_PIN J15 [get_ports {hdmi_tx_n[1]}];          
         
 
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_n[2]}]
set_property PACKAGE_PIN M17 [get_ports {hdmi_tx_n[2]}];             

set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_clk_n}]
set_property PACKAGE_PIN N16 [get_ports {hdmi_tx_clk_n}];        
    
 
set_property IOSTANDARD LVCMOS33 [get_ports {hdmi_tx_rscl}]
set_property PACKAGE_PIN R18 [get_ports {hdmi_tx_rscl}];           # (scl)

set_property IOSTANDARD LVCMOS33 [get_ports {hdmi_tx_rsda}]
set_property PACKAGE_PIN R17 [get_ports {hdmi_tx_rsda}];           # (sda)

set_property IOSTANDARD LVCMOS33 [get_ports {hdmi_tx_hpd}]
set_property PACKAGE_PIN P17 [get_ports {hdmi_tx_hpd}];            # (hot)

set_property IOSTANDARD LVCMOS33 [get_ports {hdmi_tx_cec}]
set_property PACKAGE_PIN T18 [get_ports {hdmi_tx_cec}];           
 


