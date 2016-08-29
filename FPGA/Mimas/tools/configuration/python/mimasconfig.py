#License
#-------
#This code is published and shared by Numato Systems Pvt Ltd under GNU GPL 
#license with the hope that it may be useful. Read complete license at 
#http://www.gnu.org/licenses/gpl.html or write to Free Software Foundation,
#51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA

#Simplicity and understandability is the primary philosophy followed while
#writing this code. Sometimes at the expence of standard coding practices and
#best practices. It is your responsibility to independantly assess and implement
#coding practices that will satisfy safety and security necessary for your final
#application.

#This Python script will download a binary file to the SPI flash available on 
#Mimas Spartan 6 FPGA developemnt board.

#Prerequisites:
# python 3.x
# pySerial (pySerial 2.7 or newer works with Python 3.x)
# Write access to tty device corresponds to Mimas (or do sudo / login as root)

#This program is made available to the public AS IS with no warranites. This 
#program is tested on the platforms listed below. But it may or may not work 
#on your specific platform. 

#This program is tested on the following platforms 
# 1. Windows 8, Python 3.3, pySerial 2.7
# 2. Ubuntu 14.04, Python 3.4, pySerial 2.7

#Usage : python mimasconfig.py <PORT> <Binary File>
#Example (Windows) : python mimasconfig.py /dev/ttyACM0 mimas.bin
#Example (Ubuntun 14.04) : python3 mimasconfig.py COM3 mimas.bin

#!/usr/bin/python3
import sys
import serial
import struct
import time

IN_BUFFER_FLUSH_DELAY   = 0.05

IO_DIRECTION_OUT		= 0
IO_DIRECTION_IN			= 1

MODE_00    				= 0x00 # Setting for SPI bus Mode 0,0
MODE_01    				= 0x01 # Setting for SPI bus Mode 0,1
MODE_10     			= 0x02 # Setting for SPI bus Mode 1,0
MODE_11     			= 0x03 # Setting for SPI bus Mode 1,1

SPI_FOSC_64   			= 0x02
SMPMID      			= 0x00

CONFIG_OUT_PACKET_SPI_OPEN 					= 0
CONFIG_OUT_PACKET_SPI_CLOSE 				= 1
CONFIG_OUT_PACKET_SPI_GETSTRING 			= 2
CONFIG_OUT_PACKET_SPI_PUTSTRING	 			= 3
CONFIG_OUT_PACKET_SPI_GETSTRING_ATADDRESS 	= 4 
CONFIG_OUT_PACKET_SPI_PUTSTRING_ATADDRESS 	= 5
CONFIG_OUT_PACKET_SPI_GET_CHAR 				= 6
CONFIG_OUT_PACKET_SPI_PUT_CHAR 				= 7
CONFIG_OUT_PACKET_SPI_SET_IO_DIR 			= 8
CONFIG_OUT_PACKET_SPI_SET_IO_VALUE 			= 9
CONFIG_OUT_PACKET_SPI_GET_IO_VALUE 			= 10
CONFIG_OUT_PACKET_SPI_GET_ALL_IO_VALUES 	= 11

CONFIG_IN_PACKET_STATUS						= 0
CONFIG_IN_PACKET_BUFFER						= 1

CONFIG_IO_PIN_SI 		= 0
CONFIG_IO_PIN_SO 		= 1
CONFIG_IO_PIN_CS 		= 2
CONFIG_IO_PIN_CLK	 	= 3
CONFIG_IO_PIN_PROGB 	= 4
CONFIG_IO_PIN_DONE 		= 5
CONFIG_IO_PIN_INITB 	= 6

IO_DIRECTION_OUT		= 0
IO_DIRECTION_IN			= 1

DEV_ID_M45PE10VMN6P             = 0x114020         
DEV_ID_ATMEL_AT45DB021D         = 0x231F
DEV_ID_ATMEL_AT45DB161D         = 0x261F   
DEV_ID_MICRON_M25P16            = 0x152020    

