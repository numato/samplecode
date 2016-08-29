//-----------------------------------------------------------------------------
//
// (c) Copyright 2008, 2009 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
//-----------------------------------------------------------------------------
// Project    : Spartan-6 Integrated Block for PCI Express
// File       : xilinx_pcie_1_1_ep_s6.v
// Description: PCI Express Endpoint example FPGA design
//
//-----------------------------------------------------------------------------

`timescale 1ns / 1ps

module xilinx_pcie_1_1_ep_s6 #(
  parameter FAST_TRAIN = "FALSE"
) (
  output    pci_exp_txp,
  output    pci_exp_txn,
  input     pci_exp_rxp,
  input     pci_exp_rxn,

  input     sys_clk_p,
  input     sys_clk_n,
  input     sys_reset_n,

  /*output    led_0,
  output    led_1,
  output    led_2*/
  
 
   output [7:0] PORT1,
  output [7:0] PORT2,
  output [7:0] PORT3,
  output [7:0] PORT4,
  output [7:0] PORT5,
  output [7:0] PORT6,
  output [7:0] PORT7	  

);

  // Common
  wire                                        trn_clk;
  wire                                        trn_reset_n;
  wire                                        trn_lnk_up_n;

  // Tx
  wire [5:0]                                  trn_tbuf_av;
  wire                                        trn_tcfg_req_n;
  wire                                        trn_terr_drop_n;
  wire                                        trn_tdst_rdy_n;
  wire [31:0]                                 trn_td;
  wire                                        trn_tsof_n;
  wire                                        trn_teof_n;
  wire                                        trn_tsrc_rdy_n;
  wire                                        trn_tsrc_dsc_n;
  wire                                        trn_terrfwd_n;
  wire                                        trn_tcfg_gnt_n;
  wire                                        trn_tstr_n;

  // Rx
  wire [31:0]                                 trn_rd;
  wire                                        trn_rsof_n;
  wire                                        trn_reof_n;
  wire                                        trn_rsrc_rdy_n;
  wire                                        trn_rsrc_dsc_n;
  wire                                        trn_rerrfwd_n;
  wire [6:0]                                  trn_rbar_hit_n;
  wire                                        trn_rdst_rdy_n;
  wire                                        trn_rnp_ok_n;

  // Flow Control
  wire [11:0]                                 trn_fc_cpld;
  wire [7:0]                                  trn_fc_cplh;
  wire [11:0]                                 trn_fc_npd;
  wire [7:0]                                  trn_fc_nph;
  wire [11:0]                                 trn_fc_pd;
  wire [7:0]                                  trn_fc_ph;
  wire [2:0]                                  trn_fc_sel;

  // Config
  wire [63:0]                                 cfg_dsn;
  wire [31:0]                                 cfg_do;
  wire                                        cfg_rd_wr_done_n;
  wire [9:0]                                  cfg_dwaddr;
  wire                                        cfg_rd_en_n;

  // Error signaling
  wire                                        cfg_err_cor_n;
  wire                                        cfg_err_ur_n;
  wire                                        cfg_err_ecrc_n;
  wire                                        cfg_err_cpl_timeout_n;
  wire                                        cfg_err_cpl_abort_n;
  wire                                        cfg_err_posted_n;
  wire                                        cfg_err_locked_n;
  wire [47:0]                                 cfg_err_tlp_cpl_header;
  wire                                        cfg_err_cpl_rdy_n;

  // Interrupt signaling
  wire                                        cfg_interrupt_n;
  wire                                        cfg_interrupt_rdy_n;
  wire                                        cfg_interrupt_assert_n;
  wire [7:0]                                  cfg_interrupt_di;
  wire [7:0]                                  cfg_interrupt_do;
  wire [2:0]                                  cfg_interrupt_mmenable;
  wire                                        cfg_interrupt_msienable;

  // Power management signaling
  wire                                        cfg_turnoff_ok_n;
  wire                                        cfg_to_turnoff_n;
  wire                                        cfg_trn_pending_n;
  wire                                        cfg_pm_wake_n;

  // System configuration and status
  wire [7:0]                                  cfg_bus_number;
  wire [4:0]                                  cfg_device_number;
  wire [2:0]                                  cfg_function_number;
  wire [15:0]                                 cfg_status;
  wire [15:0]                                 cfg_command;
  wire [15:0]                                 cfg_dstatus;
  wire [15:0]                                 cfg_dcommand;
  wire [15:0]                                 cfg_lstatus;
  wire [15:0]                                 cfg_lcommand;
  wire [2:0]                                  cfg_pcie_link_state_n;

  // System (SYS) Interface
  wire                                        sys_clk_c;
  wire                                        sys_reset_n_c;

  //-------------------------------------------------------
  // Clock Input Buffer for differential system clock
  //-------------------------------------------------------
  IBUFDS refclk_ibuf (.O(sys_clk_c), .I(sys_clk_p), .IB(sys_clk_n));

  //-------------------------------------------------------
  // Input buffer for system reset signal
  //-------------------------------------------------------
  IBUF   sys_reset_n_ibuf (.O(sys_reset_n_c), .I(sys_reset_n));

  //-------------------------------------------------------
  // Output buffers for diagnostic LEDs
  //-------------------------------------------------------
  /*OBUF   led_0_obuf (.O(led_0), .I(sys_reset_n_c));
  OBUF   led_1_obuf (.O(led_1), .I(trn_reset_n));
  OBUF   led_2_obuf (.O(led_2), .I(trn_lnk_up_n));*/

  pcie_app_s6 app (
    // Transaction (TRN) Interface
    // Common lock & reset
    .trn_clk( trn_clk ),
    .trn_reset_n( trn_reset_n ),
    .trn_lnk_up_n( trn_lnk_up_n ),
    // Common flow control
    .trn_fc_cpld( trn_fc_cpld ),
    .trn_fc_cplh( trn_fc_cplh ),
    .trn_fc_npd( trn_fc_npd ),
    .trn_fc_nph( trn_fc_nph ),
    .trn_fc_pd( trn_fc_pd ),
    .trn_fc_ph( trn_fc_ph ),
    .trn_fc_sel( trn_fc_sel ),
    // Transaction Tx
    .trn_tbuf_av( trn_tbuf_av ),
    .trn_tcfg_req_n( trn_tcfg_req_n ),
    .trn_terr_drop_n( trn_terr_drop_n ),
    .trn_tdst_rdy_n( trn_tdst_rdy_n ),
    .trn_td( trn_td ),
    .trn_tsof_n( trn_tsof_n ),
    .trn_teof_n( trn_teof_n ),
    .trn_tsrc_rdy_n( trn_tsrc_rdy_n ),
    .trn_tsrc_dsc_n( trn_tsrc_dsc_n ),
    .trn_terrfwd_n( trn_terrfwd_n ),
    .trn_tcfg_gnt_n( trn_tcfg_gnt_n ),
    .trn_tstr_n( trn_tstr_n ),
    // Transaction Rx
    .trn_rd( trn_rd ),
    .trn_rsof_n( trn_rsof_n ),
    .trn_reof_n( trn_reof_n ),
    .trn_rsrc_rdy_n( trn_rsrc_rdy_n ),
    .trn_rsrc_dsc_n( trn_rsrc_dsc_n ),
    .trn_rerrfwd_n( trn_rerrfwd_n ),
    .trn_rbar_hit_n( trn_rbar_hit_n ),
    .trn_rdst_rdy_n( trn_rdst_rdy_n ),
    .trn_rnp_ok_n( trn_rnp_ok_n ),

    // Configuration (CFG) Interface
    // Configuration space access
    .cfg_do( cfg_do ),
    .cfg_rd_wr_done_n( cfg_rd_wr_done_n),
    .cfg_dwaddr( cfg_dwaddr ),
    .cfg_rd_en_n( cfg_rd_en_n ),
    // Error signaling
    .cfg_err_cor_n( cfg_err_cor_n ),
    .cfg_err_ur_n( cfg_err_ur_n ),
    .cfg_err_ecrc_n( cfg_err_ecrc_n ),
    .cfg_err_cpl_timeout_n( cfg_err_cpl_timeout_n ),
    .cfg_err_cpl_abort_n( cfg_err_cpl_abort_n ),
    .cfg_err_posted_n( cfg_err_posted_n ),
    .cfg_err_locked_n( cfg_err_locked_n ),
    .cfg_err_tlp_cpl_header( cfg_err_tlp_cpl_header ),
    .cfg_err_cpl_rdy_n( cfg_err_cpl_rdy_n ),
    // Interrupt generation
    .cfg_interrupt_n( cfg_interrupt_n ),
    .cfg_interrupt_rdy_n( cfg_interrupt_rdy_n ),
    .cfg_interrupt_assert_n( cfg_interrupt_assert_n ),
    .cfg_interrupt_di( cfg_interrupt_di ),
    .cfg_interrupt_do( cfg_interrupt_do ),
    .cfg_interrupt_mmenable( cfg_interrupt_mmenable ),
    .cfg_interrupt_msienable( cfg_interrupt_msienable ),
    // Power managemnt signaling
    .cfg_turnoff_ok_n( cfg_turnoff_ok_n ),
    .cfg_to_turnoff_n( cfg_to_turnoff_n ),
    .cfg_trn_pending_n( cfg_trn_pending_n ),
    .cfg_pm_wake_n( cfg_pm_wake_n ),
    // System configuration and status
    .cfg_bus_number( cfg_bus_number ),
    .cfg_device_number( cfg_device_number ),
    .cfg_function_number( cfg_function_number ),
    .cfg_status( cfg_status ),
    .cfg_command( cfg_command ),
    .cfg_dstatus( cfg_dstatus ),
    .cfg_dcommand( cfg_dcommand ),
    .cfg_lstatus( cfg_lstatus ),
    .cfg_lcommand( cfg_lcommand ),
    .cfg_pcie_link_state_n( cfg_pcie_link_state_n ),
    .cfg_dsn( cfg_dsn ),
	 
	 .PORT1(PORT1),
	 .PORT2(PORT2),
	 .PORT3(PORT3),
	 .PORT4(PORT4),
	 .PORT5(PORT5),
	 .PORT6(PORT6),
	 .PORT7(PORT7)
  );

  PCIe #(
    .FAST_TRAIN                        ( FAST_TRAIN                        )
  ) PCIe_i (
    // PCI Express (PCI_EXP) Fabric Interface
    .pci_exp_txp                        ( pci_exp_txp                             ),
    .pci_exp_txn                        ( pci_exp_txn                             ),
    .pci_exp_rxp                        ( pci_exp_rxp                             ),
    .pci_exp_rxn                        ( pci_exp_rxn                             ),

    // Transaction (TRN) Interface
    // Common clock & reset
    .trn_lnk_up_n                       ( trn_lnk_up_n                            ),
    .trn_clk                            ( trn_clk                                 ),
    .trn_reset_n                        ( trn_reset_n                             ),
    // Common flow control
    .trn_fc_sel                         ( trn_fc_sel                              ),
    .trn_fc_nph                         ( trn_fc_nph                              ),
    .trn_fc_npd                         ( trn_fc_npd                              ),
    .trn_fc_ph                          ( trn_fc_ph                               ),
    .trn_fc_pd                          ( trn_fc_pd                               ),
    .trn_fc_cplh                        ( trn_fc_cplh                             ),
    .trn_fc_cpld                        ( trn_fc_cpld                             ),
    // Transaction Tx
    .trn_td                             ( trn_td                                  ),
    .trn_tsof_n                         ( trn_tsof_n                              ),
    .trn_teof_n                         ( trn_teof_n                              ),
    .trn_tsrc_rdy_n                     ( trn_tsrc_rdy_n                          ),
    .trn_tdst_rdy_n                     ( trn_tdst_rdy_n                          ),
    .trn_terr_drop_n                    ( trn_terr_drop_n                         ),
    .trn_tsrc_dsc_n                     ( trn_tsrc_dsc_n                          ),
    .trn_terrfwd_n                      ( trn_terrfwd_n                           ),
    .trn_tbuf_av                        ( trn_tbuf_av                             ),
    .trn_tstr_n                         ( trn_tstr_n                              ),
    .trn_tcfg_req_n                     ( trn_tcfg_req_n                          ),
    .trn_tcfg_gnt_n                     ( trn_tcfg_gnt_n                          ),
    // Transaction Rx
    .trn_rd                             ( trn_rd                                  ),
    .trn_rsof_n                         ( trn_rsof_n                              ),
    .trn_reof_n                         ( trn_reof_n                              ),
    .trn_rsrc_rdy_n                     ( trn_rsrc_rdy_n                          ),
    .trn_rsrc_dsc_n                     ( trn_rsrc_dsc_n                          ),
    .trn_rdst_rdy_n                     ( trn_rdst_rdy_n                          ),
    .trn_rerrfwd_n                      ( trn_rerrfwd_n                           ),
    .trn_rnp_ok_n                       ( trn_rnp_ok_n                            ),
    .trn_rbar_hit_n                     ( trn_rbar_hit_n                          ),

    // Configuration (CFG) Interface
    // Configuration space access
    .cfg_do                             ( cfg_do                                  ),
    .cfg_rd_wr_done_n                   ( cfg_rd_wr_done_n                        ),
    .cfg_dwaddr                         ( cfg_dwaddr                              ),
    .cfg_rd_en_n                        ( cfg_rd_en_n                             ),
    // Error reporting
    .cfg_err_ur_n                       ( cfg_err_ur_n                            ),
    .cfg_err_cor_n                      ( cfg_err_cor_n                           ),
    .cfg_err_ecrc_n                     ( cfg_err_ecrc_n                          ),
    .cfg_err_cpl_timeout_n              ( cfg_err_cpl_timeout_n                   ),
    .cfg_err_cpl_abort_n                ( cfg_err_cpl_abort_n                     ),
    .cfg_err_posted_n                   ( cfg_err_posted_n                        ),
    .cfg_err_locked_n                   ( cfg_err_locked_n                        ),
    .cfg_err_tlp_cpl_header             ( cfg_err_tlp_cpl_header                  ),
    .cfg_err_cpl_rdy_n                  ( cfg_err_cpl_rdy_n                       ),
    // Interrupt generation
    .cfg_interrupt_n                    ( cfg_interrupt_n                         ),
    .cfg_interrupt_rdy_n                ( cfg_interrupt_rdy_n                     ),
    .cfg_interrupt_assert_n             ( cfg_interrupt_assert_n                  ),
    .cfg_interrupt_do                   ( cfg_interrupt_do                        ),
    .cfg_interrupt_di                   ( cfg_interrupt_di                        ),
    .cfg_interrupt_mmenable             ( cfg_interrupt_mmenable                  ),
    .cfg_interrupt_msienable            ( cfg_interrupt_msienable                 ),
    // Power management signaling
    .cfg_turnoff_ok_n                   ( cfg_turnoff_ok_n                        ),
    .cfg_to_turnoff_n                   ( cfg_to_turnoff_n                        ),
    .cfg_pm_wake_n                      ( cfg_pm_wake_n                           ),
    .cfg_pcie_link_state_n              ( cfg_pcie_link_state_n                   ),
    .cfg_trn_pending_n                  ( cfg_trn_pending_n                       ),
    // System configuration and status
    .cfg_dsn                            ( cfg_dsn                                 ),
    .cfg_bus_number                     ( cfg_bus_number                          ),
    .cfg_device_number                  ( cfg_device_number                       ),
    .cfg_function_number                ( cfg_function_number                     ),
    .cfg_status                         ( cfg_status                              ),
    .cfg_command                        ( cfg_command                             ),
    .cfg_dstatus                        ( cfg_dstatus                             ),
    .cfg_dcommand                       ( cfg_dcommand                            ),
    .cfg_lstatus                        ( cfg_lstatus                             ),
    .cfg_lcommand                       ( cfg_lcommand                            ),

    // System (SYS) Interface
    .sys_clk                            ( sys_clk_c                               ),
    .sys_reset_n                        ( sys_reset_n_c                           ),
    .received_hot_reset                 (                                         )
  );

endmodule
