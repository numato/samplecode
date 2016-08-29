----------------------------------------------------------------------------------
-- AD9283 ADC Expansion Module demo code                               
-- Numato Lab                                                          
-- https://www.numato.com                                              
-- https://www.numato.cc                                               
-- Design Name : Binary to BCD conversion 
-- Description : Convert Binary to BCD using shifting and adding algorithm
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Binary2BCD is
  Port (    data_o        : in  std_logic_vector (7 downto 0);          --  Digital data from ADCExpansionModule
            hundreds_data : out std_logic_vector (3 downto 0);          --  hundreds_data, tens_data, units_data --> BCD outputs  
            tens_data     : out std_logic_vector (3 downto 0);          
            units_data    : out std_logic_vector (3 downto 0)            
       );
end Binary2BCD;

architecture Behavioral of Binary2BCD is                  
begin
    Bin2BCD : process (data_o)
     -- Variable for storing bits internally
     variable shift : unsigned(19 downto 0);
     
     -- Different names for parts of shift register
     alias data       is shift(7 downto 0);
     alias one_digit  is shift(11 downto 8);
     alias ten_digit  is shift(15 downto 12);
     alias hun_digit  is shift(19 downto 16);
    
     begin
           -- Initializing shift register
           data       := unsigned(data_o);
           one_digit  := x"0";
           ten_digit  := x"0";
           hun_digit  := x"0";
           
           -- Loop data length times
           for i in 1 to data'Length loop
              -- Check if any digit is greater than or equal to 5
              if one_digit >= 5 then
                 one_digit := one_digit + 3;
              end if;
              
              if ten_digit >= 5 then
                 ten_digit := ten_digit + 3;
              end if;
              
              if hun_digit >= 5 then
                 hun_digit := hun_digit + 3;
              end if;
              
              -- Shift entire register left once
              shift := shift_left(shift, 1);
           end loop;
           
           -- Push decimal numbers to output
           hundreds_data <= std_logic_vector(hun_digit);
           tens_data     <= std_logic_vector(ten_digit);
           units_data    <= std_logic_vector(one_digit);
    end process;    


end Behavioral;
