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

module uart_rx
   #(
     parameter DBIT = 8,     // No of data bits
               SB_tck = 16  // No of tcks for stop bits
   )
   (
    input wire clk, reset,
    input wire rx, s_tck,
    output reg rx_done_tck,
    output wire [7:0] dout
   );

   
   localparam [1:0] idle  = 2'b00,start = 2'b01,data  = 2'b10,stop  = 2'b11;

   
   reg [1:0] state_reg, state_next;
   reg [3:0] s, s_next;
   reg [2:0] n, n_next;
   reg [7:0] b, b_next;

  
   always @(posedge clk, posedge reset)
      if (reset)
         begin
            state_reg <= idle;
            s <= 0;
            n <= 0;
            b <= 0;
         end
      else
         begin
            state_reg <= state_next;
            s <= s_next;
            n <= n_next;
            b <= b_next;
         end

  
   always @*
   begin
      state_next = state_reg;
      rx_done_tck = 1'b0;
      s_next = s;
      n_next = n;
      b_next = b;
      case (state_reg)
         idle:
            if (~rx)
               begin
                  state_next = start;
                  s_next = 0;
               end
         start:
            if (s_tck)
               if (s==7)
                  begin
                     state_next = data;
                     s_next = 0;
                     n_next = 0;
                  end
               else
                  s_next = s + 1;
         data:
            if (s_tck)
               if (s==15)
                  begin
                     s_next = 0;
                     b_next = {rx, b[7:1]};
                     if (n==(DBIT-1))
                        state_next = stop ;
                      else
                        n_next = n + 1;
                   end
               else
                  s_next = s + 1;
         stop:
            if (s_tck)
               if (s==(SB_tck-1))
                  begin
                     state_next = idle;
                     rx_done_tck =1'b1;
                  end
               else
                  s_next = s + 1;
      endcase
   end
   
   assign dout = b;

endmodule