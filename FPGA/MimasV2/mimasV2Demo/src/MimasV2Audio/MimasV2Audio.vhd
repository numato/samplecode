---------------------------------------------------------------------------
-- Mimas V2 Audio demo code
-- Numato Lab
-- http:--www.numato.com
-- http:--www.numato.cc
-- License : CC BY-SA (http:--creativecommons.org/licenses/by-sa/2.0/)
---------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;

entity MimasV2Audio  is
    port ( 
        -- Assuming 100MHz input clock.My need to adjust the counter below
        -- if any other input frequency is used   
            CLK_i                 : in std_logic;
          -- Output Audio           
            Audio1                : inout std_logic;         
            Audio2                : inout std_logic          
            );
            
end MimasV2Audio;

architecture Behavioral of MimasV2Audio is

-- Intermediate Register to generate the required sound
signal counter                   : std_logic_vector(31 downto 0) := (others =>'0');
signal count                     : integer                       := 0;
signal pwm                       : std_logic                     := '0';
-- pwmcount define to switch between the Audio
signal pwmcount                  : integer                       := 99;
-- Reduce the Clock Frequency
constant freq                    : integer                       := 100000000/1000;

begin
-- Program start from here
process (CLK_i)
 begin
  if rising_edge(CLK_i) then
   if (count = 0) then                                            
        if (pwmcount = 0) then
           pwmcount <= 99;
        else
           if (pwmcount = 19) then
            pwm <= counter(27);
           else
            pwm <= counter(24);
           end if;
          pwmcount <= pwmcount - 1;
        end if;
    
    -- Assign the count value depending on pwm
        if (pwm = '1') then       
          count <= freq;                                      
         else
           count <= freq/75;
  
   -- Complement the Audio to generate the Sound
           Audio2 <= not Audio2;    
           Audio1 <= not Audio1;                                      
        end if;  
    else 
       count <= count-1;
       counter <= std_logic_vector (unsigned(counter) + 1);  
    end if;
  end if;
end process;
end Behavioral;