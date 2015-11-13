library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_driver is
    generic (FPGA_Clock            : integer   := 100_000;                       -- FPGA clock frequency in KHz
             NumOfstd_logics_Red   : integer   := 3;                             -- Data width for Red, Green and Blue 
             NumOfstd_logics_Green : integer   := 3;
             NumOfstd_logics_Blue  : integer   := 2;
             HResolution           : integer   := 640;                           -- Horizontal pixel resolution 
             HFrontPorch           : integer   := 16;                            -- Horizontal Front Pouch
             HSyncPulse            : integer   := 96;                            -- Horizontal Sync Pulse
             HBackPorch            : integer   := 48;                            -- Horizontal Back Pouch
             HSync_POL             : std_logic := '0';           
             VResolution           : integer   := 480;                           -- Vertical pixel resolution 
             VFrontPorch           : integer   := 11;                            -- Vertical Front Pouch
             VSyncPulse            : integer   := 2;                             -- Vertical Sync Pulse
             VBackPorch            : integer   := 31;                            -- Vertical Back Pouch
             VSync_POL             : std_logic := '0';
             PixelClock            : integer   := 25_000                         -- Pixel clock frequency in KHz   
            );
            
    port ( clk     : in std_logic;                                               -- Clock assume to be 100 MHz.
                                                                                 -- Change Generic variable FPGA_Clock if frequency is different    
           rst_n   : in std_logic;                                               -- Active Low Reset
           pix_clk : out std_logic;                                              -- Output the Pixel clock (use if required !!) 
           H_Sync  : out std_logic;                                              -- Horizontal Sync Signal
           V_Sync  : out std_logic;                                              -- Vertical Sync Signal
           Red     : out std_logic_vector(NumOfstd_logics_Red-1 downto 0);       -- Red colour
           Green   : out std_logic_vector(NumOfstd_logics_Green-1 downto 0);     -- Green colour
           Blue    : out std_logic_vector(NumOfstd_logics_Blue-1 downto 0)       -- Blue colour
          );
end vga_driver;

architecture rtl of vga_driver is
  -- Signal used for internal purpose 
    signal clk_count          : integer   := ((FPGA_Clock/PixelClock)/2) - 1;
    signal HCount,nxt_HCount  : integer   := 0;
    signal VCount,nxt_VCount  : integer   := 0;
    signal clock,reset        : std_logic := '0';   
    signal act_process        : std_logic := '0';
    signal hsync_d,hsync_q    : std_logic := '0';
    signal vsync_d,vsync_q    : std_logic := '0';
    signal red_d,red_q        : std_logic_vector(NumOfstd_logics_Red-1 downto 0)   := (others => '0');
    signal green_d,green_q    : std_logic_vector(NumOfstd_logics_Green-1 downto 0) := (others => '0');
    signal blue_d,blue_q      : std_logic_vector(NumOfstd_logics_Blue-1 downto 0)  := (others => '0');
    signal done               : std_logic := '0';

    -- Register to convert the integer value to vector.
    signal count_h            : std_logic_vector(11 downto 0);
    signal count_v            : std_logic_vector(11 downto 0);
    signal color              : integer := 255;
begin
  -- Assigning final output 
    H_Sync  <= hsync_q;
    V_Sync  <= vsync_q;
    Red     <= red_q;
    Green   <= green_q;
    Blue    <= blue_q;
    pix_clk <= clock;

    -- Obtained the Pixel clock
    p0 : process(clk,rst_n)                                             -- Process p0 start looking for change in clock & reset s/g 
         begin
            if (rst_n = '0') then                                       -- Look if Reset if given
                clock     <= '0';
                reset     <= '0';
                clk_count <=((FPGA_Clock/PixelClock)/2) - 1;
            elsif rising_edge(clk) then                                 -- Process condition on every rising edge of FPGA clock
                reset     <= '1';
                if (clk_count = 0) then
                    clock     <= not clock;
                    clk_count <=((FPGA_Clock/PixelClock)/2) - 1; 
                else    
                    clk_count <= clk_count - 1; 
                end if;
            end if;
         end process p0;                                                 -- Process p0 ends here

    -- Evaluate the state of signal and assign result of every rising edge of clock
    p1 : process(clock,reset) begin                                      -- On the reduce clock i.e Pixel clock process start
             if (reset = '0') then                                       -- Look for the reset
                 nxt_HCount  <= 0;
                 nxt_VCount  <= 0;
                 act_process <= '0';
                 hsync_q     <= not HSync_POL;
                 vsync_q     <= not VSync_POL;
                 red_q       <= (others => '0');
                 green_q     <= (others => '0');
                 blue_q      <= (others => '0');
             elsif rising_edge(clock) then                               -- On every rising edge of Pixel clock 
                 nxt_HCount  <= HCount;
                 nxt_VCount  <= VCount;
                 act_process <= not act_process;
                 hsync_q     <= hsync_d;
                 vsync_q     <= vsync_d;
                 red_q       <= red_d;
                 green_q     <= green_d;
                 blue_q      <= blue_d;
             end if;
         end process p1;

    p2 : process(act_process)
             -- Calculate total period
             variable Hori_period    : integer := HResolution + HFrontPorch + HBackPorch + HSyncPulse;
             variable Veri_period    : integer := VResolution + VFrontPorch + VBackPorch + VSyncPulse;
         begin
             -- Obtained final output.
             hsync_d <= hsync_q;
             vsync_d <= vsync_q;
             red_d   <= red_q;
             green_d <= green_q;
             blue_d  <= blue_q;
             HCount  <= nxt_HCount;
             VCount  <= nxt_VCount;
             
             -- Monitor horizontal period
             if (nxt_HCount  = Hori_period-1) then
                 HCount <= 0;
                 -- Monitor vertical period
                 if (nxt_VCount = Veri_period-1) then
                     VCount <= 0;
                 else
                     VCount <= nxt_VCount + 1;
                 end if;
             else
                 HCount <= nxt_HCount + 1;
             end if;
             
             -- Toggle Horizontal sync
             if (nxt_HCount >= HResolution+HFrontPorch and nxt_HCount < HResolution+HFrontPorch+HSyncPulse) then
                 hsync_d <= HSync_POL;
             else
                 hsync_d <= not HSync_POL;
             end if;
             
             -- Toggle veritcal sync
             if (nxt_VCount >= VResolution+VFrontPorch and nxt_VCount < VResolution+VFrontPorch+VSyncPulse) then
                 vsync_d <= VSync_POL;
             else
                 vsync_d <= not VSync_POL;
             end if;
             
             -- Uncomment below section to obtained different pattern
--           if (nxt_HCount < HResolution and nxt_VCount < VResolution) then
--              red_d    <= (others => '0');
--              green_d  <= (others => '0');
--              blue_d   <= (others => '0');
--              if (nxt_VCount <= VResolution/3) then
--                 red_d <= (others => '0');
--              elsif (nxt_VCount <= (VResolution/3) + (VResolution/3)) then
--                 green_d <= (others => '1');
--              else
--                 blue_d <= (others => '0');
--              end if;
--           end if;
             
             -- Display pattern on TFT screen
             count_h <= std_logic_vector(to_unsigned(nxt_HCount,count_h'length));
             count_v <= std_logic_vector(to_unsigned(nxt_VCount,count_v'length));

             -- If in display range
             if (nxt_HCount < HResolution and nxt_VCount < VResolution) then
                red_d   <= count_h(5 downto 4) & count_h(5 downto 0);
                green_d <= count_h(7 downto 0);
                blue_d  <= count_v(7 downto 0);
            end if;
         end process p2; 
end rtl;