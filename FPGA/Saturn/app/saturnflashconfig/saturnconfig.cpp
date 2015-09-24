#include "saturnconfig.h"
#include "string.h"
#include <stdlib.h>

#include <wx/file.h>

saturnConfig::saturnConfig()
{
    numDevices = 0;
    handle =0;
    
    //Initialize libMPSSE and allocate memory to hold bit file data
    Init_libMPSSE();
    bitFileBuffer = (unsigned char*)calloc(2097152, 1);
}

saturnConfig::~saturnConfig()
{
    free(bitFileBuffer);
    closeSPI();
}

void saturnConfig::clearLog()
{
    //Do nothing
}

void saturnConfig::addLog(wxString log)
{
    //Do nothing
}

void saturnConfig::addDeviceToList(wxString deviceName)
{
    //Do nothing
}

void saturnConfig::updateStatus(unsigned int value)
{
    //Do nothing
}

void saturnConfig::setMaxStatusValue(unsigned int maxValue)
{
    //Do nothing
}

void saturnConfig::refreshUI()
{
    //Do nothing
}

unsigned int saturnConfig::LoadFile(LPCTSTR FileName)
{
	HANDLE hFile;
	DWORD bytesRead;

	hFile = CreateFile(FileName, GENERIC_READ, FILE_SHARE_WRITE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);

	if(!hFile)
	{
        addLog(wxT("Unable to open the selected file..."));
		return GetLastError();
	}

	if(!ReadFile(hFile, bitFileBuffer, 2097152, &bytesRead, NULL))
	{
        addLog(wxT("Unable to read the selected file..."));
		CloseHandle(hFile);
		return GetLastError();
	}

    //Keep the total number of bytes in the bit file for later use
    bitFileSize = bytesRead;
    
    if(!bitFileSize)
    {
        addLog(wxT("Failed to read the selected file..."));
    }

	CloseHandle(hFile);
	
	return 0;
}

int saturnConfig::scanDevices()
{
    unsigned int status = 0, i = 0;
    unsigned int numChannels = 0;
    FT_DEVICE_LIST_INFO_NODE deviceInfoNode;
    
    status = SPI_GetNumChannels(&numChannels);
    
    if(status)
    {
        addLog(wxT("SPI_GetNumChannels failed..."));
    }
        
    if(numChannels > MAX_DEVICES)
    {
        addLog(wxT("Too many devices connected..."));
        return 28;
    }
    
    numDevices = 0;
    
    //Walk through all available channels and identify those channels associated with a Saturn board
    for(i=0; i<numChannels; i++)
    {
        status = SPI_GetChannelInfo(i, &deviceInfoNode);
        
        if(status)
        {
            addLog(wxT("Unable to get more details on channel") + wxString::Format(wxT(" %x"), i));
        }
        else
        {
            //SPI flash is connected to channel A
            if(strstr(deviceInfoNode.Description, "Saturn Spartan 6 FPGA Module A"))
            {
                //Save channel information
                deviceInfoNode.Description[29] = 0;
                spiDevices[numDevices].deviceName = wxString::FromUTF8(deviceInfoNode.Description);
                spiDevices[numDevices].index = i;
                
                addDeviceToList(wxString::FromUTF8(spiDevices[numDevices].deviceName) + wxString::Format(wxT(" %x"), i));
                numDevices++;
            }
        }
    }
    
    return 0;
}

unsigned int saturnConfig::openSPI(unsigned int index)
{
    unsigned int status = 0;
    CHANNEL_CONFIG config;
    
    if(handle)
    {
        return 0;
    }
    
    status = SPI_OpenChannel(spiDevices[index].index, &handle);
    
    if(status)
    {
        addLog(wxT("Unable to open handle to device at index ") + wxString::Format(wxT(" %x"), index));
        return status;
    }
    
    //Configure and init SPI channel 
    config.ClockRate = 6000000;
    config.LatencyTimer = 1;
    config.configOptions = SPI_CONFIG_OPTION_MODE0 | SPI_CONFIG_OPTION_CS_DBUS3 | SPI_CONFIG_OPTION_CS_ACTIVELOW;
    config.Pins = 0x00008080;
    
    return SPI_InitChannel(handle, &config);
}

