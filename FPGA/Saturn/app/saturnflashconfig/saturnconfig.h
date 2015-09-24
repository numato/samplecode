#include <wx/wx.h>
#include "windows.h"

#define MAX_DEVICES 32
#define TOO_MANY_DEVICES 28

#define SPI_CONFIG_OPTION_MODE0         0x00000000
#define SPI_CONFIG_OPTION_MODE1         0x00000001
#define SPI_CONFIG_OPTION_MODE2         0x00000002
#define SPI_CONFIG_OPTION_MODE3         0x00000003

#define SPI_CONFIG_OPTION_CS_DBUS3      0x00000000 
#define SPI_CONFIG_OPTION_CS_DBUS4      0x00000004 
#define SPI_CONFIG_OPTION_CS_DBUS5      0x00000008
#define SPI_CONFIG_OPTION_CS_DBUS6      0x0000000C 
#define SPI_CONFIG_OPTION_CS_DBUS7      0x00000010

#define SPI_CONFIG_OPTION_CS_ACTIVELOW  0x00000020

/*typedef struct _CS_PINS{
  unsigned char  ADBUS3CSDisabledState;
  unsigned char  ADBUS4CSDisabledState;
  unsigned char  ADBUS5CSDisabledState;
  unsigned char  ADBUS6CSDisabledState;
  unsigned char  ADBUS7CSDisabledState;
}CS_PINS, *PTR_CS_PINS;

typedef struct _IO_STATES{
  unsigned char  ADBUS4IOState;
  unsigned char  ADBUS4LowHighState;
  unsigned char  ADBUS5IOState;
  unsigned char  ADBUS5LowHighState;
  unsigned char  ADBUS6IOState;
  unsigned char  ADBUS6LowHighState;
  unsigned char  ADBUS7IOState;
  unsigned char  ADBUS7LowHighState;
}IO_STATES, *PTR_IO_STATES;*/

typedef struct _ft_device_list_info_node {
    unsigned int Flags;
    unsigned int Type;
    unsigned int ID; 
    unsigned int LocId; 
    char SerialNumber[16]; 
    char Description[64]; 
    unsigned int ftHandle; 
} FT_DEVICE_LIST_INFO_NODE, *PTR_FT_DEVICE_LIST_INFO_NODE;

typedef struct _CHANNEL_CONFIG{
    unsigned int ClockRate;
    unsigned char LatencyTimer;
    unsigned int configOptions;
    unsigned int Pins;
    unsigned short reserved;
}CHANNEL_CONFIG, *PTR_CHANNEL_CONFIG;

#ifdef __cplusplus
extern "C" {
#endif

/*unsigned int SPI_GetDllVersion(char *lpDllVersionBuffer, int bufferSize);
unsigned int SPI_GetNumDevices(unsigned int *lpdwNumDevices);
unsigned int SPI_GetDeviceNameLocID(unsigned int dwDeviceNameIndex, char* lpDeviceNameBuffer, unsigned int dwBufferSize, unsigned int* lpdwLocationID);
unsigned int SPI_SetGPIOs(unsigned int ftHandle, PTR_CS_PINS chipSelectStates, PTR_IO_STATES ioPinsData);
unsigned int SPI_OpenEx(char *lpDeviceName, unsigned int dwLocationID, unsigned int *pftHandle);
unsigned int SPI_Close(unsigned int Handle);*/

void Init_libMPSSE(void);
void Cleanup_libMPSSE(void);
unsigned int SPI_GetNumChannels(unsigned int *numChannels);
unsigned int SPI_GetChannelInfo(unsigned int index, FT_DEVICE_LIST_INFO_NODE *chanInfo);
unsigned int SPI_OpenChannel (unsigned int index, unsigned int *handle);
unsigned int SPI_CloseChannel (unsigned int handle);
unsigned int SPI_InitChannel (unsigned int handle, CHANNEL_CONFIG *config);
unsigned int FT_WriteGPIO(unsigned int handle, unsigned char dir, unsigned char value);
unsigned int SPI_Write(unsigned int handle, unsigned char *buffer, unsigned int sizeToTransfer, unsigned int *sizeTransferred, unsigned int transferOptions);
unsigned int SPI_Read(unsigned int handle, unsigned char *buffer, unsigned int sizeToTransfer, unsigned int *sizeTransferred, unsigned int transferOptions);
#ifdef __cplusplus
}
#endif

typedef struct _SPI_DEVICE{
    wxString deviceName;
    unsigned int index;
}SPI_DEVICE, *PTR_SPI_DEVICE;


class saturnConfig{

public:
    unsigned int numDevices;
    unsigned char *bitFileBuffer;
    unsigned int bitFileSize;
   
   SPI_DEVICE spiDevices[MAX_DEVICES];
   unsigned int handle;
   
   virtual void clearLog();
   virtual void addLog(wxString log);
   virtual void addDeviceToList(wxString deviceName);
   virtual void updateStatus(unsigned int value);
   virtual void setMaxStatusValue(unsigned int maxValue);
   virtual void refreshUI();
   
   saturnConfig();
   ~saturnConfig();
   int scanDevices(); 
   unsigned int openSPI(unsigned int index);
   void closeSPI();
   unsigned int writeToFlash(unsigned char *buffer, unsigned int numBytes, unsigned char assertCS, unsigned char deAssertCS);
   unsigned int readFromFlash(unsigned char *buffer, unsigned int numBytes, unsigned char assertCS, unsigned char deAssertCS);
   unsigned int FlashReadID9Fh(unsigned char* buffer, unsigned char len);
   unsigned int flashWriteEnable(void);
   unsigned int flashReadStatus(unsigned char* buffer);
   unsigned int flashWriteStatus(unsigned char value);
   unsigned int dataRead(unsigned char* buffer, __int32 address, unsigned int length);
   unsigned int verify(void);
   unsigned int bulkErase();
   unsigned int programFlash();
   unsigned int pageProgram(unsigned char* buffer, __int32 address, unsigned int length);
   unsigned int sectorErase(unsigned int endAddress);
   
   unsigned int LoadFile(LPCTSTR FileName);

};
