/*
 *  Demo sketch for RTC of Programmable Relay Module 4 Channel
 *  visit http://www.numato.com to buy Programmable Relay Module 4 Channel
 *  License: CC BY-SA
 */
/*
 *  This sketch will sets time & date to DS1307 clock chip by I2C communication.
 *  After setting the time & date it will print date & time through serial out.
 *  The time and date can be change to the current time before upload.
 */ 
 /*
 *  Programmable Relay Module 4 Channel SDA(A4) is Connected to RTC(DS1307) SDA
 *  Programmable Relay Module 4 Channel SCL(A5) iS Connected to RTC(DS1307) SCL
 */
#include "Wire.h"
#define DS1307_RTC_ADDR 0x68

byte zero = 0x00; 
byte second =      00; //0-59
byte minute =      38; //0-59
byte hour =        12; //0-23
byte weekDay =     6;  //1-7
byte monthDay =    07; //1-31
byte month =       02; //1-12
byte year  =       14; //0-99

void setup()
{
  Wire.begin();
  Serial.begin(9600);
  setDateTime(); // Setting Date and Time on DS1307.
}

void loop()
{
  printTimeDate(); // Print the date & time which is set on DS1307.
  delay(1000);
}

void setDateTime()
{
  Wire.beginTransmission(DS1307_RTC_ADDR); // Starts I2C communication with DS1307.
  Wire.write(zero); //stop Oscillator
  Wire.write(decToBcd(second)); // Setting Second 
  Wire.write(decToBcd(minute)); // Setting Minute 
  Wire.write(decToBcd(hour)); // Setting Hour
  Wire.write(decToBcd(weekDay)); // Setting Weekday
  Wire.write(decToBcd(monthDay)); // Setting Monthday
  Wire.write(decToBcd(month)); // Setting Month
  Wire.write(decToBcd(year)); // Setting Weekday
  Wire.write(zero); // start 
  Wire.endTransmission(); // Ends I2C communication with DS1307.
}

byte decToBcd(byte value)
{
  return ( (value/10*16) + (value%10) ); // Convertion of decimal numbers to binary coded decimal
}

byte bcdToDec(byte value)  
{
  return ( (value/16*10) + (value%16) ); // Convertion of binary coded decimal to decimal numbers
}

void printTimeDate()
{
  Wire.beginTransmission(DS1307_RTC_ADDR); // Reset the register pointer
  Wire.write(zero); // start  
  Wire.endTransmission(); // Ends I2C communication with DS1307.
  Wire.requestFrom(DS1307_RTC_ADDR, 7); // requesting 7 bytes of data from the slave(DS1307)
  
  int second = bcdToDec(Wire.read()); // receive bytes as integer
  int minute = bcdToDec(Wire.read()); // receive bytes as integer
  int hour = bcdToDec(Wire.read() & 0b111111); //24 hour time
  int weekDay = bcdToDec(Wire.read()); //0-6 -> Sunday - Saturday
  int monthDay = bcdToDec(Wire.read()); // receive bytes as integer
  int month = bcdToDec(Wire.read()); // receive bytes as integer
  int year = bcdToDec(Wire.read()); // receive bytes as integer

  //print the time and date, ex: 11:59:59 12/10/14
  
  Serial.print(hour); // Serial Print hour
  Serial.print(":");
  Serial.print(minute); // Serial Print minute
  Serial.print(":");
  Serial.print(second); // Serial Print second
  Serial.print(" ");
  Serial.print(month); // Serial Print month
  Serial.print("/");
  Serial.print(monthDay); // Serial Print monthDay
  Serial.print("/");
  Serial.print(year); // Serial Print year
  Serial.println(" ");
}


