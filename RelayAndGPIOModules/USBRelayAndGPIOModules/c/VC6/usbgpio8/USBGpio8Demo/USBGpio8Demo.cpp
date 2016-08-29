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

This demo code demonstrates how to turn a GPIO to on (logic high) state and 
demonstrates how to read an analog channel.

*/

#include "stdafx.h"
#include "windows.h"
#include "string.h"
#include "stdio.h"


int main(int argc, char* argv[])
{

	HANDLE hComPort;
	char cmdBuffer[32];
	char responseBuffer[32];
	DWORD numBytesWritten;
	DWORD numBytesRead;

	/*
		Lookup the port name associated to your GPIO device and update the 
		following line accordingly. The port name should be in the format 
		"\\.\COM<port Number>". Notice the extra slashes to escape slashes
		themselves. Read http://en.wikipedia.org/wiki/Escape_sequences_in_C
		for more details.
	*/

	char PortName[] = "\\\\.\\COM3";

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
    
	/* EXAMPLE 1 - MANIPULATE GPIO BY SENDING COMMAND                        */
	/************************************************************************** 
		Send a command to output a logic high at GPIO 0. The command that is 
		used to accomplish this acton is "gpio set 0". It is important to send 
		a Carriage Return character (ASCII value 0x0D) to emulate the ENTER 
		key. The command will be executed only when the GPIO module detects 
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

	/* Copy the command to the command buffer */
	strcpy(cmdBuffer, "gpio set 0");

	/* Append 0x0D to emulate ENTER key */
	cmdBuffer[10] = 0x0D;
	
	/* Write the command to the GPIO module. Total 11 bytes including 0x0D  */

	printf("Info: Writing command <gpio set 0> to the GPIO module\n");

	if(!WriteFile(hComPort, cmdBuffer, 11, &numBytesWritten, NULL))
	{
		CloseHandle(hComPort);
		printf("Error: Unable to write to the specified port\n");
		return 1;
	}

	printf("Info: <gpio set 0> Command sent successfuly\n");

	/* EXAMPLE 2 - READ ADC 1                                                */
	/************************************************************************** 
	    Write "adc read 1" comamnd to the device and read back response. It is 
	    important to note that the device echoes every single character sent to
		it and so when you read the response, the data that is read will 
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

	/* Copy the command to the command buffer */
	strcpy(cmdBuffer, "adc read 1");

	/* Append 0x0D to emulate ENTER key */
	cmdBuffer[10] = 0x0D;
	
	/* Write the command to the GPIO module. Total 11 bytes including 0x0D  */

	printf("Info: Writing command <adc read 1> to the GPIO module\n");

	if(!WriteFile(hComPort, cmdBuffer, 11, &numBytesWritten, NULL))
	{
		CloseHandle(hComPort);
		printf("Error: Unable to write to the specified port\n");
		return 1;
	}

	printf("Info: <adc read 1> Command sent successfuly\n");

	/*Read back the response*/
	if(!ReadFile(hComPort, responseBuffer, 16, &numBytesRead, NULL))
	{
		CloseHandle(hComPort);
		printf("Error: Unable to write to the specified port\n");
		return 1;
	}

	/* Add a null character at the end of the response so we can use the buffer
	   with string manipulation functions.
	 */
	responseBuffer[numBytesRead] = '\0';

	printf("Info: ADC value read from the device = %.*s", 4, responseBuffer + 12);

	/* Close the comm port handle */
	CloseHandle(hComPort);

	return 0;
}

