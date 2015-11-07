/*
 *  Demo sketch for RTC with Relay of Programmable Relay Module 4 Channel
 *  visit http://www.numato.com to buy Programmable Relay Module 4 Channel
 *  License: CC BY-SA
 */
/*
 * This sketch will print the real time along with the relay operation.
 * Once the RtcTimeSet is done this sketch can upload.
 * This Real time & date will run in DS1307 until the battery removed.
 * The relay operation time & date can be change according to the user wish.
 */
 /*
 *  Programmable Relay Module 4 Channel SDA(A4) is Connected to RTC(DS1307) SDA
 *  Programmable Relay Module 4 Channel SCL(A5) IS Connected to RTC(DS1307) SCL
 */
 
#include "Wire.h"
#define DS1307_RTC_ADDR 0x68

int i,j,relay[5]={2,3,9,7};
int second,minute,hour ;
int weekDay,monthDay,month,year; 

void setup()
{
  for(i=0;i<5;i++) pinMode(relay[i], OUTPUT); //Set all Relay digital pins to output
  for(j=0;j<5;j++) digitalWrite(relay[j], LOW); // Default all Relay digital IO pins to off state
  Wire.begin();
  Serial.begin(9600); 
}

void loop()
{
  printTimeDate(); // Serial printing real time and date 
  relaystatus(); // Relay operations with real time clock
  delay(1000);
}

byte bcdToDec(byte value)  
{
  return ( (value/16*10) + (value%16) ); // Convertion of binary coded decimal to decimal numbers
}

void printTimeDate()
{
  Wire.beginTransmission(DS1307_RTC_ADDR); // Reset the register pointer 
  byte zero = 0x00; 
  Wire.write(zero); // start  
  Wire.endTransmission(); // Ends I2C communication with DS1307
  Wire.requestFrom(DS1307_RTC_ADDR, 7); // requesting 7 bytes of data from the slave(DS1307)

  second = bcdToDec(Wire.read()); // receive bytes as integer
  minute = bcdToDec(Wire.read()); // receive bytes as integer
  hour = bcdToDec(Wire.read() & 0b111111); //24 hour time
  weekDay = bcdToDec(Wire.read()); //0-6 -> Sunday - Saturday
  monthDay = bcdToDec(Wire.read()); // receive bytes as integer
  month = bcdToDec(Wire.read()); // receive bytes as integer
  year = bcdToDec(Wire.read()); // receive bytes as integer

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

void relaystatus() 
{ 
  if((hour==12)&&(minute==40)&&(second==10))
  {
	digitalWrite(relay[0], HIGH); // Make Relay 0 ON
  }
  else if((hour==12)&&(minute==40)&&(second==15))	
  {
	digitalWrite(relay[1], HIGH); // Make Relay 1 ON
  }
  else if((hour==12)&&(minute==40)&&(second==20))	
  {
	digitalWrite(relay[2], HIGH); // Make Relay 2 ON
  }
  else if((hour==12)&&(minute==40)&&(second==25))	
  {
	digitalWrite(relay[3], HIGH); // Make Relay 3 ON
  }    
  else if((hour==12)&&(minute==40)&&(second==30))	
  {
	digitalWrite(relay[0], LOW); // Make Relay 0 OFF
  }
  else if((hour==12)&&(minute==40)&&(second==35))
  {
	digitalWrite(relay[1], LOW); // Make Relay 1 OFF
  }	
  else if((hour==12)&&(minute==40)&&(second==40))	
  {
	digitalWrite(relay[2], LOW); // Make Relay 2 OFF
  }
  else if((hour==12)&&(minute==40)&&(second==45))
  {
	digitalWrite(relay[3], LOW); // Make Relay 3 OFF
  }	  
}


