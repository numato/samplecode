--------------------------------------------------------------------------
-- LED demo code
-- Numato Lab
-- http://www.numato.com
-- http://www.numato.cc
-- License : CC BY-SA (http://creativecommons.org/licenses/by-sa/2.0/)
---------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ElbertV2RunningLight is
   port (
  -- Assuming 100MHz input clock. My need to adjust the counter below
  -- if any other input frequency is used
        Clk      : in std_logic;
  
  -- Switch input
		Switch   : in std_logic_vector(5 downto 0);
		  
  -- Output on on-board LED
		LED      : out std_logic_vector(7 downto 0)
        );

end ElbertV2RunningLight;	

architecture rtl of ElbertV2RunningLight is
	
-- Register used internally.
signal count     : std_logic_vector(50 downto 0)  := (others => '0');
signal enable    : std_logic                      := '0';
signal LED_o     : std_logic_vector(7 downto 0)   := x"01";
begin

-- Look for the input from the switches and change the speed of the LED
process(Clk)
  variable i       : integer  := 0;
  begin
    if rising_edge(Clk) then
       count <= std_logic_vector (unsigned(count) + 1);
		 
		 case Switch (3 downto 0) is
		    when "1110"      =>  i := 20;
		    when "1101"      =>  i := 22;
		    when "1011"      =>  i := 28;
		    when "0111"      =>  i := 26;
		    when others      =>  i := 24;
		 end case;
		 
       enable <= count(i);
	end if;
end process; 

-- On every positive edge of enable shift the value.
process(enable)
  begin 
   if rising_edge(enable) then
	-- Provide the initial value and role the lighting of LEDs turn by turn.
	 case LED_o is
	      when x"00"  => LED_o <= x"01";
	      when others => LED_o <= LED_o(6 downto 0) & "0";
  	 end case;
  
   -- The two Switches takes the priority for sitching ON and OFF all the LEDs   
  if (Switch(4) = '0') then
    LED_o <= x"FF";
  elsif (Switch(5) = '0') then
    LED_o <= x"00";
  end if;
  LED <= LED_o;
 end if;
end process;

end rtl;
		