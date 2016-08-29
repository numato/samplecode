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
// File       : PIO_EP_MEM_ACCESS.v
// Description: Endpoint Memory Access Unit. This module provides access
//              functions to the Endpoint memory aperture.
//
//              Read Access: Module returns data for the specifed address and
//              byte enables selected.
//
//              Write Access: Module accepts data, byte enables and updates
//              data when write enable is asserted. Modules signals write busy
//              when data write is in progress.
//
//-----------------------------------------------------------------------------

`timescale 1ns/1ns

module PIO_EP_MEM_ACCESS (
  input                 clk,
  input                 rst_n,

  //
  //  Read Port
  //
  input       [10:0]    rd_addr_i,
  input       [3:0]     rd_be_i,
  output wire [31:0]    rd_data_o,

  //
  //  Write Port
  //
  input       [10:0]    wr_addr_i,
  input       [7:0]     wr_be_i,
  input       [31:0]    wr_data_i,
  input                 wr_en_i,
  output wire           wr_busy_o,
  
  
  output [7:0] PORT1,
  output [7:0] PORT2,
  output [7:0] PORT3,
  output [7:0] PORT4,
  output [7:0] PORT5,
  output [7:0] PORT6,
  output [7:0] PORT7
  
  );


  parameter       DEFAULT_READ = 1'b1;
  parameter       DEFAULT_WRITE = 1'b0; 
  
  // set od data registers
   reg [7:0] DATA_PORT1=8'h00;
   reg [7:0] DATA_PORT2=8'h00;
   reg [7:0] DATA_PORT3=8'h00;
   reg [7:0] DATA_PORT4=8'h00;
   reg [7:0] DATA_PORT5=8'h00;
   reg [7:0] DATA_PORT6=8'h00;
   reg [7:0] DATA_PORT7=8'h00;
   
   // set of direction registers
   reg DIR_PORT1=DEFAULT_WRITE;
   reg DIR_PORT2=DEFAULT_WRITE;
   reg DIR_PORT3=DEFAULT_WRITE;
   reg DIR_PORT4=DEFAULT_WRITE;
   reg DIR_PORT5=DEFAULT_WRITE;
   reg DIR_PORT6=DEFAULT_WRITE;
   reg DIR_PORT7=DEFAULT_WRITE;
   
    assign PORT1=DATA_PORT1;
	assign PORT2=DATA_PORT2;
	assign PORT3=DATA_PORT3;
	assign PORT4=DATA_PORT4;
	assign PORT5=DATA_PORT5;
	assign PORT6=DATA_PORT6;
	assign PORT7=DATA_PORT7;
		

	// port one
	always@ (posedge clk)
		begin
			case(DIR_PORT1)
				DEFAULT_WRITE : begin
								  if(wr_addr_i[7:0]==8'h00) 
									begin
									  DATA_PORT1<= post_wr_data[7:0];
									end
							    end
				DEFAULT_READ :  begin
								 if(rd_addr_i[7:0]==8'h00) 
								   begin
									 rd_data_raw_o[7:0]<=DATA_PORT1;
								   end
							    end
		    endcase
		end
	
		// port two
	always@ (posedge clk)
		begin
			case(DIR_PORT2)
				DEFAULT_WRITE : begin
								  if(wr_addr_i[7:0]==8'h01) 
									begin
									  DATA_PORT2<= post_wr_data[7:0];
									end
							    end
				DEFAULT_READ :  begin
								 if(rd_addr_i[7:0]==8'h01) 
								   begin
									 rd_data_raw_o[7:0]<= DATA_PORT2;
								   end
							    end
		    endcase
		end
	
	
		// port three
	always@ (posedge clk)
		begin
			case(DIR_PORT3)
				DEFAULT_WRITE : begin
								  if(wr_addr_i[7:0]==8'h02) 
								    begin
									  DATA_PORT3<= post_wr_data[7:0];
								    end
							    end
				DEFAULT_READ :  begin
								  if(rd_addr_i[7:0]==8'h02) 
									begin
									  rd_data_raw_o[7:0]<= DATA_PORT3;
									end
							    end
		    endcase
		end
	
	// port four
	
	always@ (posedge clk)
		begin
			case(DIR_PORT4)
				DEFAULT_WRITE : begin
								  if(wr_addr_i[7:0]==8'h03) 
									begin
									  DATA_PORT4<= post_wr_data[7:0];
									end
							    end
				DEFAULT_READ :  begin
								  if(rd_addr_i[7:0]==8'h03) 
								    begin
									  rd_data_raw_o[7:0]<=DATA_PORT4;
									end
							    end
		    endcase
		end
		
		
// port five
	always@ (posedge clk)
		begin
			case(DIR_PORT5)
				DEFAULT_WRITE : begin
								  if(wr_addr_i[7:0]==8'h04) 
									begin
									  DATA_PORT5<= post_wr_data[7:0];
									end
							    end
				DEFAULT_READ :  begin
								  if(rd_addr_i[7:0]==8'h04) 
									begin
									  rd_data_raw_o[7:0] <= DATA_PORT5;
									end
							    end
		    endcase
		end
	
	
		// port six
	always@ (posedge clk)
		begin
			case(DIR_PORT6)
				DEFAULT_WRITE : begin
								  if(wr_addr_i[7:0]==8'h05) 
									begin
									  DATA_PORT6<= post_wr_data[7:0];
									end
							    end
				DEFAULT_READ :  begin
								  if(rd_addr_i[7:0]==8'h05) 
									begin
									  rd_data_raw_o[7:0]<= DATA_PORT6;
									end
							    end
		    endcase
		end
	
		// port seven
	always@ (posedge clk)
		begin
			case(DIR_PORT7)
				DEFAULT_WRITE : begin
								  if(wr_addr_i[7:0]==8'h06) 
									begin
									  DATA_PORT7<= post_wr_data[7:0];
								    end
							    end
				DEFAULT_READ :  begin
								  if(rd_addr_i[7:0]==8'h06) 
								    begin
									  rd_data_raw_o[7:0] <=DATA_PORT7;
									end
							    end
		    endcase
		end

  localparam       TCQ = 1;  // Clock-to-out delay

  localparam       PIO_MEM_ACCESS_WR_RST   = 3'b000;
  localparam       PIO_MEM_ACCESS_WR_WAIT  = 3'b001;
  localparam       PIO_MEM_ACCESS_WR_READ  = 3'b010;
  localparam       PIO_MEM_ACCESS_WR_WRITE = 3'b100;

  reg   [31:0]     rd_data_raw_o;

  wire  [31:0]     rd_data0_o, rd_data1_o, rd_data2_o, rd_data3_o;

  reg              write_en;
  reg   [31:0]     post_wr_data;
  reg   [31:0]     w_pre_wr_data;

  reg   [2:0]      wr_mem_state;

  reg   [31:0]     pre_wr_data;
  wire  [31:0]     w_pre_wr_data0;
  wire  [31:0]     w_pre_wr_data1;
  wire  [31:0]     w_pre_wr_data2;
  wire  [31:0]     w_pre_wr_data3;

  reg   [31:0]     DW0, DW1, DW2;


  //
  // Memory Write Process
  //

  //
  //  Extract current data bytes. These need to be swizzled
  //  BRAM storage format :
  //    data[31:0] = { byte[3], byte[2], byte[1], byte[0] (lowest addr) }
  //
  wire  [7:0]      w_pre_wr_data_b3 = pre_wr_data[31:24];
  wire  [7:0]      w_pre_wr_data_b2 = pre_wr_data[23:16];
  wire  [7:0]      w_pre_wr_data_b1 = pre_wr_data[15:08];
  wire  [7:0]      w_pre_wr_data_b0 = pre_wr_data[07:00];

  //
  //  Extract new data bytes from payload
  //  TLP Payload format :
  //    data[31:0] = { byte[0] (lowest addr), byte[2], byte[1], byte[3] }
  //
  wire  [7:0]      w_wr_data_b3 = wr_data_i[07:00];
  wire  [7:0]      w_wr_data_b2 = wr_data_i[15:08];
  wire  [7:0]      w_wr_data_b1 = wr_data_i[23:16];
  wire  [7:0]      w_wr_data_b0 = wr_data_i[31:24];


  always @(posedge clk) begin
    if ( !rst_n ) begin
      pre_wr_data    <= #TCQ 32'b0;
      post_wr_data   <= #TCQ 32'b0;
      pre_wr_data    <= #TCQ 32'b0;
      write_en       <= #TCQ 1'b0;

      wr_mem_state   <= #TCQ PIO_MEM_ACCESS_WR_RST;
    end else begin
      case (wr_mem_state)
        PIO_MEM_ACCESS_WR_RST : begin
          if (wr_en_i) begin // read state
            wr_mem_state <= #TCQ PIO_MEM_ACCESS_WR_WAIT; // Pipelining happens in RAM's internal output reg.
          end else begin
            write_en     <= #TCQ 1'b0;

            wr_mem_state <= #TCQ PIO_MEM_ACCESS_WR_RST;
          end
        end

        PIO_MEM_ACCESS_WR_WAIT : begin
          //
          // Pipeline B port data before processing. Block RAMs have internal
          // output register enabled.
          //
          //
          write_en     <= #TCQ 1'b0;

          wr_mem_state <= #TCQ PIO_MEM_ACCESS_WR_READ;
        end

        PIO_MEM_ACCESS_WR_READ : begin
          //
          // Now save the selected BRAM B port data out
          //
          pre_wr_data  <= #TCQ w_pre_wr_data;
          write_en     <= #TCQ 1'b0;

          wr_mem_state <= #TCQ PIO_MEM_ACCESS_WR_WRITE;
        end

        PIO_MEM_ACCESS_WR_WRITE : begin
          //
          // Merge new enabled data and write target BlockRAM location
          //
          post_wr_data <= #TCQ {{wr_be_i[3] ? w_wr_data_b3 : w_pre_wr_data_b3},
                                {wr_be_i[2] ? w_wr_data_b2 : w_pre_wr_data_b2},
                                {wr_be_i[1] ? w_wr_data_b1 : w_pre_wr_data_b1},
                                {wr_be_i[0] ? w_wr_data_b0 : w_pre_wr_data_b0}};
          write_en     <= #TCQ 1'b1;

          wr_mem_state <= #TCQ PIO_MEM_ACCESS_WR_RST;
        end
        default:
          wr_mem_state <= #TCQ PIO_MEM_ACCESS_WR_RST;
      endcase
    end
  end

  //
  // Write controller busy
  //
  assign wr_busy_o = wr_en_i || (wr_mem_state != PIO_MEM_ACCESS_WR_RST);

  //
  //  Select BlockRAM output based on higher 2 address bits
  //
  always @* begin
    case ({wr_addr_i[10:9]})
      2'b00 : w_pre_wr_data = w_pre_wr_data0;
      2'b01 : w_pre_wr_data = w_pre_wr_data1;
      2'b10 : w_pre_wr_data = w_pre_wr_data2;
      2'b11 : w_pre_wr_data = w_pre_wr_data3;
    endcase
  end

  //
  //  Memory Read Controller
  //
  wire        rd_data0_en = {rd_addr_i[10:9]  == 2'b00};
  wire        rd_data1_en = {rd_addr_i[10:9]  == 2'b01};
  wire        rd_data2_en = {rd_addr_i[10:9]  == 2'b10};
  wire        rd_data3_en = {rd_addr_i[10:9]  == 2'b11};

  always @* begin
    case ({rd_addr_i[10:9]})
      2'b00 : rd_data_raw_o = rd_data0_o;
      2'b01 : rd_data_raw_o = rd_data1_o;
      2'b10 : rd_data_raw_o = rd_data2_o;
      2'b11 : rd_data_raw_o = rd_data3_o;
    endcase
  end

  // Handle Read byte enables
  assign rd_data_o = {{rd_be_i[0] ? rd_data_raw_o[07:00] : 8'h0},
                      {rd_be_i[1] ? rd_data_raw_o[15:08] : 8'h0},
                      {rd_be_i[2] ? rd_data_raw_o[23:16] : 8'h0},
                      {rd_be_i[3] ? rd_data_raw_o[31:24] : 8'h0}};

  PIO_EP_MEM EP_MEM (
    .clk_i(clk),

    .a_rd_a_i_0(rd_addr_i[8:0]),              // I [8:0]
    .a_rd_en_i_0(rd_data0_en),                // I [1:0]
    .a_rd_d_o_0(rd_data0_o),                  // O [31:0]

    .b_wr_a_i_0(wr_addr_i[8:0]),              // I [8:0]
    .b_wr_d_i_0(post_wr_data),                // I [31:0]
    .b_wr_en_i_0({write_en && (wr_addr_i[10:9] == 2'b00)}), // I
    .b_rd_d_o_0(w_pre_wr_data0[31:0]),        // O [31:0]
    .b_rd_en_i_0({wr_addr_i[10:9] == 2'b00}), // I

    .a_rd_a_i_1(rd_addr_i[8:0]),              // I [8:0]
    .a_rd_en_i_1(rd_data1_en),                // I [1:0]
    .a_rd_d_o_1(rd_data1_o),                  // O [31:0]

    .b_wr_a_i_1(wr_addr_i[8:0]),              // [8:0]
    .b_wr_d_i_1(post_wr_data),                // [31:0]
    .b_wr_en_i_1({write_en && (wr_addr_i[10:9] == 2'b01)}), // I
    .b_rd_d_o_1(w_pre_wr_data1[31:0]),        // [31:0]
    .b_rd_en_i_1({wr_addr_i[10:9] == 2'b01}), // I

    .a_rd_a_i_2(rd_addr_i[8:0]),              // I [8:0]
    .a_rd_en_i_2(rd_data2_en),                // I [1:0]
    .a_rd_d_o_2(rd_data2_o),                  // O [31:0]

    .b_wr_a_i_2(wr_addr_i[8:0]),              // I [8:0]
    .b_wr_d_i_2(post_wr_data),                // I [31:0]
    .b_wr_en_i_2({write_en && (wr_addr_i[10:9] == 2'b10)}), // I
    .b_rd_d_o_2(w_pre_wr_data2[31:0]),        // I [31:0]
    .b_rd_en_i_2({wr_addr_i[10:9] == 2'b10}), // I

    .a_rd_a_i_3(rd_addr_i[8:0]),              // [8:0]
    .a_rd_en_i_3(rd_data3_en),                // [1:0]
    .a_rd_d_o_3(rd_data3_o),                  // O [31:0]

    .b_wr_a_i_3(wr_addr_i[8:0]),              // I [8:0]
    .b_wr_d_i_3(post_wr_data),                // I [31:0]
    .b_wr_en_i_3({write_en && (wr_addr_i[10:9] == 2'b11)}), // I
    .b_rd_d_o_3(w_pre_wr_data3[31:0]),        // I [31:0]
    .b_rd_en_i_3({wr_addr_i[10:9] == 2'b11})  // I
   );

  // synthesis translate_off
  reg  [8*20:1] state_ascii;
  always @(wr_mem_state) begin
    if      (wr_mem_state==PIO_MEM_ACCESS_WR_RST)    state_ascii <= #TCQ "PIO_MEM_WR_RST";
    else if (wr_mem_state==PIO_MEM_ACCESS_WR_WAIT)   state_ascii <= #TCQ "PIO_MEM_WR_WAIT";
    else if (wr_mem_state==PIO_MEM_ACCESS_WR_READ)   state_ascii <= #TCQ "PIO_MEM_WR_READ";
    else if (wr_mem_state==PIO_MEM_ACCESS_WR_WRITE)  state_ascii <= #TCQ "PIO_MEM_WR_WRITE";
    else                                             state_ascii <= #TCQ "PIO MEM STATE ERR";
  end
  // synthesis translate_on

endmodule

