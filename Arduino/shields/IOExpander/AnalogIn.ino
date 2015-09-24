/*
 *  The selection pins(S0, S1, S2, S3) of 74HC4067 IC are connected to PORTA pins(PA0, PA1, PA2, PA3) of MCP23017(U4) IC.
 *  Common I/O of 74HC4067 IC is connected to Arduino analog pin A0
 *  Select jumper positions of AD4=0; AD5=0; AD6=1; to set the Address of U4 as 0x21
 *  Enable pin should be connected to ground to activate the I/O pins. Populate jumper GS7 to connect the Enable pin to GND.
 *  Select the Analog Pin(0-15) by defining the particular number in line number 18 of this code.
 */

#include"Wire.h"

#define CommonInput A0
#define AnalogPin 0                             // Selects pin number 0 of Analog header

void setup()
{
   Serial.begin(9600);                          // Begin Serial Communication
   Wire.begin();                                // Begin I2C Communication
   /* 
    *  The following code sets up I2C communication with MCP23017(U4), selects Bank 0 and set all PORTA pins as outputs.
    *  This is because the select pins of 74HC4067 are driven through MCP23017(U4). Please refer MCP23017 datasheet for 
    *  register addresses.
    */	
   Wire.beginTransmission(0x21);                // Start I2C communication with MCP23017(U4)
   Wire.write(0x00);                            // Set memory mapping address to IODIRA  register of U4
   Wire.write(0x00);                            // Set all PORTA pin of U4 to outputs
   Wire.endTransmission();                      // Ends I2C communication with U4
  
   pinMode(CommonInput, INPUT);                 // Set Analog Common I/O(Arduino Analog A0) to INPUT
}

void loop()
{
   Wire.beginTransmission(0x21);                // Start I2C communication with MCP23017(U4) IC
   Wire.write(0x12);                            // Set memory mapping address to PORTA register of U4 
   Wire.write(AnalogPin);                       // Selects the Analog Pin to read (this will write the selection address to PORTA of U4)
   Wire.endTransmission();                      // Ends I2C communication with U4
   
   int AdcValue = analogRead(CommonInput);      // Read the ADC value from Common I/O(Arduino Analog A0)
   
   Serial.println(AdcValue);                    // Print the ADC reading to serial monitor
   delay(500);
}