void saturnConfig::closeSPI()
{
    if(handle)
    {
        SPI_CloseChannel(handle);
        handle = 0;
    }
    
    Cleanup_libMPSSE();
}

unsigned int saturnConfig::writeToFlash(unsigned char *buffer, unsigned int numBytes, unsigned char assertCS, unsigned char deAssertCS)
{
    unsigned int  status = 0, sizeTransferred = 0, transferOptions = 0;
    
    if(assertCS)
    {
        transferOptions = 0x02;
    }
    
    if(deAssertCS)
    {
        transferOptions |= 0x04;
    }
    
    status = SPI_Write(handle, buffer, numBytes, &sizeTransferred, transferOptions);
       
    if(status)
    {
        return status;
    }
       
    if(numBytes != sizeTransferred)
    {
        return 18;
    }
    
    return 0;
}

unsigned int saturnConfig::readFromFlash(unsigned char *buffer, unsigned int numBytes, unsigned char assertCS, unsigned char deAssertCS)
{
    unsigned int  status = 0, sizeTransferred = 0, transferOptions = 0;
    
    if(assertCS)
    {
        transferOptions = 0x02;
    }
    
    if(deAssertCS)
    {
        transferOptions |= 0x04;
    }

    status = SPI_Read(handle, buffer, numBytes, &sizeTransferred, transferOptions);

    if(status)
    {
        return status;
    }
    
    if(numBytes != sizeTransferred)
    {
        return 18;
    }
    
    return 0;
}

unsigned int saturnConfig::FlashReadID9Fh(unsigned char* buffer, unsigned char len)
{
    unsigned int status = 0;
    unsigned char command = 0x9F;
    
    status = writeToFlash(&command, 1, 1, 0);
        
    if(status)
    {
        return status;
    }
    
    return readFromFlash(buffer, len, 0, 1);
}

unsigned int saturnConfig::flashWriteEnable()
{
    unsigned char command = 0x06;
	return writeToFlash(&command, 1, 1, 1);
}

unsigned int saturnConfig::flashReadStatus(unsigned char* buffer)
{
    unsigned int status = 0;
    unsigned char command = 0x05;
    
    status = writeToFlash(&command, 1, 1, 0);

    if(status)
    {
        return status;
    }
    
    return readFromFlash(buffer, 1, 0, 1);
}

unsigned int saturnConfig::flashWriteStatus(unsigned char value)
{
    unsigned int status = 0;
    unsigned char command = 0x01;
    
    status = writeToFlash(&command, 1, 1, 0);

    if(status)
    {
        return status;
    }
    
    return writeToFlash(&value, 1, 0, 1);
}

unsigned int saturnConfig::dataRead(unsigned char *buffer, __int32 address, unsigned int length)
{
    unsigned int status = 0;
    unsigned char command = 0x03;
    unsigned int transferSize = 32768;
    unsigned int tmp = length;
       
    status = writeToFlash(&command, 1, 1,0);
    
    //Address is written MSB first
    status |= writeToFlash((((unsigned char *) &address)+2), 1, 1, 0);
    status |= writeToFlash((((unsigned char *) &address)+1), 1, 1, 0);
    status |= writeToFlash((((unsigned char *) &address)), 1, 1, 0);
    
    if(status)
    {
        return status;
    }
          
	while(length)
	{
        if(length<transferSize)
        {
            transferSize = length;
            length = 0;
        }
        else
        {
            length -= transferSize;
        }
	        
        status = readFromFlash(buffer, transferSize, 0, 0);
        address += transferSize;
        buffer += transferSize;
        
        if(status)
        {
            return status;
        }
	}
	
    //Dummy read to de-assert chip select
	readFromFlash(&command, 1, 0, 1);
    
	return 0;
}

