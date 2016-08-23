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

module mod_m_counter
   #(
    parameter N=1, // counter width
              M=1 // modM
   )
   (
    input wire clk, reset,
    output wire max_tck,
    output wire [N-1:0] q
   );

 
   reg [N-1:0] r_reg;
   wire [N-1:0] r_next;

   
   always @(posedge clk, posedge reset)
      if (reset)
         r_reg <= 0;
      else
         r_reg <= r_next;

  
   assign r_next = (r_reg==(M-1)) ? 0 : r_reg + 1;
   
   assign q = r_reg;
   assign max_tck = (r_reg==(M-1)) ? 1'b1 : 1'b0;

endmodule