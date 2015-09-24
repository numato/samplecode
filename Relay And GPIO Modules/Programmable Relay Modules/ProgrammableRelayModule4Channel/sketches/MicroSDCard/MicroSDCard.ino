/*
 *  Demo sketch for Testing Micro SD in Programmable Relay Module 4 Channel.
 *  visit http://www.numato.com to buy Programmable Relay Module 4 Channel.
 *  License: CC BY-SA
 */
 /*
 *  This sketch checks micro sd card presnts.
 *  If the card is present then it will create one txt file, open, write, close & read the text file.
 *  Please make sure that you have arduino sd card library.
 *  Before getting started, go through http://arduino.cc/en/Reference/SDCardNotes#.UyqBF4X59ws
 */
/*  Programmable Relay Module 4 Channel MOSI(11) is Connected to SD Cards Pin DI.
 *  Programmable Relay Module 4 Channel MISO(12) is Connected to SD Cards Pin DO.
 *  Programmable Relay Module 4 Channel SCK(13) is Connected to SD Cards Pin CLK.
 *  Programmable Relay Module 4 Channel CS(8) is Connected to SD Cards CS.
 */
 
#include <SD.h>

File TestFile;

void setup()
{
  Serial.begin(9600);
  Serial.print("Memory card intialization is going on....!");
  pinMode(10, OUTPUT);
	
  if (!SD.begin(8)) 
  {
	  Serial.println("memory card intialization got failed....!");
	  return;
  }
  
  Serial.println("Initialization done successfully.");

  // Opening the sample txt file. Only once file cab be open at a time.
  // Keep in mind, close every file that you have opened before creating new file.
  
  TestFile = SD.open("Numato.txt", FILE_WRITE);

  if (TestFile) // if file opened successfully, then write on it.
  {
	  Serial.print("Writing to Numato.txt...");
	  TestFile.println("Programmable Relay Module 4 Channel"); // close the file once writing is compleated.
	  TestFile.close();
	  Serial.println("Done.");
  } 
  else 
  { 
	  Serial.println("error opening Numato.txt"); // print error if file not opened.
  }
	
  TestFile = SD.open("Numato.txt");  // open the file again for reading.
  
  if (TestFile) 
  {
	  Serial.println("Numato.txt:");// read the sample txt file fully untile nothing to read.	
	  while (TestFile.available()) 
	  {
		  Serial.write(TestFile.read());
	  }
	  TestFile.close(); //close the file once reading is compleated
  } 
  else 
  {
	  Serial.println("error opening Numato.txt");// print error if file not opened.
  }
}

void loop()
{
	// loop is essential for compilation if it empty also...!
}


