/*
 *  Demo Sketch For Digital I/O's of Programmable Relay Module 4 Channel
 *  Visit http://www.numato.com for more details
 *  License: CC BY-SA
 */
/*
 *  This sketch writes high, low on each 3 digital IO's for one second repeatedly.
 *  Connecting Led's to each digital io's is recommended. 
 */ 

byte digitalIOs[4] = {4,5,6}; // List of digital I/O's on board.

void setup() 
{  
   for(int i = 0; i < 4; i++)  pinMode(digitalIOs[i],OUTPUT); // Set all digital pins as outputs.
   for(int j = 0; j < 4; j++)  digitalWrite(digitalIOs[j],LOW); // Initialize all digital IO pins to off state.
}

void loop() 
{  
    for(int k = 0; k < 4; k++)
	{
		digitalWrite(digitalIOs[k],HIGH); // Set digital IO pins to on state
		delay(1000); // Delay by 1 sec
		digitalWrite(digitalIOs[k],LOW); // Set digital IO pins to off state
		delay(1000); // Delay by 1 sec
	}
}

