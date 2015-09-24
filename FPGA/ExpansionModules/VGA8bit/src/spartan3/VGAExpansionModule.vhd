------------------------------------------------------------------------
-- VGA Display module demo code
-- Numato Lab
-- http://www.numato.com
-- http://www.numato.cc
-- License : CC BY-SA (http://creativecommons.org/licenses/by-sa/2.0/)
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;

entity VGAExpansionModule is
        port(
		    -- Assuming 100MHz input clock.My need to adjust the counter below
            -- if any other input frequency is used 
                Clk: in std_logic;
      
		    -- Horizontal and vertical sync for VGA. 
                hsync: out std_logic;
                vsync: out std_logic;
				
			-- Colour that are to be displayed on screen.
                Red: out std_logic_vector(2 downto 0);
                Green: out std_logic_vector(2 downto 0);
                Blue: out std_logic_vector(2 downto 1)
                
        );
end VGAExpansionModule;

-- Implementation: The demo code for VGA is made to work 640x480 @ 60Hz display. The 640x480 @ 60Hz display requires the clock of 25MHz,
-- thus the proper horizontal sync signal of 33.1KHz is obtained.Thus at the frequency of 25MHz the signal is latched to the VGA pins.
  
architecture Behavioral of VGAExpansionModule is

    -- Intermediate register used internally
        signal clock:std_logic := '0';
        signal rgb           : std_logic_vector(7 downto 0);
        signal counter       : integer range 0 to 20000 := 0;	
		
	-- Set the resolution of screen
        signal hCount: integer range 0 to 1023 := 640;
        signal vCount: integer range 0 to 1023 := 480;

    -- Set the count from where it should start
        signal nextHCount: integer range 0 to 1023 := 641;
        signal nextVCount: integer range 0 to 1023 := 480;	  
begin

   -- Increase the clock frequency 
   
     c1  : entity work.clock_gen
	       port map (CLK_IN  => Clk,
	                 RST_IN  => '0',
	                 CLK_OUT => clock);
	
    -- Instantiate the file which contain the things to be displayed.
    -- The clock which should be given here is 50MHz,so that the data is properly obtained has the output is latched to VGA pins at 25MHz.  	
      output : entity work.FinalOutput
        port map(
              clock =>  clock,
              hcounter  =>  nextHCount,
              vcounter => nextVCount,
              pixels  => rgb
        );        
        
    -- The process is carried out for every positive edge of the clock i.e, 50 MHz clock(clock).
        vgasignal: process(clock)
                variable divide_by_2 : std_logic := '0';
 			 
        begin               
                if rising_edge(clock) then
                        -- Scale down the 50 MHz to 25 MHz so that the signal is latched properly.
                               if divide_by_2 = '1' then
                        
                        -- Maximum Horizontal count is limited to 799 for 640 x 480 display so that it fit's the screen. 						
                                        if(hCount = 799) then
                                                hCount <= 0;
                                                
					    -- Maximum Vertical count is limited to 524 for  640 x 480 display so that it fit's the screen.						
                                                if(vCount = 524) then
                                                        vCount <= 0;
																		  
                                                else
                                                        vCount <= vCount + 1;
																		  
                                                end if;
                                        else
                                                hCount <= hCount + 1;
																
                                        end if;
                                        
                        -- Make sure we got the roll over covered
                                        if (nextHCount = 799) then        
                                                nextHCount <= 0;
                                                
                        -- Make sure we got the roll over covered
                                                if (nextVCount = 524) then        
                                                        nextVCount <= 0;
																		  
                                                else
                                                        nextVCount <= vCount + 1;
																		  
                                                end if;
                                        else
                                                nextHCount <= hCount + 1;
																
                                        end if;
                            
                        -- Check if the count is within the minimum and maximum value for proper generation of the vertical sync signal 							
                                        if (vCount >= 490 and vCount < 492) then
                                                vsync <= '0';
                                        else
                                                vsync <= '1';
                                        end if;
                                    
                        -- Check if the count is within the minimum and maximum value for proper generation of the horizontal sync signal									
                                        if (hCount >= 656 and hCount < 752) then
                                                hsync <= '0';
                                        else
                                                hsync <= '1';
                                        end if;
                                     
                        -- If in display range then display the pixel.
                                        if (hCount < 640 and vCount < 480) then
                                               
                                                     Red <= rgb (7 downto 5);
                                                     Green <= rgb (4 downto 2);
                                                     Blue <= rgb (1 downto 0);	
                                                  
                                        end if;
                                end if;
                            divide_by_2 := not divide_by_2;
                        end if;
        end process;                                       
end Behavioral;