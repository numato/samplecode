/*
 *  Relays 0,1,2,3 are connected to the Arduino digital pins 8,7,2,4 respectively using a ULN2003 IC.
 *  Writing HIGH to these digital pins makes corresponding relay to ON.
 *  Writing LOW to these digital pins makes corresponding relay to OFF.
 */
byte RelayPins[4] = {8,7,2,4};
char Input[1];

void setup() 
{
  for(int i = 0; i < 4; i++)  pinMode(RelayPins[i],OUTPUT);  // Set all Relay pins to output
  Serial.begin(9600); 
  delay(100); 
  Serial.println("4ChannelRelayShield demo sketch");
  Serial.println("Enter the RelayNumber and Mode");
  /* 
   *  RelayNumber - 0 to 3
   *  Mode - 1 for ON and 0 for OFF
   *  ex: To make Relay2 ON send 21 and to OFF send 20
   */
  for(int j = 0; j < 4; j++)  digitalWrite(RelayPins[j],LOW);  // Default all Relays to off state
}

void loop() 
{
   String Status;
   if (Serial.available()) 
   { 
      Serial.readBytesUntil(13, Input, 2);  // Read bytes until pressed ENTER
      int State = Input[1] - 48;
      int RelayNum = Input[0]-48;
      if((State == 0) || (State == 1))
      {
         digitalWrite(RelayPins[RelayNum], State);  // Make Relay ON or OFF
      }
      else
      {
        Serial.println("Incorrect parameter");
      }
      
      Status = String("Relay ") + String(RelayNum) + String(" State is set to ") + String(State);
      
      Serial.println(Status);
            
   }
}





