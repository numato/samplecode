set_location_assignment PIN_G19 -to mem_a[14]
set_location_assignment PIN_C22 -to mem_a[13]
set_location_assignment PIN_N18 -to mem_a[12]
set_location_assignment PIN_E20 -to mem_a[11]
set_location_assignment PIN_J22 -to mem_a[10]
set_location_assignment PIN_E22 -to mem_a[9]
set_location_assignment PIN_D22 -to mem_a[8]
set_location_assignment PIN_E21 -to mem_a[6]
set_location_assignment PIN_F19 -to mem_a[5]
set_location_assignment PIN_K15 -to mem_a[3]
set_location_assignment PIN_K14 -to mem_a[0]
set_location_assignment PIN_G22 -to mem_a[7]
set_location_assignment PIN_C20 -to mem_a[4]
set_location_assignment PIN_F22 -to mem_a[2]
set_location_assignment PIN_D19 -to mem_a[1]


set_location_assignment PIN_N22 -to mem_ba[2]
set_location_assignment PIN_V21 -to mem_ba[1]
set_location_assignment PIN_J21 -to mem_ba[0]
set_location_assignment PIN_T22 -to mem_cas_n[0]
set_location_assignment PIN_D18 -to mem_ck[0]
set_location_assignment PIN_E18 -to mem_ck_n[0]
set_location_assignment PIN_W20 -to mem_cke[0]
set_location_assignment PIN_P21 -to mem_cs_n[0]
set_location_assignment PIN_N19 -to mem_dm[1]
set_location_assignment PIN_T18 -to mem_dm[0]
set_location_assignment PIN_N20 -to mem_dq[15]
set_location_assignment PIN_L19 -to mem_dq[14]
set_location_assignment PIN_M15 -to mem_dq[13]
set_location_assignment PIN_L18 -to mem_dq[12]
set_location_assignment PIN_M14 -to mem_dq[11]
set_location_assignment PIN_M20 -to mem_dq[10]
set_location_assignment PIN_M18 -to mem_dq[9]
set_location_assignment PIN_L20 -to mem_dq[8]
set_location_assignment PIN_P20 -to mem_dq[7]
set_location_assignment PIN_P15 -to mem_dq[6]
set_location_assignment PIN_T19 -to mem_dq[5]
set_location_assignment PIN_R15 -to mem_dq[4]
set_location_assignment PIN_R20 -to mem_dq[3]
set_location_assignment PIN_P14 -to mem_dq[2]
set_location_assignment PIN_P19 -to mem_dq[1]
set_location_assignment PIN_R14 -to mem_dq[0]
set_location_assignment PIN_L14 -to mem_dqs[1]
set_location_assignment PIN_R18 -to mem_dqs[0]
set_location_assignment PIN_L15 -to mem_dqs_n[1]
set_location_assignment PIN_P18 -to mem_dqs_n[0]
set_location_assignment PIN_W19 -to mem_odt[0]
set_location_assignment PIN_T21 -to mem_ras_n[0]
set_location_assignment PIN_G20 -to mem_reset_n
set_location_assignment PIN_Y21 -to mem_we_n[0]
set_location_assignment PIN_E11 -to clk_in
set_location_assignment PIN_D9 -to global_reset_n
# set_location_assignment PIN_E10 -to "(n)"
set_instance_assignment -name IO_STANDARD "SSTL-15" -to mem_a[13]
set_instance_assignment -name IO_STANDARD "LVDS" -to clk_in
# set_location_assignment PIN_A4 -to drv_status_fail
# set_location_assignment PIN_D8 -to drv_status_pass
# set_location_assignment PIN_B7 -to drv_status_test_complete
# set_instance_assignment -name IO_STANDARD "2.5 V" -to drv_status_fail
# set_instance_assignment -name IO_STANDARD "2.5 V" -to drv_status_pass
# set_instance_assignment -name IO_STANDARD "2.5 V" -to drv_status_test_complete
set_location_assignment PIN_AA1 -to led_calib_success
set_location_assignment PIN_AA2 -to led_calib_fail
set_location_assignment PIN_Y1 -to led_pass
set_location_assignment PIN_Y2 -to led_fail
# set_location_assignment PIN_C8 -to local_init_done
# set_instance_assignment -name IO_STANDARD "2.5 V" -to local_init_done
set_instance_assignment -name IO_STANDARD "2.5 V" -to led_calib_success
set_instance_assignment -name IO_STANDARD "2.5 V" -to led_calib_fail
set_instance_assignment -name IO_STANDARD "2.5 V" -to led_pass
set_instance_assignment -name IO_STANDARD "2.5 V" -to led_fail
