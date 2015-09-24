------------------------------------------------------------------------
-- VGA Display module demo code
-- Numato Lab
-- http://www.numato.com
-- http://www.numato.cc
-- License : CC BY-SA (http://creativecommons.org/licenses/by-sa/2.0/)
-------------------------------------------------------------------------

library IEEE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FinalOutput is
    -- Define the width and the height of the displayed text.
		generic(OutputWidth: integer := 10;	  
			   OutputHeight: integer := 40	 
			   );
		  port (
	-- Assuming 50MHz clock.If the clock is reduced then it might give the unexpected output.	   
			  clock: in std_logic;
			  
	-- The counter tells whether the correct position on the screen is reached where the data is to be displayed. 
			  hcounter: in integer range 0 to 1023;
			  vcounter: in integer range 0 to 1023;
	
	-- Output the colour that should appear on the screen. 
			  pixels : out std_logic_vector(7 downto 0)				  
			  );
end FinalOutput;
architecture Behavioral of FinalOutput is	
    -- Intermediate register telling the exact position on display on screen.
		 signal x : integer range 0 to 1023 := 100;
		 signal y : integer range 0 to 1023 := 80;
begin
 -- On every positive edge of the clock counter condition is checked,
  output1: process(clock)
			  begin
					if rising_edge (clock) then
					-- If the counter satisfy the condition, then output the colour that should appear.
				        if  ((hcounter >= (x + OutputWidth ) and hcounter < (x + 2*OutputWidth + OutputHeight)) and (vcounter >= y and vcounter < (y + OutputWidth))) or
							((hcounter >= (x + OutputWidth) and hcounter < (x + 2*OutputWidth)) and (vcounter >= (y + OutputWidth) and vcounter < (y + 3*OutputWidth + 2*OutputHeight))) or 
							((hcounter >= (x + 5*OutputWidth) and hcounter < (x + 6*OutputWidth)) and (vcounter >= (y + OutputWidth) and vcounter < (y + 3*OutputWidth + 2*OutputHeight))) or
						    ((hcounter >= (x + 7*OutputWidth ) and hcounter < (x + 8*OutputWidth + OutputHeight)) and (vcounter >= (y + 2*OutputWidth + 2*OutputHeight) and vcounter < (y + 3*OutputWidth + 2*OutputHeight))) or
						    ((hcounter >= (x + 7*OutputWidth) and hcounter < (x + 8*OutputWidth)) and (vcounter >= (y ) and vcounter < (y + 3*OutputWidth + 2*OutputHeight))) or 
						    ((hcounter >= (x + 11*OutputWidth) and hcounter < (x + 12*OutputWidth)) and (vcounter >= (y ) and vcounter < (y + 3*OutputWidth + 2*OutputHeight))) or
							((hcounter >= (x + 13*OutputWidth) and hcounter < (x + 14*OutputWidth)) and (vcounter >= y and vcounter < (y + 3*OutputWidth + 2*OutputHeight))) or
					        ((hcounter >= (x + 15*OutputWidth) and hcounter < (x + 16*OutputWidth)) and (vcounter >= y	and vcounter < (y + 3*OutputWidth + 2*OutputHeight))) or
						    ((hcounter >= (x + 17*OutputWidth) and hcounter < (x + 18*OutputWidth)) and (vcounter >= y and vcounter < (y + 3*OutputWidth + 2*OutputHeight)))or
						    ((hcounter >= (x + 13*OutputWidth) and hcounter < (x + 14*OutputWidth + OutputHeight)) and (vcounter >= y and vcounter < (y + OutputWidth)))or
							((hcounter >= (x + 19*OutputWidth ) and hcounter < (x + 20*OutputWidth + OutputHeight)) and (vcounter >= y and vcounter < (y + OutputWidth))) or
						    ((hcounter >= (x + 19*OutputWidth ) and hcounter < (x + 20*OutputWidth + OutputHeight)) and (vcounter >= (y + 5*OutputWidth) and vcounter < (y + 6*OutputWidth ))) or
							((hcounter >= (x + 19*OutputWidth) and hcounter < (x + 20*OutputWidth)) and (vcounter >= (y ) and vcounter < (y + 3*OutputWidth + 2*OutputHeight))) or 
						    ((hcounter >= (x + 23*OutputWidth) and hcounter < (x + 24*OutputWidth)) and (vcounter >= (y ) and vcounter < (y + 3*OutputWidth + 2*OutputHeight))) or
							((hcounter >= (x + 25*OutputWidth ) and hcounter < (x + 26*OutputWidth + OutputHeight)) and (vcounter >= y and vcounter < (y + OutputWidth))) or
							((hcounter >= (x + 25*OutputWidth + OutputHeight/2) and hcounter < (x + 26*OutputWidth + OutputHeight/2)) and (vcounter >= (y + OutputWidth) and vcounter < (y + 3*OutputWidth + 2*OutputHeight))) or 
							((hcounter >= (x + 31*OutputWidth ) and hcounter < (x + 32*OutputWidth + OutputHeight)) and (vcounter >= y and vcounter < (y + OutputWidth))) or
						    ((hcounter >= (x + 31*OutputWidth ) and hcounter < (x + 32*OutputWidth + OutputHeight)) and (vcounter >= (y + 2*OutputWidth + 2*OutputHeight) and vcounter < (y + 3*OutputWidth + 2*OutputHeight))) or 
							((hcounter >= (x + 31*OutputWidth) and hcounter < (x + 32*OutputWidth)) and (vcounter >= (y + OutputWidth) and vcounter < (y + 3*OutputWidth + 2*OutputHeight))) or 
							((hcounter >= (x + 35*OutputWidth) and hcounter < (x + 36*OutputWidth)) and (vcounter >= (y + OutputWidth) and vcounter < (y + 3*OutputWidth + 2*OutputHeight))
							) then
						  pixels <= x"F0";
					
					-- If the condition is not satisfied then the output colour will be black.
					    else 
						  pixels <= x"00";
						end if;
			  end if;
		   end process;
end Behavioral;