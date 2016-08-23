//////////////////////////////////////////////////////////////////////////////
/// Copyright (c) 2014, Ajit Mathew <ajitmathew04@gmail.com>
/// All rights reserved.
///
// Redistribution and use in source and binary forms, with or without modification, 
/// are permitted provided that the following conditions are met:
///
///  * Redistributions of source code must retain the above copyright notice, 
///    this list of conditions and the following disclaimer.
///  * Redistributions in binary form must reproduce the above copyright notice, 
///    this list of conditions and the following disclaimer in the documentation and/or 
///    other materials provided with the distribution.
///
///    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
///    EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
///    OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT 
///    SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
///    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
///    LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
///    PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
///    WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
///    ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
///   POSSIBILITY OF SUCH DAMAGE.
///
///
///  * http://opensource.org/licenses/MIT
///  * http://copyfree.org/licenses/mit/license.txt
///
//////////////////////////////////////////////////////////////////////////////

module uart
   #(
      parameter Data_Bits = 8,     
                StopBits_tick = 16, 
                DIVISOR = 651,    // divider circuit = 100M/(16*baud rate)
                DVSR_BIT = 9, // # bits of divider circuit
                FIFO_Add_Bit = 2
   )
   (
    input wire clk, reset,
    input wire rd_uart, wr_uart, rx,
    input wire [7:0] w_data,
    output wire tx_full, rx_empty, tx,
    output wire [7:0] r_data
   );

   // signal declaration
   wire tck, rx_done_tck, tx_done_tck;
   wire tx_empty, tx_fifo_not_empty;
   wire [7:0] tx_fifo_out, rx_data_out;
	
	wire clkout = clk;

	//UART_clk USART_CLOCK(clk,clkout);
   
   //body
   mod_m_counter #(.M(DIVISOR), .N(DVSR_BIT)) baud_gen_unit
      (.clk(clkout), .reset(reset), .q(), .max_tck(tck));

   uart_rx #(.DBIT(Data_Bits), .SB_tck(StopBits_tick)) uart_rx_unit
      (.clk(clkout), .reset(reset), .rx(rx), .s_tck(tck),
       .rx_done_tck(rx_done_tck), .dout(rx_data_out));

   fifo #(.B(Data_Bits), .W(FIFO_Add_Bit )) fifo_rx_unit
      (.clk(clkout), .reset(reset), .rd(rd_uart),
       .wr(rx_done_tck), .w_data(rx_data_out),
       .empty(rx_empty), .full(), .r_data(r_data));

   fifo #(.B(Data_Bits), .W(FIFO_Add_Bit )) fifo_tx_unit
      (.clk(clkout), .reset(reset), .rd(tx_done_tck),
       .wr(wr_uart), .w_data(w_data), .empty(tx_empty),
       .full(tx_full), .r_data(tx_fifo_out));

   uart_tx #(.DBIT(Data_Bits), .SB_tck(StopBits_tick)) uart_tx_unit
      (.clk(clkout), .reset(reset), .tx_start(tx_fifo_not_empty),
       .s_tck(tck), .din(tx_fifo_out),
       .tx_done_tck(tx_done_tck), .tx(tx));

   assign tx_fifo_not_empty = ~tx_empty;

endmodule