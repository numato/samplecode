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
// File       : PIO_32_TX_ENGINE.v
// Description: 32 bit LocalLink Transmit Unit.
//
//-----------------------------------------------------------------------------

`timescale 1ns/1ns

module PIO_32_TX_ENGINE (
  input                   clk,
  input                   rst_n,

  output reg  [31:0]      trn_td,
  output reg              trn_tsof_n,
  output reg              trn_teof_n,
  output reg              trn_tsrc_rdy_n,
  output reg              trn_tsrc_dsc_n,
  input                   trn_tdst_rdy_n,
  input                   trn_tdst_dsc_n,

  input                   req_compl_i,
  input                   req_compl_with_data_i,
  output reg              compl_done_o,

  input       [2:0]       req_tc_i,
  input                   req_td_i,
  input                   req_ep_i,
  input       [1:0]       req_attr_i,
  input       [9:0]       req_len_i,
  input       [15:0]      req_rid_i,
  input       [7:0]       req_tag_i,
  input       [7:0]       req_be_i,
  input       [12:0]      req_addr_i,

  output wire [10:0]      rd_addr_o,
  output wire [3:0]       rd_be_o,
  input       [31:0]      rd_data_i,

  input       [15:0]      completer_id_i,
  input                   cfg_bus_mstr_enable_i
  );

  // Clock-to-out delay
  localparam TCQ                    = 1;

  // TLP Header format/type values
  localparam PIO_32_CPLD_FMT_TYPE   = 7'b10_01010;
  localparam PIO_32_CPL_FMT_TYPE    = 7'b00_01010;

  // State values
  localparam PIO_32_TX_RST_STATE    = 3'd0;
  localparam PIO_32_TX_CPL_CPLD_DW1 = 3'd1;
  localparam PIO_32_TX_CPL_CPLD_DW2 = 3'd2;
  localparam PIO_32_TX_CPLD_DW3     = 3'd3;
  localparam PIO_32_TX_WAIT_STATE   = 3'd4;

  // Local registers
  reg [11:0]          byte_count;
  reg [6:0]           lower_addr;
  reg [2:0]           state;
  reg                 cpl_w_data;
  reg                 req_compl_q;
  reg                 req_compl_with_data_q;

  //
  // Present address and byte enable to memory module
  //
  assign rd_addr_o = req_addr_i[12:2];
  assign rd_be_o   = req_be_i[3:0];

  //
  // Calculate byte count based on byte enable
  //
  always @* begin
    casex (rd_be_o[3:0])
      4'b1xx1 : byte_count = 12'h004;
      4'b01x1 : byte_count = 12'h003;
      4'b1x10 : byte_count = 12'h003;
      4'b0011 : byte_count = 12'h002;
      4'b0110 : byte_count = 12'h002;
      4'b1100 : byte_count = 12'h002;
      4'b0001 : byte_count = 12'h001;
      4'b0010 : byte_count = 12'h001;
      4'b0100 : byte_count = 12'h001;
      4'b1000 : byte_count = 12'h001;
      4'b0000 : byte_count = 12'h001;
    endcase
  end

  //
  // Calculate lower address based on byte enable
  //
  always @* begin
    casex (rd_be_o[3:0])
      4'b0000 : lower_addr = {req_addr_i[6:2], 2'b00};
      4'bxxx1 : lower_addr = {req_addr_i[6:2], 2'b00};
      4'bxx10 : lower_addr = {req_addr_i[6:2], 2'b01};
      4'bx100 : lower_addr = {req_addr_i[6:2], 2'b10};
      4'b1000 : lower_addr = {req_addr_i[6:2], 2'b11};
    endcase
  end

  always @(posedge clk) begin
    if (!rst_n) begin
      req_compl_q           <= #TCQ 1'b0;
      req_compl_with_data_q <= #TCQ 1'b1;
    end else begin
      req_compl_q           <= #TCQ req_compl_i;
      req_compl_with_data_q <= #TCQ req_compl_with_data_i;
    end
  end

  //
  //  Generate Completion with 1 DW Payload or Completion with
  //  no data
  //
  always @(posedge clk) begin
    if (!rst_n) begin
      trn_tsof_n        <= #TCQ 1'b1;
      trn_teof_n        <= #TCQ 1'b1;
      trn_tsrc_rdy_n    <= #TCQ 1'b1;
      trn_tsrc_dsc_n    <= #TCQ 1'b1;
      trn_td            <= #TCQ 32'b0;

      compl_done_o      <= #TCQ 1'b0;

      state             <= #TCQ PIO_32_TX_RST_STATE;
    end else begin
      compl_done_o      <= #TCQ 1'b0;

      case (state)
        PIO_32_TX_RST_STATE : begin
          trn_tsrc_dsc_n     <= #TCQ 1'b1;

          if (req_compl_q && req_compl_with_data_q && trn_tdst_dsc_n) begin
            // Begin a CplD TLP
            trn_tsof_n       <= #TCQ 1'b0;
            trn_teof_n       <= #TCQ 1'b1;
            trn_tsrc_rdy_n   <= #TCQ 1'b0;
            trn_td           <= #TCQ {{1'b0},
                                      PIO_32_CPLD_FMT_TYPE,
                                      {1'b0},
                                      req_tc_i,
                                      {4'b0},
                                      req_td_i,
                                      req_ep_i,
                                      req_attr_i,
                                      {2'b0},
                                      req_len_i
                                      };
            cpl_w_data       <= #TCQ req_compl_with_data_q;
            state            <= #TCQ PIO_32_TX_CPL_CPLD_DW1;
          end else if (req_compl_q && !req_compl_with_data_q && trn_tdst_dsc_n) begin
            // Begin a Cpl TLP
            trn_tsof_n       <= #TCQ 1'b0;
            trn_teof_n       <= #TCQ 1'b1;
            trn_tsrc_rdy_n   <= #TCQ 1'b0;
            trn_td           <= #TCQ {{1'b0},
                                      PIO_32_CPL_FMT_TYPE,
                                      {1'b0},
                                      req_tc_i,
                                      {4'b0},
                                      req_td_i,
                                      req_ep_i,
                                      req_attr_i,
                                      {2'b0},
                                      req_len_i
                                      };
            cpl_w_data       <= #TCQ req_compl_with_data_q;
            state            <= #TCQ PIO_32_TX_CPL_CPLD_DW1;
          end else begin
            trn_tsof_n       <= #TCQ 1'b1;
            trn_teof_n       <= #TCQ 1'b1;
            trn_tsrc_rdy_n   <= #TCQ 1'b1;
            trn_td           <= #TCQ 32'b0;
            state            <= #TCQ PIO_32_TX_RST_STATE;
          end
        end // PIO_32_TX_RST_STATE

        PIO_32_TX_CPL_CPLD_DW1 : begin
          if (!trn_tdst_dsc_n) begin
            // Core is aborting
            trn_tsrc_dsc_n   <= #TCQ 1'b0;
            state            <= #TCQ PIO_32_TX_RST_STATE;
          end else if (!trn_tdst_rdy_n) begin
            // Output next DW of TLP
            trn_tsof_n       <= #TCQ 1'b1;
            trn_teof_n       <= #TCQ 1'b1;
            trn_tsrc_rdy_n   <= #TCQ 1'b0;
            trn_td           <= #TCQ {completer_id_i,
                                      {3'b0},
                                      {1'b0},
                                      byte_count
                                      };
            state            <= #TCQ PIO_32_TX_CPL_CPLD_DW2;
          end else begin
            // Wait for core to accept previous DW
            state            <= #TCQ PIO_32_TX_CPL_CPLD_DW1;
          end
        end // PIO_32_TX_CPL_CPLD_DW1

        PIO_32_TX_CPL_CPLD_DW2 : begin
          if (!trn_tdst_dsc_n) begin
            // Core is aborting
            trn_tsrc_dsc_n   <= #TCQ 1'b0;
            state            <= #TCQ PIO_32_TX_RST_STATE;
          end else if (!trn_tdst_rdy_n) begin
            // Output next DW of TLP
            trn_tsof_n       <= #TCQ 1'b1;
            trn_tsrc_rdy_n   <= #TCQ 1'b0;
            trn_td           <= #TCQ {req_rid_i,
                                      req_tag_i,
                                      {1'b0},
                                      lower_addr
                                      };

            if (cpl_w_data) begin
              // For a CplD, there is one more DW
              trn_teof_n     <= #TCQ 1'b1;
              state          <= #TCQ PIO_32_TX_CPLD_DW3;
            end else begin
              // For a Cpl, this is the final DW
              trn_teof_n     <= #TCQ 1'b0;
              state          <= #TCQ PIO_32_TX_WAIT_STATE;
            end
          end else begin
            // Wait for core to accept previous DW
            state            <= #TCQ PIO_32_TX_CPL_CPLD_DW2;
          end
        end // PIO_32_TX_CPL_CPLD_DW2

        PIO_32_TX_CPLD_DW3 : begin
          if (!trn_tdst_dsc_n) begin
            // Core is aborting
            trn_tsrc_dsc_n   <= #TCQ 1'b1;
            state            <= #TCQ PIO_32_TX_RST_STATE;
          end else if (!trn_tdst_rdy_n) begin
            // Output next DW of TLP
            trn_tsof_n       <= #TCQ 1'b1;
            trn_teof_n       <= #TCQ 1'b0;
            trn_tsrc_rdy_n   <= #TCQ 1'b0;
            trn_td           <= #TCQ rd_data_i;
            state            <= #TCQ PIO_32_TX_WAIT_STATE;
          end else begin
            // Wait for core to accept previous DW
            state            <= #TCQ PIO_32_TX_CPLD_DW3;
          end
        end // PIO_32_TX_CPLD_DW3

        PIO_32_TX_WAIT_STATE : begin
          if (!trn_tdst_dsc_n) begin
            // Core is aborting
            trn_tsrc_dsc_n   <= #TCQ 1'b1;
            state            <= #TCQ PIO_32_TX_RST_STATE;
          end else if (!trn_tdst_rdy_n) begin
            // Core has accepted final DW of TLP
            trn_tsrc_rdy_n   <= #TCQ 1'b1;
            compl_done_o     <= #TCQ 1'b1;
            state            <= #TCQ PIO_32_TX_RST_STATE;
          end else begin
            // Wait for core to accept previous DW
            state            <= #TCQ PIO_32_TX_WAIT_STATE;
          end
        end // PIO_32_TX_WAIT_STATE
        default:
          state              <= #TCQ PIO_32_TX_RST_STATE;
      endcase // (state)
    end // rst_n
  end

endmodule // PIO_32_TX_ENGINE

