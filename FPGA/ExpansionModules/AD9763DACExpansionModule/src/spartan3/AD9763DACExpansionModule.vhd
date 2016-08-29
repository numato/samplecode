------------------------------------------------------------------------
-- AD9763 DAC Expansion Module demo code
-- Numato Lab
-- http://www.numato.com
-- http://www.numato.cc
------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity AD9763DACExpansionModule is
  port ( 
         -- Assuming 100MHz input clock.My need to adjust the counter below
         -- if any other input frequency is used 
         clk                  : in  std_logic;
         -- Active low reset and select signal
         rst_n                : in  std_logic;
         sel_n                : in  std_logic_vector(3 downto 0);
         -- Interface with AD9763 DAC Expansion Module
         ad9763_dac_clk1      : out std_logic;
         ad9763_dac_clk2      : out std_logic;
         ad9763_dac_wrt1      : out std_logic;
         ad9763_dac_wrt2      : out std_logic;
         ad9763_dac_dbp1      : out std_logic_vector(9 downto 0);
         ad9763_dac_dbp2      : out std_logic_vector(9 downto 0));
end AD9763DACExpansionModule;

-- Implementation :- The AD9763 DAC Expansion Module,a dual-port high speed 10-bit CMOS Digital to Analog converter.
-- It can be operated in two mode Dual Mode and Interleving Mode. This demo code is for the dual mode of ooperation.
-- 4-bit sel_n signal is used for selecting the required analog output.

architecture rtl of AD9763DACExpansionModule is
    -- Register for internal purpose. 
    signal done     : std_logic := '0';
    signal clock    : std_logic := '0';
    signal count    : std_logic_vector(9 downto 0);

    type mem_array is array (0 to 15) of std_logic_vector(11 downto 0);
    signal address  : integer range 0 to 15 := 0;

------------------------- Sine Wave ---------------------------------------
constant sine : mem_array := (
x"200", x"2c3", x"369", x"3d8", x"3ff", x"3d8", x"369", x"2c3",
x"200", x"13c", x"096", x"027", x"000", x"027", x"096", x"13c"
);

---------------------- Decaying Wave --------------------------------------
constant expo : mem_array := (
x"3ff", x"224", x"125", x"09d", x"054", x"02d", x"018", x"00d",
x"007", x"004", x"002", x"001", x"001", x"000", x"000", x"000"
);

---------------------- triangle Wave --------------------------------------
constant triangle : mem_array := (
x"100", x"200", x"2ff", x"3ff", x"2ff", x"200", x"100", x"000",
x"100", x"200", x"2ff", x"3ff", x"2ff", x"200", x"100", x"000"
);

---------------------- ramp Wave --------------------------------------
constant ramp : mem_array := (
x"000", x"040", x"080", x"0C0", x"100",  x"140", x"180", x"1C0",
x"200", x"240", x"280", x"2C0", x"300",  x"340", x"380", x"3C0"
);

begin

    clk_int : entity work.clock_init
              port map ( CLKIN_IN  => clk,
                         CLKFX_OUT => clock
                        );
    
    ad9763_dac_wrt1 <=  clock;
    ad9763_dac_wrt2 <=  clock;
    ad9763_dac_clk1 <=  clock;
    ad9763_dac_clk2 <=  clock;
    
    -- Monitoring the clock and reset signal
    process(clock,rst_n) begin

        if (rst_n = '0') then 
            address            <= 0;
            count              <= (others => '0');
            ad9763_dac_dbp1    <= (others => '0');
            ad9763_dac_dbp2    <= (others => '0'); 

        elsif falling_edge(clock) then 
            
				if (address = 16) then
				    address <= 0;
				end if;
				
            case sel_n is
                --------------- Triangle Wave -------------------------------
                when "1110" =>
                    ad9763_dac_dbp1    <= triangle(address)(9 downto 0);
                    ad9763_dac_dbp2    <= triangle(address)(9 downto 0);
                    address            <= address + 1;

                ----------------- Ramp Waveform --------------------------
                when "1101" =>
                    ad9763_dac_dbp1    <= ramp(address)(9 downto 0);
                    ad9763_dac_dbp2    <= ramp(address)(9 downto 0);
                    address            <= address + 1;

                ----------------- Decaying Wave -------------------------- 
                when "1011" =>            
                    ad9763_dac_dbp1    <= expo(address)(9 downto 0);
                    ad9763_dac_dbp2    <= expo(address)(9 downto 0);
                    address            <= address + 1;

                ------------------------- Sine Wave -----------------------
                when others =>
                    ad9763_dac_dbp1    <= sine(address)(9 downto 0);
                    ad9763_dac_dbp2    <= sine(address)(9 downto 0);
                    address            <= address + 1;

            end case;
        end if;
    end process;
end rtl;