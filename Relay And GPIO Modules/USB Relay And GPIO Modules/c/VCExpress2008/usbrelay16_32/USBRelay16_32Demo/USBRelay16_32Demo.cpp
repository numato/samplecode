/*
License
-------
This code is published and shared by Numato Systems Pvt Ltd under GNU LGPL 
license with the hope that it may be useful. Read complete license at 
http://www.gnu.org/licenses/lgpl.html or write to Free Software Foundation,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA

Simplicity and understandability is the primary philosophy followed while
writing this code. Sometimes at the expence of standard coding practices and
best practices. It is your responsibility to independantly assess and implement
coding practices that will satisfy safety and security necessary for your final
application.

This demo code demonstrates how to turn on a relay and how to read the status
of a relay. If the relay module prurchased do have built in GPIOs, please refer
to GPIO demo code to see how to use them.

*/

#include "stdafx.h"
#include "windows.h"
#include "string.h"


int _tmain(int argc, _TCHAR* argv[])
{

	HANDLE hComPort;
	char cmdBuffer[32];
	char responseBuffer[32];
	DWORD numBytesWritten;
	DWORD numBytesRead;

	/*
		Lookup the port name associated to your relay module and update the 
		following line accordingly. The port name should be in the format 
		"\\.\COM<port Number>". Notice the extra slashes to escape slashes
		themselves. Read http://en.wikipedia.org/wiki/Escape_sequences_in_C
		for more details.
	*/

	wchar_t PortName[] = L"\\\\.\\COM14";

	/*
		Open a handle to the COM port. We need the handle to send commands and
		receive results.
	*/

	hComPort = CreateFile(PortName, GENERIC_READ | GENERIC_WRITE, 0, 0, OPEN_EXISTING, 0, 0);

	if (hComPort == INVALID_HANDLE_VALUE)
	{
		printf("Error: Unable to open the specified port\n");
		return 1;
	}
    
	/* EXAMPLE 1 - CHECK THE STATUS OF RELAY10                                */
	/************************************************************************** 
	    Write "relay read A" comamnd to the device and read back response. It
		is important to note that the device echoes every single character sent
		to it and so when you read the response, the data that is read will 
		include the command itself, a carriage return, the response which you 
		are interested in, a '>' character and another carriage return. You 
		will need to extract the response from this bunch of data. 
	/*************************************************************************/
	
	/* Write a Carriage Return to make sure that any partial commands or junk
	   data left in the command buffer is cleared. This step is optional.
	*/
	cmdBuffer[0] = 0x0D;
	
	if(!WriteFile(hComPort, cmdBuffer, 1, &numBytesWritten, NULL))
	{
		CloseHandle(hComPort);
		printf("Error: Unable to write to the specified port\n");
		return 1;
	}

	/* Flush the Serial port's RX buffer. This is a very important step*/
	Sleep(10);
	PurgeComm(hComPort, PURGE_RXCLEAR|PURGE_RXABORT);

	/*  Copy the command to the command buffer. Relay number 10 and beyond are
		referenced in the command by using alphabets starting A. For example
		RELAY10 willbe A, RELAY11 will be B and so on. Please note that this is
		not intended to be hexadecimal notation so the the alphabets can go 
		beyond F.
	*/
	strcpy(cmdBuffer, "relay read A");

	/* Append 0x0D to emulate ENTER key */
	cmdBuffer[12] = 0x0D;
	
	/* Write the command to the relay module. Total 13 bytes including 0x0D  */

	printf("Info: Writing command <relay read A> to the relay module\n");

	if(!WriteFile(hComPort, cmdBuffer, 13, &numBytesWritten, NULL))
	{
		CloseHandle(hComPort);
		printf("Error: Unable to write to the specified port\n");
		return 1;
	}

	printf("Info: <relay read A> Command sent successfuly\n");

	/*Read back the response*/
	if(!ReadFile(hComPort, responseBuffer, 17, &numBytesRead, NULL))
	{
		CloseHandle(hComPort);
		printf("Error: Unable to write to the specified port\n");
		return 1;
	}

	/* Add a null character at the end of the response so we can use the buffer
	   with string manipulation functions.
	 */
	responseBuffer[numBytesRead] = '\0';

	printf("Info: Relay status read from the device = %.*s\n", 3, responseBuffer + 14);


	/* EXAMPLE 2 - TURN ON RELAY 10                                          */
	/************************************************************************** 
		Send a command to turn on relay 10. The command that is used to 
		accomplish this acton is "relay on A". It is important to send 
		a Carriage Return character (ASCII value 0x0D) to emulate the ENTER 
		key. The command will be executed only when the relay module detects 
		Carriage Return character.
	**************************************************************************/

	/* Write a Carriage Return to make sure that any partial commands or junk
	   data left in the command buffer is cleared. This step is optional.
	*/
	cmdBuffer[0] = 0x0D;
	
	if(!WriteFile(hComPort, cmdBuffer, 1, &numBytesWritten, NULL))
	{
		CloseHandle(hComPort);
		printf("Error: Unable to write to the specified port\n");
		return 1;
	}

	/*  Copy the command to the command buffer. Relay number 10 and beyond are
		referenced in the command by using alphabets starting A. For example
		RELAY10 willbe A, RELAY11 will be B and so on. Please note that this is
		not intended to be hexadecimal notation so the the alphabets can go 
		beyond F.
	*/
	strcpy(cmdBuffer, "relay on A");

	/* Append 0x0D to emulate ENTER key */
	cmdBuffer[10] = 0x0D;
	
	/* Write the command to the relay module. Total 11 bytes including 0x0D  */

	printf("Info: Writing command <relay on A> to the relay module\n");

	if(!WriteFile(hComPort, cmdBuffer, 11, &numBytesWritten, NULL))
	{
		CloseHandle(hComPort);
		printf("Error: Unable to write to the specified port\n");
		return 1;
	}

	printf("Info: <relay on A> Command sent successfuly\n\n");

	/* EXAMPLE 3 - CHECK THE STATUS OF RELAY10 AGAIN                         */
	/************************************************************************** 
	    Write "relay read A" comamnd to the device and read back response. It
		is important to note that the device echoes every single character sent
		to it and so when you read the response, the data that is read will 
		include the command itself, a carriage return, the response which you 
		are interested in, a '>' character and another carriage return. You 
		will need to extract the response from this bunch of data. 
	/*************************************************************************/
	
	/* Write a Carriage Return to make sure that any partial commands or junk
	   data left in the command buffer is cleared. This step is optional.
	*/
	cmdBuffer[0] = 0x0D;
	
	if(!WriteFile(hComPort, cmdBuffer, 1, &numBytesWritten, NULL))
	{
		CloseHandle(hComPort);
		printf("Error: Unable to write to the specified port\n");
		return 1;
	}

	/* Flush the Serial port's RX buffer. This is a very important step*/
	Sleep(10);
	PurgeComm(hComPort, PURGE_RXCLEAR|PURGE_RXABORT);

	/*  Copy the command to the command buffer. Relay number 10 and beyond are
		referenced in the command by using alphabets starting A. For example
		RELAY10 willbe A, RELAY11 will be B and so on. Please note that this is
		not intended to be hexadecimal notation so the the alphabets can go 
		beyond F.
	*/
	strcpy(cmdBuffer, "relay read A");

	/* Append 0x0D to emulate ENTER key */
	cmdBuffer[12] = 0x0D;
	
	/* Write the command to the relay module. Total 13 bytes including 0x0D  */

	printf("Info: Writing command <relay read A> to the relay module\n");

	if(!WriteFile(hComPort, cmdBuffer, 13, &numBytesWritten, NULL))
	{
		CloseHandle(hComPort);
		printf("Error: Unable to write to the specified port\n");
		return 1;
	}

	printf("Info: <relay read A> Command sent successfuly\n");

	/*Read back the response*/
	if(!ReadFile(hComPort, responseBuffer, 17, &numBytesRead, NULL))
	{
		CloseHandle(hComPort);
		printf("Error: Unable to write to the specified port\n");
		return 1;
	}

	/* Add a null character at the end of the response so we can use the buffer
	   with string manipulation functions.
	 */
	responseBuffer[numBytesRead] = '\0';

	printf("Info: Relay status read from the device = %.*s\n", 3, responseBuffer + 14);


	/* Close the comm port handle */
	CloseHandle(hComPort);

	return 0;
}

