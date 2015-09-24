`timescale 1ns / 1ps

module IP4776CZ38ExpansionModuleTransmitter(
 // Input clock assume to be 100 MHz
    input        CLK,
 // Active Low Reset     
    input        RST,
 // DVI differential output
    output [3:0] TMDS,
    output [3:0] TMDSN
    );

 // Register declared for internal purpose
  wire         pclk;
  wire         pclkx2;
  wire         pclkx10;
  wire         serdesstrobe;
  wire         pll_reset;
  wire         bufpll_lock;
  
 // PLL reset is Active High so provide compliment of the input reset. 
  assign pll_reset = ~ RST;
  
 // User Clock is assumed to be 100 MHz so obtain clock of 150 MHz for 1080p 
 // or 75 MHz for 720p using PLL.This clock is the pixel clock.
 
  clocking clocking_block(
    .CLK_IN(CLK),
    .CLK_OUT(pclk));
 
 //  PLL called to get x10 and x5 clock from the Pixel clock.
  PLL_BASE # (
    .CLKIN_PERIOD(10),
    .CLKFBOUT_MULT(10), 
    .CLKOUT0_DIVIDE(1),
    .CLKOUT1_DIVIDE(10),
    .CLKOUT2_DIVIDE(5),
    .COMPENSATION("SOURCE_SYNCHRONOUS")
  ) PLL_OSERDES_0 (
    .CLKFBOUT(clkfbout),
    .CLKOUT0(pllclk0),
    .CLKOUT1(),
    .CLKOUT2(pllclk2),
    .CLKOUT3(),
    .CLKOUT4(),
    .CLKOUT5(),
    .LOCKED(plllckd),
    .CLKFBIN(clkfbin),
    .CLKIN(pclk),
    .RST(pll_reset)
  );
  
  BUFG clkfb_buf (.I(clkfbout), .O(clkfbin));
  BUFG pclkx2_buf (.I(pllclk2), .O(pclkx2));
  BUFPLL #(.DIVIDE(5)) ioclk_buf (.PLLIN(pllclk0), .GCLK(pclkx2), .LOCKED(plllckd),
           .IOCLK(pclkx10), .SERDESSTROBE(serdesstrobe), .LOCK(bufpll_lock));
              
 // Register for internal purpose
  wire         de;            
  wire [7:0]   blue;
  wire [7:0]   green;
  wire [7:0]   red;
  wire         hsync;
  wire         vsync;         
  
 // Instantiate the VGA module giving the pattern to be displayed
  vga_top vga (
    .CLK(clkfbin),
    .hsync(hsync),
    .vsync(vsync),
    .blue(blue),
    .green(green),
    .red(red),
    .blank(de)
    );

 // DVI Encoder is driven by Active High reset so compliment the input reset     
    wire reset;
    assign reset = ~RST;

 // DVI Encoder for encoding the VGA signal.    
    dvi_encoder_top dvi_encoder (
    .pclk        (pclk),
    .pclkx2      (pclkx2),
    .pclkx10     (pclkx10),
    .serdesstrobe(serdesstrobe),
    .rstin       (reset),
    .blue_din    (blue),
    .green_din   (green),
    .red_din     (red),
    .hsync       (hsync),
    .vsync       (vsync),
    .de          (de),
    .TMDS        (TMDS),
    .TMDSB       (TMDSN)); 
     
     
endmodule