unsigned int saturnConfig::verify()
{
    unsigned char *readBuffer, *tmpptr;
    unsigned int i, status = 0;
    
    //wxFile *file = new wxFile("Out.bin", wxFile::write);
    
    if(!bitFileSize)
    {
        addLog(wxT("Bit file not loaded ?"));
        return 1000;
    }
   
    readBuffer = (unsigned char*)calloc(bitFileSize, 1);
    //memset(readBuffer, 0xAA, bitFileSize);
    
    if(!readBuffer)
    {
        addLog(wxT("Unable to allocate memory for read buffer..."));
    }
     
    status = dataRead(readBuffer, 0, bitFileSize);

    if(status)
    {
        addLog(wxT("Unable to read from flash device..."));
        return status;
    }  
    
    //file->Write(readBuffer, bitFileSize);
    //file->Close();
    
    if(!memcmp(bitFileBuffer, readBuffer, bitFileSize))
    {
        addLog(wxT("Programming completed..."));
    }
    else
    {
        addLog(wxT("Programming failed..."));
    }
    
    free(readBuffer);
}

unsigned int saturnConfig::bulkErase()
{
	unsigned char statusReg = 0x01;
    unsigned int status = 0;
    unsigned char command = 0xc7;
    
    status = flashWriteEnable();
    
    if(status)
    {
        return status;
    }
    status = writeToFlash(&command, 1, 1,1);
    
    if(status)
    {
        return status;
    }

	statusReg = 0x01;

	while(statusReg & 0x01)
	{
		status = flashReadStatus(&statusReg);
        
        if(status)
        {
            return status;
        }
	}	

	return 0;
}

unsigned int saturnConfig::programFlash()
{
    unsigned int length = bitFileSize;
    unsigned char *buffer = bitFileBuffer;
    unsigned int sectorSize = 256;
    __int32 address = 0;
    unsigned int status = 0;

    addLog(wxT("Programming flash..."));

    setMaxStatusValue(bitFileSize);

    while(length)
	{
    
        if(length<sectorSize)
        {
            sectorSize = length;
            length = 0;
        }
        else
        {
            length -= sectorSize;
        }
        
        status = pageProgram(buffer, address, sectorSize);
        address += sectorSize;
        buffer += sectorSize;
        
        if(status)
        {
            return status;
        }
        
        updateStatus(bitFileSize - length);
		refreshUI();
    }
    
	return 0;
}

unsigned int saturnConfig::pageProgram(unsigned char* buffer, __int32 address, unsigned int length)
{
    unsigned int status = 0;
    unsigned char command = 0x02;
    unsigned char statusReg;
  
    if(length > 256)
    {
        addLog(wxT("Incorrect length requested for page program..."));
        length = 256;
    }
    
    status = flashWriteEnable();
    if(status)
    {
        return status;
    }
    
    status = writeToFlash(&command, 1, 1,0);
    
    //Address is written MSB first
    status |= writeToFlash((((unsigned char *) &address)+2), 1, 1, 0);
    status |= writeToFlash((((unsigned char *) &address)+1), 1, 1, 0);
    status |= writeToFlash((((unsigned char *) &address)), 1, 1, 0);
    status |= writeToFlash(buffer, length, 1, 1);
    
    if(status)
    {
        return status;
    }
    
    statusReg = 0x01;

	while(statusReg & 0x01)
	{
		status = flashReadStatus(&statusReg);
        if(status)
        {
            return status;
        }
	}	
    
    return 0;
}

unsigned int saturnConfig::sectorErase(unsigned int endAddress)
{
    unsigned int status = 0, i = 0;
    unsigned char command = 0xd8;
    unsigned char statusReg;
    
    addLog(wxT("Erasing flash sectors..."));
    
    setMaxStatusValue(endAddress);
    endAddress |= 0xFFFF;

    for(i = 0; i < endAddress;i += 0xFFFF)
    {
        status = flashWriteEnable();
        if(status)
        {
            return status;
        }
        
        status = writeToFlash(&command, 1, 1,0);
        
        //Address is written MSB first
        status |= writeToFlash((((unsigned char *) &i)+2), 1, 1, 0);
        status |= writeToFlash((((unsigned char *) &i)+1), 1, 1, 0);
        status |= writeToFlash((((unsigned char *) &i)), 1, 1, 1);
        
        if(status)
        {
            return status;
        }
        
        statusReg = 0x01;
    
    	while(statusReg & 0x01)
    	{
    		status = flashReadStatus(&statusReg);
    		refreshUI();
            
            if(status)
            {
                return status;
            }
    	} 
    	
    	updateStatus(i);
    }
}
