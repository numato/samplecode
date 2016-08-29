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
// File       : PIO_32_RX_ENGINE.v
// Description: 32-bit Local-Link Receive Unit.
//
//-----------------------------------------------------------------------------

`timescale 1ns/1ns

module PIO_32_RX_ENGINE (
  input                  clk,
  input                  rst_n,

  //
  // Receive LocalLink interface from PCIe core
  //
  input      [31:0]      trn_rd,
  input                  trn_rsof_n,
  input                  trn_reof_n,
  input                  trn_rsrc_rdy_n,
  input                  trn_rsrc_dsc_n,
  input      [6:0]       trn_rbar_hit_n,
  output reg             trn_rdst_rdy_n,

  //
  // Memory Read data handshake with Completion
  // transmit unit. Transmit unit reponds to
  // req_compl assertion and responds with compl_done
  // assertion when a Completion w/ data is transmitted.
  //
  output reg             req_compl_o,
  output reg             req_compl_with_data_o,
  input                  compl_done_i,

  output reg [2:0]       req_tc_o,      // Memory Read TC
  output reg             req_td_o,      // Memory Read TD
  output reg             req_ep_o,      // Memory Read EP
  output reg [1:0]       req_attr_o,    // Memory Read Attribute
  output reg [9:0]       req_len_o,     // Memory Read Length (1DW)
  output reg [15:0]      req_rid_o,     // Memory Read Requestor ID
  output reg [7:0]       req_tag_o,     // Memory Read Tag
  output reg [7:0]       req_be_o,      // Memory Read Byte Enables
  output reg [12:0]      req_addr_o,    // Memory Read Address

  //
  // Memory interface used for saving 1 DW data received
  // on Memory Write 32 TLP. Data extracted from
  // inbound TLP is presented to the Endpoint memory
  // unit. Endpoint memory unit reacts to wr_en_o
  // assertion and asserts wr_busy_i when it is
  // processing written information.
  //
  output reg [10:0]      wr_addr_o,     // Memory Write Address
  output reg [7:0]       wr_be_o,       // Memory Write Byte Enable
  output reg [31:0]      wr_data_o,     // Memory Write Data
  output reg             wr_en_o,       // Memory Write Enable
  input                  wr_busy_i      // Memory Write Busy
  );

  // Clock-to-out delay
  localparam TCQ                         = 1;

  // TLP Header format/type values
  localparam PIO_32_RX_MEM_RD32_FMT_TYPE = 7'b00_00000;
  localparam PIO_32_RX_MEM_WR32_FMT_TYPE = 7'b10_00000;
  localparam PIO_32_RX_MEM_RD64_FMT_TYPE = 7'b01_00000;
  localparam PIO_32_RX_MEM_WR64_FMT_TYPE = 7'b11_00000;
  localparam PIO_32_RX_IO_RD32_FMT_TYPE  = 7'b00_00010;
  localparam PIO_32_RX_IO_WR32_FMT_TYPE  = 7'b10_00010;

  // State values
  localparam PIO_32_RX_RST_STATE         = 4'd0;
  localparam PIO_32_RX_MEM_RD32_DW1      = 4'd1;
  localparam PIO_32_RX_MEM_RD32_DW2      = 4'd2;
  localparam PIO_32_RX_IO_MEM_WR32_DW1   = 4'd3;
  localparam PIO_32_RX_IO_MEM_WR32_DW2   = 4'd4;
  localparam PIO_32_RX_IO_MEM_WR32_DW3   = 4'd5;
  localparam PIO_32_RX_IO_MEM_WR32_DW4   = 4'd6;
  localparam PIO_32_RX_MEM_RD64_DW1      = 4'd7;
  localparam PIO_32_RX_MEM_RD64_DW2      = 4'd8;
  localparam PIO_32_RX_MEM_RD64_DW3      = 4'd9;
  localparam PIO_32_RX_MEM_WR64_DW1      = 4'd10;
  localparam PIO_32_RX_MEM_WR64_DW2      = 4'd11;
  localparam PIO_32_RX_MEM_WR64_DW3      = 4'd12;
  localparam PIO_32_RX_MEM_WR64_DW4      = 4'd13;
  localparam PIO_32_RX_WAIT_STATE        = 4'd14;

  // Local Registers
  (* fsm_encoding = "one-hot" *)
    reg [3:0]        state;
  reg [6:0]          tlp_type;

  wire               io_bar_hit_n;
  wire               mem32_bar_hit_n;
  wire               mem64_bar_hit_n;
  wire               erom_bar_hit_n;

  reg [1:0]          region_select;

  always @(posedge clk) begin
    if (!rst_n) begin
      trn_rdst_rdy_n        <= #TCQ 1'b0;

      req_compl_o           <= #TCQ 1'b0;
      req_compl_with_data_o <= #TCQ 1'b1;

      req_tc_o              <= #TCQ 3'b0;
      req_td_o              <= #TCQ 1'b0;
      req_ep_o              <= #TCQ 1'b0;
      req_attr_o            <= #TCQ 2'b0;
      req_len_o             <= #TCQ 10'b0;
      req_rid_o             <= #TCQ 16'b0;
      req_tag_o             <= #TCQ 8'b0;
      req_be_o              <= #TCQ 8'b0;
      req_addr_o            <= #TCQ 13'b0;

      wr_be_o               <= #TCQ 8'b0;
      wr_addr_o             <= #TCQ 11'b0;
      wr_data_o             <= #TCQ 32'b0;
      wr_en_o               <= #TCQ 1'b0;

      state                 <= #TCQ PIO_32_RX_RST_STATE;
      tlp_type              <= #TCQ 7'b0;
    end else begin
      wr_en_o               <= #TCQ 1'b0;
      req_compl_o           <= #TCQ 1'b0;
      req_compl_with_data_o <= #TCQ 1'b1;

      case (state)
        PIO_32_RX_RST_STATE : begin

          trn_rdst_rdy_n       <= #TCQ 1'b0;
          tlp_type             <= #TCQ trn_rd[30:24];
          req_tc_o             <= #TCQ trn_rd[22:20];
          req_td_o             <= #TCQ trn_rd[15];
          req_ep_o             <= #TCQ trn_rd[14];
          req_attr_o           <= #TCQ trn_rd[13:12];
          req_len_o            <= #TCQ trn_rd[9:0];

          if ((!trn_rsof_n) && (!trn_rsrc_rdy_n) && (!trn_rdst_rdy_n)) begin
            case (trn_rd[30:24])
              PIO_32_RX_MEM_RD32_FMT_TYPE : begin
                if (trn_rd[9:0] == 10'd1) begin
                  state        <= #TCQ PIO_32_RX_MEM_RD32_DW1;
                end else begin
                  state        <= #TCQ PIO_32_RX_RST_STATE;
                end
              end

              PIO_32_RX_MEM_WR32_FMT_TYPE : begin
                if (trn_rd[9:0] == 10'd1) begin
                  state        <= #TCQ PIO_32_RX_IO_MEM_WR32_DW1;
                end else begin
                  state        <= #TCQ PIO_32_RX_RST_STATE;
                end
              end

              PIO_32_RX_MEM_RD64_FMT_TYPE : begin
                if (trn_rd[9:0] == 10'd1) begin
                  state        <= #TCQ PIO_32_RX_MEM_RD64_DW1;
                end else begin
                  state        <=  #TCQ PIO_32_RX_RST_STATE;
                end
              end

              PIO_32_RX_MEM_WR64_FMT_TYPE : begin
                if (trn_rd[9:0] == 10'd1) begin
                  state        <= #TCQ PIO_32_RX_MEM_WR64_DW1;
                end else begin
                  state        <= #TCQ PIO_32_RX_RST_STATE;
                end
              end

              PIO_32_RX_IO_RD32_FMT_TYPE : begin
                if (trn_rd[9:0] == 10'd1) begin
                  state        <= #TCQ PIO_32_RX_MEM_RD32_DW1;
                end else begin
                  state        <= #TCQ PIO_32_RX_RST_STATE;
                end
              end

              PIO_32_RX_IO_WR32_FMT_TYPE : begin
                if (trn_rd[9:0] == 10'd1) begin
                  state        <= #TCQ PIO_32_RX_IO_MEM_WR32_DW1;
                end else begin
                  state        <= #TCQ PIO_32_RX_RST_STATE;
                end
              end

              default : begin // other TLPs
                state          <= #TCQ PIO_32_RX_RST_STATE;
              end
            endcase // trn_rd[30:24]
          end // (!trn_rsof_n) && (!trn_rsrc_rdy_n) && (!trn_rdst_rdy_n)
          else begin
            state <= #TCQ PIO_32_RX_RST_STATE;
          end
        end // PIO_32_RX_RST_STATE

        PIO_32_RX_MEM_RD32_DW1 : begin
          if ((!trn_rsrc_rdy_n) && (!trn_rdst_rdy_n)) begin
            req_rid_o          <= #TCQ trn_rd[31:16];
            req_tag_o          <= #TCQ trn_rd[15:8];
            req_be_o           <= #TCQ trn_rd[7:0];
            state              <= #TCQ PIO_32_RX_MEM_RD32_DW2;
          end else begin
            state              <= #TCQ PIO_32_RX_MEM_RD32_DW1;
          end
        end // PIO_32_RX_MEM_RD32_DW1

        PIO_32_RX_MEM_RD32_DW2 : begin
          if ((!trn_rsrc_rdy_n) && (!trn_rdst_rdy_n)) begin
            req_addr_o         <= #TCQ {region_select[1:0], trn_rd[10:2], 2'b00};
            req_compl_o        <= #TCQ 1'b1;
            trn_rdst_rdy_n     <= #TCQ 1'b1;

            state              <= #TCQ PIO_32_RX_WAIT_STATE;
          end else begin
            state              <= #TCQ PIO_32_RX_MEM_RD32_DW2;
          end
        end // PIO_32_RX_MEM_RD32_DW2

        PIO_32_RX_IO_MEM_WR32_DW1 : begin
          if ((!trn_rsrc_rdy_n) && (!trn_rdst_rdy_n)) begin
            wr_be_o            <= #TCQ trn_rd[7:0];
            state              <= #TCQ PIO_32_RX_IO_MEM_WR32_DW2;
          end else begin
            state              <= #TCQ PIO_32_RX_IO_MEM_WR32_DW1;
          end
        end // PIO_32_RX_IO_MEM_WR32_DW1

        PIO_32_RX_IO_MEM_WR32_DW2 : begin
          if ((!trn_rsrc_rdy_n) && (!trn_rdst_rdy_n)) begin
            wr_addr_o          <= #TCQ {region_select[1:0],trn_rd[10:2]};
            state              <= #TCQ PIO_32_RX_IO_MEM_WR32_DW3;
          end else begin
            state              <= #TCQ PIO_32_RX_IO_MEM_WR32_DW2;
          end
        end // PIO_32_RX_IO_MEM_WR32_DW2

        PIO_32_RX_IO_MEM_WR32_DW3 : begin
          if ((!trn_rsrc_rdy_n) && (!trn_rdst_rdy_n)) begin
            wr_data_o             <= #TCQ trn_rd[31:0];
            wr_en_o               <= #TCQ 1'b1;
            req_compl_o           <= #TCQ (tlp_type == PIO_32_RX_IO_WR32_FMT_TYPE);
            req_compl_with_data_o <= #TCQ 1'b0;
            trn_rdst_rdy_n        <= #TCQ 1'b1;

            state                 <= #TCQ PIO_32_RX_WAIT_STATE;
          end else begin
            state                 <= #TCQ PIO_32_RX_IO_MEM_WR32_DW3;
          end
        end // PIO_32_RX_IO_MEM_WR32_DW3

        PIO_32_RX_MEM_RD64_DW1 : begin
          if ((!trn_rsrc_rdy_n) && (!trn_rdst_rdy_n)) begin
            req_rid_o          <= #TCQ trn_rd[31:16];
            req_tag_o          <= #TCQ trn_rd[15:8];
            req_be_o           <= #TCQ trn_rd[7:0];
            state              <= #TCQ PIO_32_RX_MEM_RD64_DW2;
          end else begin
            state              <= #TCQ PIO_32_RX_MEM_RD64_DW1;
          end
        end // PIO_32_RX_MEM_RD64_DW1

        PIO_32_RX_MEM_RD64_DW2 : begin
          if ((!trn_rsrc_rdy_n) && (!trn_rdst_rdy_n)) begin
            state              <= #TCQ PIO_32_RX_MEM_RD64_DW3;
          end else begin
            state              <= #TCQ PIO_32_RX_MEM_RD64_DW2;
          end
        end // PIO_32_RX_MEM_RD64_DW2

        PIO_32_RX_MEM_RD64_DW3 : begin
          if ((!trn_rsrc_rdy_n) && (!trn_rdst_rdy_n)) begin
            req_addr_o         <= #TCQ {region_select[1:0],trn_rd[10:2], 2'b00};
            req_compl_o        <= #TCQ 1'b1;
            trn_rdst_rdy_n     <= #TCQ 1'b1;

            state              <= #TCQ PIO_32_RX_WAIT_STATE;
          end else begin
            state              <= #TCQ PIO_32_RX_MEM_RD64_DW3;
          end
        end // PIO_32_RX_MEM_RD64_DW3

        PIO_32_RX_MEM_WR64_DW1 : begin
          if ((!trn_rsrc_rdy_n) && (!trn_rdst_rdy_n)) begin
            wr_be_o            <= #TCQ trn_rd[7:0];
            state              <= #TCQ PIO_32_RX_MEM_WR64_DW2;
          end else begin
            state              <= #TCQ PIO_32_RX_MEM_WR64_DW1;
          end
        end // PIO_32_RX_MEM_WR64_DW1

        PIO_32_RX_MEM_WR64_DW2 : begin
          if ((!trn_rsrc_rdy_n) && (!trn_rdst_rdy_n)) begin
            state              <= #TCQ PIO_32_RX_MEM_WR64_DW3;
          end else begin
            state              <= #TCQ PIO_32_RX_MEM_WR64_DW2;
          end
        end // PIO_32_RX_MEM_WR64_DW2

        PIO_32_RX_MEM_WR64_DW3 : begin
          if ((!trn_rsrc_rdy_n) && (!trn_rdst_rdy_n)) begin
            wr_addr_o          <= #TCQ {region_select[1:0],trn_rd[10:2]};
            state              <= #TCQ PIO_32_RX_MEM_WR64_DW4;
          end else begin
            state              <= #TCQ PIO_32_RX_MEM_WR64_DW3;
          end
        end // PIO_32_RX_MEM_WR64_DW3

        PIO_32_RX_MEM_WR64_DW4 : begin
          if ((!trn_rsrc_rdy_n) && (!trn_rdst_rdy_n)) begin
            wr_data_o          <= #TCQ trn_rd[31:0];
            wr_en_o            <= #TCQ 1'b1;
            trn_rdst_rdy_n     <= #TCQ 1'b1;

            state              <= #TCQ PIO_32_RX_WAIT_STATE;
          end else begin
            state              <= #TCQ PIO_32_RX_MEM_WR64_DW4;
          end
        end // PIO_32_RX_MEM_WR64_DW4

        PIO_32_RX_WAIT_STATE : begin
          wr_en_o              <= #TCQ 1'b0;
          req_compl_o          <= #TCQ 1'b0;

          if ((tlp_type == PIO_32_RX_MEM_WR32_FMT_TYPE) && (!wr_busy_i)) begin
            trn_rdst_rdy_n     <= #TCQ 1'b0;
            state              <= #TCQ PIO_32_RX_RST_STATE;
          end else if ((tlp_type == PIO_32_RX_IO_WR32_FMT_TYPE) && (!wr_busy_i)) begin
            trn_rdst_rdy_n     <= #TCQ 1'b0;
            state              <= #TCQ PIO_32_RX_RST_STATE;
          end else if ((tlp_type == PIO_32_RX_MEM_WR64_FMT_TYPE) && (!wr_busy_i)) begin
            trn_rdst_rdy_n     <= #TCQ 1'b0;
            state              <= #TCQ PIO_32_RX_RST_STATE;
          end else if ((tlp_type == PIO_32_RX_MEM_RD32_FMT_TYPE) && (compl_done_i)) begin
            trn_rdst_rdy_n     <= #TCQ 1'b0;
            state              <= #TCQ PIO_32_RX_RST_STATE;
          end else if ((tlp_type == PIO_32_RX_IO_RD32_FMT_TYPE) && (compl_done_i)) begin
            trn_rdst_rdy_n     <= #TCQ 1'b0;
            state              <= #TCQ PIO_32_RX_RST_STATE;
          end else if ((tlp_type == PIO_32_RX_MEM_RD64_FMT_TYPE) && (compl_done_i)) begin
            trn_rdst_rdy_n     <= #TCQ 1'b0;
            state              <= #TCQ PIO_32_RX_RST_STATE;
          end else begin
            state              <= #TCQ PIO_32_RX_WAIT_STATE;
          end
        end // PIO_32_RX_WAIT_STATE
        default:
          state                <= #TCQ PIO_32_RX_RST_STATE;
      endcase // state
    end // rst_n
  end

  assign mem64_bar_hit_n = 1'b1;
  assign io_bar_hit_n = 1'b1;
  assign mem32_bar_hit_n = trn_rbar_hit_n[0];
  assign erom_bar_hit_n  = trn_rbar_hit_n[6];

  always @* begin
    case ({io_bar_hit_n, mem32_bar_hit_n, mem64_bar_hit_n, erom_bar_hit_n})
      4'b0111 : region_select <= #TCQ 2'b00; // Select IO region
      4'b1011 : region_select <= #TCQ 2'b01; // Select Mem32 region
      4'b1101 : region_select <= #TCQ 2'b10; // Select Mem64 region
      4'b1110 : region_select <= #TCQ 2'b11; // Select EROM region
      default : region_select <= #TCQ 2'b00; // Error selection will select IO region
    endcase
  end

  // synthesis translate_off
  reg  [8*20:1] state_ascii;
  always @(state) begin
    if      (state==PIO_32_RX_RST_STATE)         state_ascii <= #TCQ "RX_RST_STATE";
    else if (state==PIO_32_RX_MEM_RD32_DW1)      state_ascii <= #TCQ "RX_MEM_RD32_DW1";
    else if (state==PIO_32_RX_MEM_RD32_DW2)      state_ascii <= #TCQ "RX_MEM_RD32_DW2";
    else if (state==PIO_32_RX_IO_MEM_WR32_DW1)   state_ascii <= #TCQ "RX_IO_MEM_WR32_DW1";
    else if (state==PIO_32_RX_IO_MEM_WR32_DW2)   state_ascii <= #TCQ "RX_IO_MEM_WR32_DW2";
    else if (state==PIO_32_RX_IO_MEM_WR32_DW3)   state_ascii <= #TCQ "RX_IO_MEM_WR32_DW3";
    else if (state==PIO_32_RX_IO_MEM_WR32_DW4)   state_ascii <= #TCQ "RX_IO_MEM_WR32_DW4";
    else if (state==PIO_32_RX_MEM_RD64_DW1)      state_ascii <= #TCQ "RX_MEM_RD64_DW1";
    else if (state==PIO_32_RX_MEM_RD64_DW2)      state_ascii <= #TCQ "RX_MEM_RD64_DW2";
    else if (state==PIO_32_RX_MEM_RD64_DW3)      state_ascii <= #TCQ "RX_MEM_RD64_DW3";
    else if (state==PIO_32_RX_MEM_WR64_DW1)      state_ascii <= #TCQ "RX_MEM_WR64_DW1";
    else if (state==PIO_32_RX_MEM_WR64_DW2)      state_ascii <= #TCQ "RX_MEM_WR64_DW2";
    else if (state==PIO_32_RX_MEM_WR64_DW3)      state_ascii <= #TCQ "RX_MEM_WR64_DW3";
    else if (state==PIO_32_RX_MEM_WR64_DW4)      state_ascii <= #TCQ "RX_MEM_WR64_DW4";
    else if (state==PIO_32_RX_WAIT_STATE)        state_ascii <= #TCQ "RX_WAIT_STATE";
    else                                         state_ascii <= #TCQ "PIO 32 STATE ERR";
  end
  // synthesis translate_on

endmodule // PIO_32_RX_ENGINE

