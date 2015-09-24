/*
 *  There are two on board MCP23017(U2 and U4) IO Expander ICs on this Shield
 *  Select jumper positions of AD1=AD2=AD3=0, to set the Address of U2 as 0x20
 *  Select jumper positions of AD4=0; AD5=0; AD6=1, to set the Address of U4 as 0x21
 *  Digital Pins 0 - 7 belongs to PORTA and 8 - 15 belongs to PORTB of U2
 *  Digital Pins 24 - 27 belongs to PORTA and 16 - 23 belongs to PORTB of U4
 */
 
#include "Wire.h"

void setup()
{
   Wire.begin();                                  // Begin I2C bus
   /* 
    *  The following code starts I2C communication with MCP23017(U2).Please refer MCP23017 datasheet
    *  for register addresses. Sets all GPIOs of this IC to OUTPUT 
    */
   Wire.beginTransmission(0x20);                  // Starts communication with MCP23017(U2) IC
   Wire.write(0x00);                              // Set MCP23017 memory pointer to IODIRA address
   Wire.write(0x00);                              // Set all pins of PORTA to outputs
   Wire.endTransmission();                        // Ends I2C communication with MCP23017(U2) IC

   Wire.beginTransmission(0x20);                  // Starts communication with MCP23017(U2) IC
   Wire.write(0x01);                              // Set MCP23017 memory pointer to IODIRB address
   Wire.write(0x00);                              // Set all pins of PORTB to outputs
   Wire.endTransmission();                        // Ends I2C communication with MCP23017(U2) IC
   /* 
    *  The following code starts I2C communication with MCP23017(U4).Please refer MCP23017 datasheet
    *  for register addresses. Sets all GPIOs of this IC to OUTPUT 
    */
   Wire.beginTransmission(0x21);                  // Starts communication with MCP23017(U4) IC
   Wire.write(0x00);                              // Set MCP23017 memory pointer to IODIRA address
   Wire.write(0x00);                              // Set all PORTA pins to OUTPUT
   Wire.endTransmission();                        // Ends I2C communication with MCP23017(U4) IC

   Wire.beginTransmission(0x21);                  // Starts communication with MCP23017(U4) IC
   Wire.write(0x01);                              // Set MCP23017 memory pointer to IODIRB address
   Wire.write(0x00);                              // Set all PORTB pins to OUTPUT
   Wire.endTransmission();                        // Ends I2C communication with MCP23017(U4) IC
}

void DigitalIO(int i)
{
   Wire.beginTransmission(0x20);
   Wire.write(0x12);                             
   Wire.write(i);                                 // Set or clear PORTA pins of U2
   Wire.endTransmission();
   
   Wire.beginTransmission(0x20);
   Wire.write(0x13);                              
   Wire.write(i);                                 // Set or clear PORTB pins of U2
   Wire.endTransmission();
    
   Wire.beginTransmission(0x21);
   Wire.write(0x12);                              
   Wire.write(i);                                 // Set or clear PORTA pins of U4
   Wire.endTransmission();
    
   Wire.beginTransmission(0x21);
   Wire.write(0x13);                              
   Wire.write(i);                                 // Set or clear PORTB pins of U4
   Wire.endTransmission();
}

void loop()
{
   DigitalIO(255);                                // All digital pins High
   delay(100);
   DigitalIO(0);                                  // All digital pins Low
   delay(100);
}


