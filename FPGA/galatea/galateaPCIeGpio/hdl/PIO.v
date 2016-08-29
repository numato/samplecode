//-----------------------------------------------------------------------------
//
// (c) Copyright 2001, 2002, 2003, 2004, 2005, 2007, 2008, 2009 Xilinx, Inc. All rights reserved.
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
// File       : PIO.v
// Description: Programmed I/O module. Design implements 8 KBytes of
//              programmable memory space. Host processor can access this
//              memory space using Memory Read 32 and Memory Write 32 TLPs.
//              Design accepts  1 Double Word (DW) payload length on Memory
//              Write 32 TLP and responds to 1 DW length Memory Read 32 TLPs
//              with a Completion with Data TLP (1DW payload).
//
//-----------------------------------------------------------------------------

`timescale 1ns/1ns

module PIO (
  input         trn_clk,
  input         trn_reset_n,
  input         trn_lnk_up_n,

  output [31:0] trn_td,
  output        trn_tsof_n,
  output        trn_teof_n,
  output        trn_tsrc_rdy_n,
  output        trn_tsrc_dsc_n,
  input         trn_tdst_rdy_n,
  input         trn_tdst_dsc_n,

  input [31:0] trn_rd,

  input         trn_rsof_n,
  input         trn_reof_n,
  input         trn_rsrc_rdy_n,
  input         trn_rsrc_dsc_n,
  input [6:0]   trn_rbar_hit_n,
  output        trn_rdst_rdy_n,

  input         cfg_to_turnoff_n,
  output        cfg_turnoff_ok_n,

  input [15:0]  cfg_completer_id,
  input         cfg_bus_mstr_enable,
  
    output [7:0] PORT1,
  output [7:0] PORT2,
  output [7:0] PORT3,
  output [7:0] PORT4,
  output [7:0] PORT5,
  output [7:0] PORT6,
  output [7:0] PORT7
  );

  // Local wires
  wire          req_compl;
  wire          compl_done;
  wire          pio_reset_n = trn_reset_n && !trn_lnk_up_n;


  //
  // PIO instance
  //
  PIO_EP PIO_EP (
    .clk  ( trn_clk ),                           // I
    .rst_n ( pio_reset_n ),                      // I

    .trn_td ( trn_td ),                          // O [31:0]
    .trn_tsof_n ( trn_tsof_n ),                  // O
    .trn_teof_n ( trn_teof_n ),                  // O
    .trn_tsrc_rdy_n ( trn_tsrc_rdy_n ),          // O
    .trn_tsrc_dsc_n ( trn_tsrc_dsc_n ),          // O
    .trn_tdst_rdy_n ( trn_tdst_rdy_n ),          // I
    .trn_tdst_dsc_n ( trn_tdst_dsc_n ),          // I

    .trn_rd ( trn_rd ),                          // I [31:0]
    .trn_rsof_n ( trn_rsof_n ),                  // I
    .trn_reof_n ( trn_reof_n ),                  // I
    .trn_rsrc_rdy_n ( trn_rsrc_rdy_n ),          // I
    .trn_rsrc_dsc_n ( trn_rsrc_dsc_n ),          // I
    .trn_rbar_hit_n ( trn_rbar_hit_n ),          // I [6:0]
    .trn_rdst_rdy_n ( trn_rdst_rdy_n ),          // O

    .req_compl_o(req_compl),                     // O
    .compl_done_o(compl_done),                   // O

    .cfg_completer_id ( cfg_completer_id ),      // I [15:0]
    .cfg_bus_mstr_enable ( cfg_bus_mstr_enable ), // I,
	 
	 .PORT1(PORT1),
	 .PORT2(PORT2),
	 .PORT3(PORT3),
	 .PORT4(PORT4),
	 .PORT5(PORT5),
	 .PORT6(PORT6),
	 .PORT7(PORT7)
    );


  //
  // Turn-Off controller
  //
  PIO_TO_CTRL PIO_TO  (
    .clk( trn_clk ),                             // I
    .rst_n( trn_reset_n ),                       // I

    .req_compl_i( req_compl ),                   // I
    .compl_done_i( compl_done ),                 // I

    .cfg_to_turnoff_n( cfg_to_turnoff_n ),       // I
    .cfg_turnoff_ok_n( cfg_turnoff_ok_n )        // O
    );

endmodule // PIO

