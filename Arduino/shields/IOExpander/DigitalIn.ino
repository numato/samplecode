/*
 *  There are two on board MCP23017(U2 and U4) IO Expander ICs on this Shield
 *  Select jumper positions of AD1=AD2=AD3=0, to set the Address of U2 as 0x20
 *  Select jumper positions of AD4=0; AD5=0; AD6=1, to set the Address of U4 as 0x21
 *  Digital Pins 0 - 7 belongs to PORTA and 8 - 15 belongs to PORTB of U2
 *  Digital Pins 24 - 27 belongs to PORTA and 16 - 23 belongs to PORTB of U4
 */
 
#include "Wire.h"

byte U2PortA, U2PortB, U4PortA, U4PortB =0; // Define variables to hold I/O port readings.

void setup()
{
   Serial.begin(9600);                      // Begin Serial Communication 
   Wire.begin();                            // Begin I2C Communication
   /* 
    *  The following code starts I2C communication with MCP23017(U2).Please refer MCP23017 datasheet
    *  for register addresses. Sets all GPIOs of this IC to INPUT 
    */
   Wire.beginTransmission(0x20);            // Starts communication with MCP23017(U2) IC
   Wire.write(0x00);                        // Set MCP23017 memory pointer to IODIRA address
   Wire.write(0xFF);                        // Set all pins of PORTA to outputs
   Wire.endTransmission();                  // Ends I2C communication with MCP23017(U2) IC

   Wire.beginTransmission(0x20);            // Starts communication with MCP23017(U2) IC
   Wire.write(0x01);                        // Set MCP23017 memory pointer to IODIRB address
   Wire.write(0xFF);                        // Set all pins of PORTB to outputs
   Wire.endTransmission();                  // Ends I2C communication with MCP23017(U2) IC
   /* 
    *  The following code starts I2C communication with MCP23017(U4).Please refer MCP23017 datasheet
    *  for register addresses. Sets all GPIOs of this IC to INPUT 
    */
   Wire.beginTransmission(0x21);            // Starts communication with MCP23017(U4) IC
   Wire.write(0x00);                        // Set MCP23017 memory pointer to IODIRA address
   Wire.write(0xFF);                        // Set all PORTA pins to OUTPUT
   Wire.endTransmission();                  // Ends I2C communication with MCP23017(U4) IC

   Wire.beginTransmission(0x21);            // Starts communication with MCP23017(U4) IC
   Wire.write(0x01);                        // Set MCP23017 memory pointer to IODIRB address
   Wire.write(0xFF);                        // Set all PORTB pins to OUTPUT
   Wire.endTransmission();                  // Ends I2C communication with MCP23017(U4) IC
}

void loop()
{
   Wire.beginTransmission(0x20);            // Starts I2C Communication with MCP23017(U2) IC
   Wire.write(0x12);                        // Set MCP23017 memory pointer to PORTA address
   Wire.endTransmission();                  // Ends I2C communication with U2
   Wire.requestFrom(0x20, 1);               // Request one byte of data from MCP20317(U2)
   U2PortA=Wire.read();                     // Store the incoming byte of PORTA into "U2PortA"
 
   Wire.beginTransmission(0x20);            // Start I2C communication with U2
   Wire.write(0x13);                        // Set MCP23017 memory pointer to PORTB address
   Wire.endTransmission();                  // Ends I2C communication with U2
   Wire.requestFrom(0x20, 1);               // Request one byte of data from MCP20317(U2)
   U2PortB=Wire.read();                     // Store the incoming byte of PORTB into "U2PortB"

   Wire.beginTransmission(0x21);            // Start I2C communication with MCP23017(U4)
   Wire.write(0x12);                        // Set MCP23017 memory pointer to PORTA address
   Wire.endTransmission();                  // Ends I2C communication with U4
   Wire.requestFrom(0x21, 1);               // Request one byte of data from MCP20317(U4)
   U4PortA=Wire.read();                     // Store the incoming byte of PORTA into "U4PortA"
 
   Wire.beginTransmission(0x21);            // Start I2C communication with U4
   Wire.write(0x13);                        // Set MCP23017 memory pointer to PORTB address
   Wire.endTransmission();                  // Ends I2C communication with U4
   Wire.requestFrom(0x21, 1);               // Request one byte of data from MCP20317
   U4PortB=Wire.read();                     // Store the incoming byte of PORTB into "U4PortB"
   
   Serial.print("U2 PORTA: " ); 
   Serial.println(U2PortA, BIN);            // Print the contents of the PORTA register in binary
   Serial.print("U2 PORTB: " ); 
   Serial.println(U2PortB, BIN);            // Print the contents of the PORTB register in binary
   delay(500);

   Serial.print("U4 PORTA: " );
   Serial.println(U4PortA, BIN);            // Print the contents of the PORTA register in binary
   Serial.print("U4 PORTB: " );
   Serial.println(U4PortB, BIN);            // Print the contents of the PORTB register in binary
   delay(500);                            
}
