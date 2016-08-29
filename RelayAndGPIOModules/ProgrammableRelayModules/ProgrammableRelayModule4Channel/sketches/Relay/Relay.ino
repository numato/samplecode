/*
 *  Demo sketch for Testing  Relay's of Programmable Relay Module 4 Channel
 *  Visit http://www.numato.com for more details
 *  License: CC BY-SA
 */
/*
 *  Relays 0,1,2 & 3 are connected to the Arduino digital pins 2,3,9 & 7 respectively.
 *  Relays can be 'ON' or 'OFF' by setting High/Low to the associated digital IO's.
 */ 
 
byte relay[5] = {2,3,9,7}; //List of Digital I/O's conencted to the relays
char cbdBytes[2];

void setup() 
{  
   for(int i = 0; i < 5; i++)  pinMode(relay[i],OUTPUT); // Set all Relay pins to output
   for(int j = 0; j < 5; j++)  digitalWrite(relay[j],LOW); // Default all Relays to off state
   Serial.begin(9600); 
   delay(100); 
   Serial.println("Programmable Relay Module 4 Channel demo code");
   Serial.println("Enter the relay index and state. Eg: 01 for turning on relay 0, 00 for turning off relay 0"); 
  /* 
   *  RelayNumber - 0 to 1
   *  Mode - 1 for ON and 0 for OFF
   *  ex: To make Relay1 ON send 11 and to OFF send 10
   */   
}

void loop() 
{  
    if (Serial.available()) 
    { 
        Serial.readBytesUntil(13, cbdBytes, 2); // Read bytes until pressed ENTER
      
        int state = cbdBytes[1] - 48;
      
        if(state == 0 | state == 1)
        {
            switch(cbdBytes[0])
            { 
                case '0':   
                {
                   Serial.println("Updating relay 0 state");
                   digitalWrite(relay[0], state); // Set relay 0 to ON or OFF
                   Serial.println("Done"); 
                }
                break;
                case '1':
                {
				   Serial.println("Updating relay 1 state");
				   digitalWrite(relay[1],state); // Set relay 1 to ON or OFF
				   Serial.println("Done");
                }
                break;
                case '2':   
                {
                   Serial.println("Updating relay 2 state");
                   digitalWrite(relay[2], state); // Set relay 2 to ON or OFF
                   Serial.println("Done"); 
                }
                break;
                case '3':
                {
				   Serial.println("Updating relay 3 state");
				   digitalWrite(relay[3],state); // Set relay 3 to ON or OFF
				   Serial.println("Done");
                }
                break;				
            }
            
            Serial.println("Enter the relay index and state");        
        }
        else
        {
            Serial.println("Invalid command");
        }
   }
}





