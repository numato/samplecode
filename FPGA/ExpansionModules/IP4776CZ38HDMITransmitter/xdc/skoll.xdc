#HDMI cable is connected to IP4776CZ38ExpansionModuleTransmitter
#On Board LED on Saturn Expansion Connector is OFF 
#IP4776CZ38ExpansionModuleTransmitter module is connected to header P12 & P6 of saturn expansion module
#Saturn expansion module is connected to right side of Skoll board(kintex7)
#HOW TO CHECK PIN CONNECTION
        #IP4776CZ38ExpansionModuleTransmitter --> saturn expansion module --> Skoll(Header P5) 
        
#####################################################################
#                          Clocks 100 MHz                            #
#####################################################################

set_property IOSTANDARD LVCMOS33 [get_ports {clk100}]
set_property PACKAGE_PIN E11 [get_ports {clk100}]; # Sch=CLK1

#####################################################################
#                         Input & Outputs                            #
#####################################################################
#set_property SLEW FAST [get_ports  {hdmi_tx_p[*]}];
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_p[*]}];

#set_property SLEW FAST [get_ports  {hdmi_tx_n[*]}];
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_n[*]}];

#####################################################################
#Header P12 & P6(expansion module right side) 
#####################################################################

set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_p[0]}]
set_property PACKAGE_PIN AA21 [get_ports {hdmi_tx_p[0]}];          # Sch =  IO_L9P_T1_DQS_13    (D0+)

set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_p[1]}]
set_property PACKAGE_PIN U17 [get_ports {hdmi_tx_p[1]}];           # Sch = IO_L5P_T0_13         (D1+)

set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_p[2]}]
set_property PACKAGE_PIN T18 [get_ports {hdmi_tx_p[2]}];           # Sch = IO_L3P_T0_DQS_13     (D2+)

set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_clk_p}]
set_property PACKAGE_PIN AA18 [get_ports {hdmi_tx_clk_p}];         # Sch = IO_L15P_T2_DQS_13    (CK+)

set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_n[0]}]
set_property PACKAGE_PIN AB22 [get_ports {hdmi_tx_n[0]}];          # Sch = IO_L9N_T1_DQS_13     

set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_n[1]}]
set_property PACKAGE_PIN V18 [get_ports {hdmi_tx_n[1]}];           # Sch = IO_L5N_T0_13
         
 
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_n[2]}]
set_property PACKAGE_PIN U18 [get_ports {hdmi_tx_n[2]}];           # Sch = IO_L3N_T0_DQS_13     

set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_clk_n}]
set_property PACKAGE_PIN AB18 [get_ports {hdmi_tx_clk_n}];         # Sch = IO_L15N_T2_DQS_13
    
 
set_property IOSTANDARD LVCMOS33 [get_ports {hdmi_tx_rscl}]
set_property PACKAGE_PIN R21 [get_ports {hdmi_tx_rscl}];           # Sch = IO_L24P_T3_A01_D17_14(scl)

set_property IOSTANDARD LVCMOS33 [get_ports {hdmi_tx_rsda}]
set_property PACKAGE_PIN V20 [get_ports {hdmi_tx_rsda}];           # Sch = IO_L11P_T1_SRCC_13   (sda)

set_property IOSTANDARD LVCMOS33 [get_ports {hdmi_tx_hpd}]
set_property PACKAGE_PIN T20 [get_ports {hdmi_tx_hpd}];            # Sch = IO_L6P_T0_13         (hot)

set_property IOSTANDARD LVCMOS33 [get_ports {hdmi_tx_cec}]
set_property PACKAGE_PIN R22 [get_ports {hdmi_tx_cec}];            # Sch = IO_L24N_T3_A00_D16_14
 


