
------------------------------------------------------------------------
-- ElbertV2 demo code
-- Numato Lab
-- http://www.numato.com
-- http://www.numato.cc
-- License : CC BY-SA (http:-creativecommons.org/licenses/by-sa/2.0/)
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ElbertV2TopModule is
  port ( --Input's
          -- Assuming 12MHz input clock. My need to adjust the clocking_inst below
          -- if any other input frequency is used
                Clk   : IN STD_LOGIC;
			 
			 -- Input from the on board push buttons and DIP Switches.
              	Switch   : IN STD_LOGIC_VECTOR(5 downto 0); 
               DPSwitch : IN STD_LOGIC_VECTOR(7 downto 0);
								
			-- Output
			  -- ElbertV2 VGA Display
			       hsync    : OUT STD_LOGIC;
                vsync    : OUT STD_LOGIC;
                Red      : OUT STD_LOGIC_VECTOR(2 downto 0);
                Green    : OUT STD_LOGIC_VECTOR(2 downto 0);
                Blue     : OUT STD_LOGIC_VECTOR(2 downto 1);
			  
			  -- ElbertV2 Audio
			       Audio_L	 : OUT STD_LOGIC;
					 Audio_R	 : OUT STD_LOGIC;

			  -- ElbertV2 Seven Segment Display
			       SevenSegment : OUT STD_LOGIC_VECTOR(7 downto 0);
                Enable       : OUT STD_LOGIC_VECTOR(2 downto 0);
					 
			  -- ElbertV2 LED
			       LED      : INOUT STD_LOGIC_VECTOR(7 downto 0);
			  
			  -- ElbertV2 Ports
			  -- The two GPI of Port P5 i.e, PIN 2 and PIN 8.
			       IO_P1   : OUT   STD_LOGIC_VECTOR(7 downto 0);
					 IO_P2   : OUT   STD_LOGIC_VECTOR(7 downto 0);
					 IO_P4   : OUT   STD_LOGIC_VECTOR(7 downto 0);
                IO_P5   : INOUT STD_LOGIC_VECTOR(7 downto 0);
					 IO_P6   : OUT   STD_LOGIC_VECTOR(7 downto 0)
		  );
	
end ElbertV2TopModule;

architecture Behavioral of ElbertV2TopModule is

 component clocking
        port(-- Input clock of 12MHz
             CLKIN_IN         : in     std_logic;
             -- Output clock has to be 100 MHz.If input clock frequency changes then 
             -- make necessary changes in clocking_inst to get 100MHz clock.				 
             CLKFX_OUT          : out    std_logic
             );
 end component;
 
 component ElbertV2VGA 
    port    (   -- Input Clock 100MHz
                Clk   : in std_logic;
                -- Output for the VGA Display
                hsync    : out std_logic;
                vsync    : out std_logic;
                Red      : out std_logic_vector(2 downto 0);
                Green    : out std_logic_vector(2 downto 0);
                Blue     : out std_logic_vector(2 downto 1)
            );
 end component;

 component ElbertV2Audio 
                port     ( -- Input Clock 100 MHz
                           Clk : in std_logic;                       
							      -- Output Audio 
									Audio_L	  : out std_logic;
                           Audio_R	  : out std_logic									
                          ); 
 end component;
 
 component ElbertV2SevenSegmentDisplay 
                       port    ( -- Input Clk 100 MHz
                                 Clk          : in std_logic;
											-- Input from Dip Switches and two GPI's for P5 Header two control the Seven Segment
											DPSwitch     : in std_logic_vector(7 downto 0);
											IO_P5_i      : in std_logic_vector(1 downto 0);
                                  -- Output fot Seven Segment Display
							            SevenSegment : out std_logic_vector(7 downto 0);
                                 Enable       : out std_logic_vector(2 downto 0)
                                );
 										  
 end component;
 
 component ElbertV2RunningLight 
                      port    ( -- Input Clk 100 MHz       
                                Clk  : in std_logic;
		                          Switch   : in std_logic_vector(5 downto 0);
										  -- Output to on board LED
		                          LED    : out std_logic_vector(7 downto 0)
		                         );  
  end component;
signal   clock   : std_logic := '0';
signal   IO_P5_i : std_logic_vector(1 downto 0) := (others => '0');
begin
 IO_P5_i <= IO_P5(1) & IO_P5(7);
 -- The respective files are instantiated for the Top Module
 
  clocking_inst : clocking
   port map (CLKIN_IN        => Clk,
             CLKFX_OUT       => clock
             );
				 
  VGA_inst : ElbertV2VGA 
   port map    (Clk      => clock,
                hsync    => hsync,
                vsync    => vsync,
                Red      => Red,
                Green    => Green,
                Blue     => Blue
               );
	
	Audio_Inst : ElbertV2Audio
     port map   ( Clk      => clock,                       
						Audio_L  => Audio_L,
                  Audio_R  => Audio_R						
                ); 

   					 
   SevenSegmentDisplay : ElbertV2SevenSegmentDisplay 
      port map   ( Clk          => clock,
		             DPSwitch     => DPSwitch,
						 IO_P5_i      => IO_P5_i,
						 SevenSegment => SevenSegment,
                   Enable       => Enable
                  );	

   RunningLight : ElbertV2RunningLight 
       port map   ( Clk    => clock,
		              Switch => Switch,
		              LED    => LED
		             );  	
   -- The LED's output are also given to the peripheral ports so that it's functionality is verified. 
   -- The two pin's of peripheral port P5 i.e GPI pin 2 and pin 8 (input pin's) so can't be connected has output pin.
	
	IO_P1             <= LED;
   IO_P2             <= LED;
   IO_P4             <= LED;
	IO_P5(0)          <= LED(0);
	IO_P5(6 downto 2) <= LED(6 downto 2);
   IO_P6             <= LED;
	
end Behavioral;

