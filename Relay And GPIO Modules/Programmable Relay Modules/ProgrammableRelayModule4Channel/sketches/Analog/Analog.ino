/*
 *  Demo Sketch For testing Analog Input of Programmable Relay Module 4 Channel 
 *  Visit http://www.numato.com for more details
 *  License: CC BY-SA
 */
/*
 *  Reads four analog input pins(A0,A1,A2 & A3) on board and serial out adc value.
 *  Connect a potentiometer to any one of Analog input while reading.
 */

char adcBytes[2];
int adcReadValue;

void setup() 
{  
   Serial.begin(9600); 
   delay(100); 
   Serial.println("Programmable Relay Module 4 Channel demo code");
   Serial.println("Enter the ADC Pin no. on the board. Eg: A0 for reading Analog0 , A1 for reading Analog1");    
  /* 
   *  Analog inputs-A0,A1,A2 & A3.
   *  ex: To Read Analog 0 send A0 and for Analog 1 send A1
   */   
}

void loop() 
{  
    if (Serial.available()) 
    { 
        Serial.readBytesUntil(13, adcBytes, 2); // Read bytes until pressed ENTER
      
        int adcReadPin = adcBytes[1] - 48;
       
        if(adcBytes[0] == 'A')
		{
			switch(adcReadPin)
			{ 
				case 0:   
				{
					Serial.println("Updating A0");
					adcReadValue = analogRead(A0); // Reading A0 state
					Serial.println(adcReadValue); // serial print the value read
				}
				break;
				case 1:
				{
					Serial.println("Updating A1");
					adcReadValue = analogRead(A1); // Reading A1 state
					Serial.println(adcReadValue); // serial print the value read
				}
				break;
				case 2:   
				{
					Serial.println("Updating A2");
					adcReadValue = analogRead(A2); // Reading A2 state
					Serial.println(adcReadValue); // serial print the value read
				}
				break;
				case 3:
				{
					Serial.println("Updating A3");
					adcReadValue = analogRead(A3); // Reading A3 state
					Serial.println(adcReadValue); // serial print the value read
				}
				break;
			}
			
		    Serial.println("Enter the ADC Pin no. on the board");        
		}
        else
		{
			Serial.println("Invalid command");
		}
   }
}