FLASH_ALGORITHM_M45PE10VMN6P    = 0x01
FLASH_ALGORITHM_ATMEL_DATAFLASH = 0x02
FLASH_ALGORITHM_M25P16          = 0x03

#Generic SPI flash commands
SPI_FLASH_READ_ID_9F		    = 0x9F

#Atmel Dataflash specific
ATMEL_DATAFLASH_READ			= 0x03
ATMEL_DATAFLASH_READ_STATUS		= 0xD7
ATMEL_DATAFLASH_BUFFER_WRITE    = 0x84
ATMEL_DATAFLASH_PAGE_PROGRAM    = 0x83

#M45PE10VMN6P Specific
M45PE10VMN6P_WRITE_ENABLE		= 0x06
M45PE10VMN6P_WRITE_DISABLE		= 0x04
M45PE10VMN6P_READ_ID			= 0x9F
M45PE10VMN6P_READ_STATUS		= 0x05
M45PE10VMN6P_READ				= 0x03
M45PE10VMN6P_FAST_READ			= 0x0B
M45PE10VMN6P_PAGE_WRITE			= 0x0A
M45PE10VMN6P_PAGE_PROGRAM		= 0x02
M45PE10VMN6P_PAGE_ERASE			= 0xDB
M45PE10VMN6P_SECTOR_ERASE		= 0xD8
M45PE10VMN6P_DEEP_PWR_DOWN		= 0xB9
M45PE10VMN6P_REL_DEEP_PWR_DOWN	= 0xB9

#M25P16 Specific
M25P16_WRITE_ENABLE		        = 0x06
M25P16_WRITE_DISABLE		    = 0x04
M25P16_READ_ID			        = 0x9F
M25P16_READ_STATUS		        = 0x05
M25P16_READ				        = 0x03
M25P16_FAST_READ			    = 0x0B
M25P16_PAGE_PROGRAM		        = 0x02
M25P16_SECTOR_ERASE		        = 0xD8
M25P16_BULK_ERASE		        = 0xC7
M25P16_DEEP_PWR_DOWN		    = 0xB9
M25P16_REL_DEEP_PWR_DOWN	    = 0xAB

