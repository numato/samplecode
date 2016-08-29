library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LCDExpansionModule5Inch is
    generic (FPGA_Clock            : integer   := 100_000;                       -- FPGA clock frequency in KHz
             NumOfstd_logics_Red   : integer   := 8;                             -- Data width for Red, Green and Blue 
             NumOfstd_logics_Green : integer   := 8;
             NumOfstd_logics_Blue  : integer   := 8;
             HResolution           : integer   := 480;                           -- Horizontal pixel resolution 
             HFrontPorch           : integer   := 16;                             -- Horizontal Front Pouch
             HSyncPulse            : integer   := 96;                            -- Horizontal Sync Pulse
             HBackPorch            : integer   := 48;                            -- Horizontal Back Pouch
             HSync_POL             : std_logic := '1';
             VResolution           : integer   := 272;                           -- Vertical pixel resolution 
             VFrontPorch           : integer   := 31;                            -- Vertical Front Pouch
             VSyncPulse            : integer   := 2;                             -- Vertical Sync Pulse
             VBackPorch            : integer   := 10;                            -- Vertical Back Pouch
             VSync_POL             : std_logic := '1';
             PixelClock            : integer   := 10_000                         -- Pixel clock frequency in KHz
            );
    port ( clk     : in std_logic;                                               -- Clock assume to be 100 MHz.
                                                                                 -- Change Generic variable FPGA_Clock if frequency is different    
           rst_n   : in std_logic;                                               -- Active Low Reset
           D_EN    : out std_logic;
           D_ON    : out std_logic;
           D_CLK   : out std_logic;                                              -- Output the Pixel clock (use if required !!) 
           H_Sync  : out std_logic;                                              -- Horizontal Sync Signal
           V_Sync  : out std_logic;                                              -- Vertical Sync Signal
           Red     : out std_logic_vector(NumOfstd_logics_Red-1 downto 0);       -- Red colour
           Green   : out std_logic_vector(NumOfstd_logics_Green-1 downto 0);     -- Green colour
           Blue    : out std_logic_vector(NumOfstd_logics_Blue-1 downto 0)       -- Blue colour
          );
end LCDExpansionModule5Inch;

architecture rtl of LCDExpansionModule5Inch is
begin
    -- Manage ON/OFF switching of LCD
    process(clk,rst_n) begin
        if (rst_n = '0') then
            D_EN  <= '0';
            D_ON  <= '0';
        elsif rising_edge(clk) then
            D_ON  <= '1';
            D_EN  <= '1';
        end if;
    end process;

    -- Instantiate VGA Drive
    controller : entity work.vga_driver
       generic map(FPGA_Clock            => FPGA_Clock,
                   NumOfstd_logics_Red   => NumOfstd_logics_Red,
                   NumOfstd_logics_Green => NumOfstd_logics_Green,
                   NumOfstd_logics_Blue  => NumOfstd_logics_Blue,
                   HResolution           => HResolution,
                   HFrontPorch           => HFrontPorch,
                   HSyncPulse            => HSyncPulse,
                   HBackPorch            => HBackPorch,
                   HSync_POL             => HSync_POL,
                   VResolution           => VResolution,
                   VFrontPorch           => VFrontPorch,
                   VSyncPulse            => VSyncPulse,
                   VBackPorch            => VBackPorch,
                   VSync_POL             => VSync_POL,
                   PixelClock            => PixelClock
                )
       port map (clk     => clk,
                 rst_n   => rst_n,
                 pix_clk => D_CLK,
                 H_Sync  => H_Sync,
                 V_Sync  => V_Sync,
                 Red     => Red,
                 Green   => Green,
                 Blue    => Blue
            );

end rtl;
