------------------------------------------------------------------------
-- Numato Lab
-- http://www.numato.com
-- http://www.numato.cc
-- License : CC BY-SA (http://creativecommons.org/licenses/by-sa/2.0/)
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;

entity vga_top is
        generic ( HRes        : integer := 1920;
                  VRes        : integer := 1080;
                  HStart      : integer := 2008;
                  VStart      : integer := 1084;
                  HStop       : integer := 2052;
                  VStop       : integer := 1089;
                  HMax        : integer := 2200;
                  VMax        : integer := 1125
                    );
        port(
                -- Assuming 150MHz input clock.My need to adjust the frequency
                -- if the resolution changes
                CLK           : in std_logic;
                     
                -- Horizontal and vertical sync.     
                HSYNC         : out std_logic;
                VSYNC         : out std_logic;
              
              -- Colour that are to be displayed on screen.
                Red           : out std_logic_vector(7 downto 0);
                Green         : out std_logic_vector(7 downto 0);
                Blue          : out std_logic_vector(7 downto 0);
                BLANK         : out std_logic  
        );
end vga_top;

architecture Behavioral of vga_top is

    -- Intermediate register used internally.
        signal hCount         : integer := HRes;
        signal vCount         : integer := VRes;
    
    -- Set the resolution of screen.
        signal nextHCount     : integer  := HStart;
        signal nextVCount     : integer  := VStart;
  
   -- Register to convert the integer value to vector.   
          signal count_h     : std_logic_vector(11 downto 0);
          signal count_v     : std_logic_vector(11 downto 0);
			 signal count       : integer := 0;
          signal color       : integer := 255;
        
begin

   -- The process is carried out for every positive edge of the clock. 
  vgasignal: process(CLK)
             begin
                if rising_edge(CLK) then              
                    -- Maximum Horizontal count is limited
                       if(hCount = HMax-1) then
                          hCount <= 0;
               -- Maximum Vertical count is limited                  
                          if(vCount = VMax-1) then
                             vCount <= 0;                                     
                          else
                             vCount <= vCount + 1;                                        
                          end if;
                       else
                          hCount <= hCount + 1;                         
                       end if;                    
                  -- Make sure we got the roll-over covered
                         if (nextHCount = HMax-1) then        
                           nextHCount <= 0;                       
                  -- Make sure we got the roll-over covered
                            if (nextVCount = VMax-1) then        
                               nextVCount <= 0;                               
                            else
                               nextVCount <= vCount + 1;          
                            end if;
                          else
                              nextHCount <= hCount + 1;                     
                          end if;      
                        -- Check if the count is within the minimum and maximum value for proper generation of the vertical sync signal           
                          if (vCount >= VStart and vCount < VStop) then
                             vsync <= '0';
                          else
                             vsync <= '1';
                          end if;           
                 -- Check if the count is within the minimum and maximum value for proper generation of the horizontal sync signal                         
                          if (hCount >= HStart and hCount < HStop) then
                             hsync <= '0';
                          else
                             hsync <= '1';
                          end if;    
                 -- Convert the integer value of the counter to vector.                     
                           count_h <= std_logic_vector(to_unsigned(nextHCount,count_h'length));
                           count_v <= std_logic_vector(to_unsigned(nextVCount,count_v'length));                          
                 -- If in display range
                          if (hCount < HRes and vCount < VRes) then
                              BLANK <= '1';
                              Red   <= count_h(7 downto 3) & count_h(5 downto 3);
                              Green <= count_h(7 downto 3) & count_v(7 downto 5);
                              Blue  <= count_v(7 downto 3) & count_v(7 downto 5); 									 
                          else                                
                              BLANK <= '0';
                          end if;
                end if;
        end process;

end Behavioral;