#-------------------------- class MimasConfigDownloader ---------------------#
class MimasConfigDownloader:
	'Configuration downloader class'
	def __init__(self, Port):
		'Try to open the port and initialize the object'
		self.PortObj = serial.Serial(Port, 19200, timeout=1)
		if self.PortObj is None	:
			print("Unable to open port " + Port)
			exit(1)
			
	def SendData(self, Data):
		'The lowest level routine to send raw data to Mimas'
		'Returns total number of writes written'
		i = 0
		bytesWritten = 0;
		#Send data 30 bytes at a time. Mimas can recieve maximum 30 bytes per transaction
		while i < len(Data):
			bytesWritten += self.PortObj.write(Data[i:i+30])
			i += 30
		return bytesWritten
	
	def ReadData(self, count):
		return self.PortObj.read(count)
		
	def SendCommand(self, Command):
		'Send a command to Mimas'
		'This routine will add padding to make all commands 70 bytes long'
		if(len(Command) < 70):
			Command += b" " * (70 - len(Command))
			
		if self.SendData(Command) == 70:
			return 0
		else:
			return 1
		
	def SpiOpen(self):
		'Set up SPI peripheral inside PIC18 chip on Mimas'
		#Packet Structure : Sync Byte, PacketType, SpiNum, SyncMode, BusMode, SmpPhase 
		#                       ~    , 0x00      , 0x01  , 0x02    , 0x00   , 0x00 
		return self.SendCommand(b"\x7e\x00\x01\x02\x00\x00")
		
	def SpiClose(self):
		'Deinitialize and free resources allocated with SpiOpen command'
		#Packet Structure : Sync Byte, PacketType, SpiNum
		#                       ~    , 0x01      , 0x01  
		return self.SendCommand(b"\x7e\x01\x01")
		
	def SpiSetIoDirection(self, Io, Direction):
		'Set direction of IOs that are needed for configuration process'
		#Packet Structure : Sync Byte, PacketType, SpiNum, Io, Direction
		#                       ~    , 0x08      , 0x01  , Io, Direction
		return self.SendCommand(b"\x7e\x08\x01" + struct.pack('BB', Io, Direction))
		
	def SpiSetIoValue(self, Io, Value):
		'Set value of IOs that are needed for configuration process'
		#Packet Structure : Sync Byte, PacketType, SpiNum, Io, Value
		#                       ~    , 0x09      , 0x01  , Io, Value
		return self.SendCommand(b"\x7e\x09\x01" + struct.pack('BB', Io, Value))
		
	def FlushInBuffer(self):
		'Flush input buffer of the port'
		#Sometimes flushInput fails to actually flush the contents of the buffer
		#unless a slight delay is given
		time.sleep(IN_BUFFER_FLUSH_DELAY)
		self.PortObj.flushInput()
		
	def	CheckStatus(self, LastCmd = None):
		'Checks the satus of the last command sent. Use this routine only with commands'
		'that returns generic status response.'
		#Try to read 100 bytes from the input buffer. The maximum amount of data expected
		#is 38 bytes. If we receive more than 38 bytes, that means the input buffer has
		#response from more than one commands. This is means input buffer is not flushed 
		#before sending the last command. Input buffer can flushed by either calling 
		#FlushInBuffer() routine or by reading large enough data from the input buffer.
		#In most cases, simply calling CheckStatus() should clear the input buffer.
		response = self.PortObj.ReadData(100)
		print (response)
		if len(response) > 38:
			return 1
		else:
			if (response[0:1] == b'~') and (response[1:2] == struct.pack('B', CONFIG_IN_PACKET_STATUS)) and (response[3:4] == struct.pack('B', 0)):
				if LastCmd == None:
					return 0
				else:
					if response[4:5] == struct.pack('B', LastCmd):
						return 0
					else:
						return 1
			else:
				return 1
				
	def ToggleCS(self):
		'Toggles Chip Select'
		#Set CS to output
		if self.SpiSetIoDirection(CONFIG_IO_PIN_CS, IO_DIRECTION_OUT):
			return 1;
		
		#De-assert CS
		if self.SpiSetIoValue(CONFIG_IO_PIN_CS, 1):
			return 1
		
		#Assert CS
		return self.SpiSetIoValue(CONFIG_IO_PIN_CS, 0)
		
	def SpiPutChar(self, Char):
		'Writes a character to SPI port'
		#Packet Structure : Sync Byte, PacketType, SpiNum, Char
		#                       ~    , 0x07      , 0x01  , Char
		if self.SendCommand(b"\x7e\x07\x01" + struct.pack('B', Char)):
			return 1
	
	def SpiPutString(self, Buffer, Length):
		'Writes a string/buffer to SPI port'
		#Packet Structure : Sync Byte, PacketType, SpiNum, Char
		#                       ~    , 0x03      , 0x01  , Length, Res0, Res1, data
		if self.SendCommand(b"\x7e\x03\x01" + struct.pack('B', Length) + b"\x00\x00" + Buffer[0:Length]):
			return 1

	def GetString(self, Length):
		'Reads a string/buffer from SPI'
		#Send CONFIG_OUT_PACKET_SPI_GETSTRING command
		#Packet Structure : Sync Byte, PacketType, SpiNum, Length
		#                       ~    , 0x02      , 0x01  , Length
		if self.SendCommand(b"\x7e\x02\x01" + struct.pack('B', Length)):
			return (1, None)
			
		#Read the response and extract data
		response = self.ReadData(38)
		if len(response) != 38:
			return (1, None)
			
		return (0, response[6:6+Length])
	
	def FlashReadID9Fh(self):
		'Reads flash ID using command 9Fh'
		#Toggle CS to get SPI flash to a known state
		if self.ToggleCS():
			return 1
			
		#Write command 9Fh
		if self.SpiPutChar(SPI_FLASH_READ_ID_9F):
			return 1
		
		#Flush input buffer 
		self.FlushInBuffer();
		
		#Read three bytes from SPI flash
		status, string = self.GetString(3)
		
		if status:
			return None
		else:
			idTuple = struct.unpack("=L", string + b'\x00')
			return idTuple[0]

	def M25P16WriteEnable(self):
		'Enable write for SPI  flash M25P16'
		#Toggle CS to get SPI flash to a known state
		if self.ToggleCS():
			return 1
		
		#Send write enable code
		if self.SpiPutChar(M25P16_WRITE_ENABLE):
			return 1
		
		#De-assert CS
		if self.SpiSetIoValue(CONFIG_IO_PIN_CS, 1):
			return 1
			
		return 0
		
	def M25P16ReadStatus(self):
		'Reads M25P16 Status register'
		#Toggle CS to get SPI flash to a known state
		if self.ToggleCS():
			return 1
			
		#Write M25P16_READ_STATUS command
		if self.SpiPutChar(M25P16_READ_STATUS):
			return 1
			
		#Flush input buffer 
		self.FlushInBuffer();
		
		#Read one byte from SPI flash
		status, string = self.GetString(1)
		
		if status:
			return None
		else:
			statusTuple = struct.unpack("B", string)
			return int(statusTuple[0])
			
	def M25P16sectorErase(self, EndAddress):
		'Erases sectors up to the sector that contains EndAddress'
		EndAddress |= 0xFFFF;
		
		i = 0
		
		for i in range(0, EndAddress, 0xFFFF):
			
			#Do write enable
			if self.M25P16WriteEnable():
				return 1
		
			#Toggle CS to get SPI flash to a known state
			if self.ToggleCS():
				return 1
				
			#Send Sector Erase command
			if self.SpiPutChar(M25P16_SECTOR_ERASE):
				return 1
				
			#Send address
			address = struct.pack("i", i)
			
			if self.SpiPutChar(address[2]):
				return 1
				
			if self.SpiPutChar(address[1]):
				return 1
				
			if self.SpiPutChar(address[0]):
				return 1
				
			#De-assert CS
			if self.SpiSetIoValue(CONFIG_IO_PIN_CS, 1):
				return 1

			#Wait for sector erase to complete
			while self.M25P16ReadStatus() & 0x01:
				time.sleep(0.01)

		return 0	
	
	def M25P16PageProgram(self, Buffer, Address, Length):
		'SPI Flash page program'
		if Length > 0x100:
			return 1

		#Do write enable
		if self.M25P16WriteEnable():
			return 1	
			
		#Toggle CS to get SPI flash to a known state
		if self.ToggleCS():
			return 1
			
		#Send page program command
		if self.SpiPutChar(M25P16_PAGE_PROGRAM):
			return 1
			
		#Send address
		address = struct.pack("i", Address)
			
		if self.SpiPutChar(address[2]):
			return 1
				
		if self.SpiPutChar(address[1]):
			return 1
				
		if self.SpiPutChar(address[0]):
			return 1
		
		#Send data 64 bytes at a time
		i = 0
		j = 0
		while Length:
			j = 64 if Length > 64 else Length
			if self.SpiPutString(Buffer[i:i+64], j):
				return(1)
			i += j
			Length -= j;
		
		#De-assert CS
		if self.SpiSetIoValue(CONFIG_IO_PIN_CS, 1):
			return 1
	
	def M25P16VerifyFlash(self, buffer):
		'Reads the contents of flash and compare with data in buffer'
		#Toggle CS to get SPI flash to a known state
		if self.ToggleCS():
			return 1
		
		#Send page program command
		if self.SpiPutChar(M25P16_READ):
			return 1
		
		#Send address bytes
		if self.SpiPutChar(0):
			return 1
				
		if self.SpiPutChar(0):
			return 1
				
		if self.SpiPutChar(0):
			return 1
		
		#Flush input buffer 
		self.FlushInBuffer();
			
		readLength = len(buffer)
		
		readBuffer = b""
		
		while readLength:
			j = 32 if readLength > 32 else readLength
			status, string = self.GetString(j)
			if status:
				return 1
				
			readBuffer += string
			readLength -= j
			
		if readBuffer == buffer:
			return 0
		else:
			return 1
	
	def ConfigureMimas(self, FileName):
		'Configures Mimas'
		
		#Set PROGB to output
		if self.SpiSetIoDirection(CONFIG_IO_PIN_PROGB, IO_DIRECTION_OUT):
			print ("Unable to set PROGB direction")
			exit(1)
		
		#Pull PROGB Low while Flash is being programmed
		if self.SpiSetIoValue(CONFIG_IO_PIN_PROGB, 0):
			print ("Unable to assert PROGB")
			exit(1)
			
		#Open SPI port	
		if self.SpiOpen():
			print ("Unable to openSPI port")
			exit(1)
			
		id = self.FlashReadID9Fh()
		
		if id == None:
			print("Unable to read SPI Flash ID")
			exit(1)
			
		elif id == DEV_ID_MICRON_M25P16:
			print("Micron M25P16 SPI Flash detected")
			FlashAlgorithm = FLASH_ALGORITHM_M25P16
			
		else:
			print("Unknown flash part, exiting...")
			exit(1)
			
		#Execute device specific programming algorithm
		if FlashAlgorithm == FLASH_ALGORITHM_M25P16:

			#Open the binary file and load the contents to buffer
			print("Loading file " + FileName + "...") 
			file = open(FileName, "rb")
			if file == None:
				print("Could not open file " + FileName)
			
			#Find out the size of the file
			file.seek(0, 2)
			fileSize = file.tell()
			fileSizeForProgressInd = fileSize
			
			#Read file in to buffer
			file.seek(0, 0)
			dataBuff = file.read(fileSize)
			file.close()
			
			#Erase flash sectors
			print("Erasing flash sectors...")
			if self.M25P16sectorErase(fileSize):
				print ("Unable to erase flash sectors")
				exit(1)
			
			i, j, address = 0, 0, 0

			while fileSize:
				j = 0x100 if fileSize > 0x100 else fileSize 
				self.M25P16PageProgram(dataBuff[address:address+j], address, j)
				address += j
				fileSize -= j

				#Wait for page program to complete
				while self.M25P16ReadStatus() & 0x01:
					time.sleep(0.01)
				
				sys.stdout.write("Writing to flash " + str(int((address/fileSizeForProgressInd)*100)) + "% complete...\r")
				sys.stdout.flush()
			
			#verify the flash contents
			print("\nVerifying flash contents...")
			
			if self.M25P16VerifyFlash(dataBuff):
				print("Flash verification failed...")
			else:
				print("Flash verification successful...\nBooting FPGA...")
						
				#Set CS to input
				if self.SpiSetIoDirection(CONFIG_IO_PIN_CS, IO_DIRECTION_IN):
					return 1
				
				#De-assert PROGB
				if self.SpiSetIoValue(CONFIG_IO_PIN_PROGB, 1):
					return 1
		
			print("Done.")
		
	def __del__(self):
		self.PortObj.close()
		
#-------------------------- End class MimasConfigDownloader -----------------#

def main():
	print("****************************************")
	print("* Numato Lab Mimas Configuration Tool *")
	print("****************************************")
	
	if(len(sys.argv) != 3):
		print("ERROR: Invalid number of arguments.\n")
		print("Usage : mimasconfig.py <PORT> <Binary File>\n")
		print("PORT - The serial portcorresponds to Mimas (Eg: COM1)\n")
		print("Binary File - Binary file to be downloaded. Please see Mimas")
		print("documentation for more details on generating binary file from")
		print("your design.")
		exit(1)
	
		
	MimasconfigObj = MimasConfigDownloader(sys.argv[1])
	MimasconfigObj.ConfigureMimas(sys.argv[2])


if __name__ == "__main__":
	main()
