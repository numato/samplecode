create_project -force skollMicroblaze skollMicroblaze -part xc7k70tfbg484-1
set_property board_part numato.com:skoll:part0:1.0 [current_project]

create_bd_design "skollMicroblaze"

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.1 clk_wiz_0
apply_board_connection -board_interface "sys_clock" -ip_intf "clk_wiz_0/clock_CLK_IN1" -diagram "skollMicroblaze"
endgroup

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:2.3 mig_7series_0
apply_board_connection -board_interface "ddr3_sdram" -ip_intf "mig_7series_0/mig_ddr_interface" -diagram "skollMicroblaze"
endgroup

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0
apply_board_connection -board_interface "usb_uart" -ip_intf "axi_uartlite_0/UART" -diagram "skollMicroblaze"
endgroup

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:9.5 microblaze_0
endgroup

startgroup
set_property -dict [list CONFIG.CLKOUT2_USED {true} CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {200.000} CONFIG.RESET_TYPE {ACTIVE_LOW} CONFIG.MMCM_DIVCLK_DIVIDE {1} CONFIG.MMCM_CLKOUT1_DIVIDE {5} CONFIG.NUM_OUT_CLKS {2} CONFIG.RESET_PORT {resetn} CONFIG.CLKOUT2_JITTER {114.829} CONFIG.CLKOUT2_PHASE_ERROR {98.575}] [get_bd_cells clk_wiz_0]
endgroup

delete_bd_objs [get_bd_nets sys_clk_i_1] [get_bd_ports sys_clk_i]
connect_bd_net [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins mig_7series_0/sys_clk_i]
save_bd_design

apply_bd_automation -rule xilinx.com:bd_rule:microblaze -config {local_mem "16KB" ecc "None" cache "8KB" debug_module "Debug Only" axi_periph "Enabled" axi_intc "0" clk "/clk_wiz_0/clk_out1 (100 MHz)" }  [get_bd_cells microblaze_0]

startgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/microblaze_0 (Cached)" Clk "Auto" }  [get_bd_intf_pins mig_7series_0/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/microblaze_0 (Periph)" Clk "Auto" }  [get_bd_intf_pins axi_uartlite_0/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:board -config {Board_Interface "reset" }  [get_bd_pins mig_7series_0/sys_rst]
apply_bd_automation -rule xilinx.com:bd_rule:board -config {Board_Interface "reset" }  [get_bd_pins rst_clk_wiz_0_100M/ext_reset_in]
endgroup
connect_bd_net -net [get_bd_nets reset_1] [get_bd_ports reset] [get_bd_pins clk_wiz_0/resetn]
save_bd_design

make_wrapper -files [get_files skollMicroblaze/skollMicroblaze.srcs/sources_1/bd/skollMicroblaze/skollMicroblaze.bd] -top
add_files -norecurse skollMicroblaze/skollMicroblaze.srcs/sources_1/bd/skollMicroblaze/hdl/skollMicroblaze_wrapper.v
update_compile_order -fileset sources_1
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
launch_runs impl_1 -to_step write_bitstream -jobs 2
wait_on_run impl_1

file mkdir skollMicroblaze/skollMicroblaze.sdk
file copy -force skollMicroblaze/skollMicroblaze.runs/impl_1/skollMicroblaze_wrapper.sysdef skollMicroblaze/skollMicroblaze.sdk/skollMicroblaze_wrapper.hdf
launch_sdk -workspace skollMicroblaze/skollMicroblaze.sdk -hwspec skollMicroblaze/skollMicroblaze.sdk/skollMicroblaze_wrapper.hdf
