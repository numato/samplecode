;##############################################################################
;#                                                                            #
;#           Autohotkey Script to control Numato Lab USB GPIO Module          #
;#                           www.numato.com                                   #
;# Uses subroutines from the script published by aobrien at http://www.autoho #
;# tkey.com/board/topic/26231-serial-com-port-console-script/#187247          #
;#                                                                            #
;#         This script can be used with all Numato USB GPIO modules.          #
;##############################################################################

SendMode Input
SetWorkingDir %A_ScriptDir%

InputBox, comport, Enter Port Number, Simply enter the decimal number. COM will be added automatically.,,,,,,,,0
if ErrorLevel
	ExitApp

InputBox, gpionum, Enter GPIO Number ,Enter the number of the GPIO. GPIOs are usually numbered 0 - 9 then A - Z. Make sure to use upper case letters when typing GPIO numbers from A onwards.  ,,,,,,,,0
if ErrorLevel
	ExitApp
	
InputBox, gpiocommand, Enter GPIO Command (set/clear/read),Enter command (set/clear/read),,,,,,,,read 
if ErrorLevel
	ExitApp
	
if ( not gpiocommand = "set" and not gpiocommand = "clear" and not gpiocommand = "read"){
	msgbox Please enter a valid GPIO command
	ExitApp
}

RS232_Port = COM%comport%
	
RS232_Settings = %RS232_Port%:baud=19200 parity=N data=8 stop=1 dtr=Off xon=off to=off odsr=off octs=off rts=off idsr=off
RS232_FileHandle:=RS232_Initialize(RS232_Settings)

if (gpiocommand = "set"){
	command = gpio set %gpionum%`r
	RS232_Write(RS232_FileHandle, command)
}

if (gpiocommand = "clear"){
	command = gpio clear %gpionum%`r
	RS232_Write(RS232_FileHandle, command)
}

if (gpiocommand = "read"){
	command = gpio read %gpionum%`r
	RS232_Write(RS232_FileHandle, command)
	Sleep, 10
	Read_Data := RS232_Read(RS232_FileHandle, 20,RS232_Bytes_Received)
	
	StringGetPos OutputVar, Read_Data, 0`n`r>
	if(not ErrorLevel)
		msgbox GPIO is Off
		
	StringGetPos OutputVar, Read_Data, 1`n`r>
	if(not ErrorLevel)
		msgbox GPIO is On
}

RS232_Close(RS232_FileHandle)
ExitApp

;########################################################################
;#                      Initialize RS232 Port                           #
;########################################################################
RS232_Initialize(RS232_Settings)
{
  ;###### Extract/Format the RS232 COM Port Number ######
  ;7/23/08 Thanks krisky68 for finding/solving the bug in which RS232 COM Ports greater than 9 didn't work.
  StringSplit, RS232_Temp, RS232_Settings, `:
  RS232_Temp1_Len := StrLen(RS232_Temp1)  ;For COM Ports > 9 \\.\ needs to prepended to the COM Port name.
  If (RS232_Temp1_Len > 4)                   ;So the valid names are
    RS232_COM = \\.\%RS232_Temp1%             ; ... COM8  COM9   \\.\COM10  \\.\COM11  \\.\COM12 and so on...
  Else                                          ;
    RS232_COM = %RS232_Temp1%

  ;8/10/09 A BIG Thanks to trenton_xavier for figuring out how to make COM Ports greater than 9 work for USB-Serial Dongles.
  StringTrimLeft, RS232_Settings, RS232_Settings, RS232_Temp1_Len+1 ;Remove the COM number (+1 for the semicolon) for BuildCommDCB.
  ;MsgBox, RS232_COM=%RS232_COM% `nRS232_Settings=%RS232_Settings%

  ;###### Build RS232 COM DCB ######
  ;Creates the structure that contains the RS232 COM Port number, baud rate,...
  VarSetCapacity(DCB, 28)
  BCD_Result := DllCall("BuildCommDCB"
       ,"str" , RS232_Settings ;lpDef
       ,"UInt", &DCB)        ;lpDCB
  If (BCD_Result <> 1)
  {
    MsgBox, There is a problem with Serial Port communication. `nFailed Dll BuildCommDCB, BCD_Result=%BCD_Result% `nThe Script Will Now Exit.
    Exit
  }

  ;###### Create RS232 COM File ######
  ;Creates the RS232 COM Port File Handle
  RS232_FileHandle := DllCall("CreateFile"
       ,"Str" , RS232_COM     ;File Name         
       ,"UInt", 0xC0000000   ;Desired Access
       ,"UInt", 3            ;Safe Mode
       ,"UInt", 0            ;Security Attributes
       ,"UInt", 3            ;Creation Disposition
       ,"UInt", 0            ;Flags And Attributes
       ,"UInt", 0            ;Template File
       ,"Cdecl Int")

  If (RS232_FileHandle < 1)
  {
    MsgBox, There is a problem with Serial Port communication. `nFailed Dll CreateFile, RS232_FileHandle=%RS232_FileHandle% `nThe Script Will Now Exit.
    Exit
  }

  ;###### Set COM State ######
  ;Sets the RS232 COM Port number, baud rate,...
  SCS_Result := DllCall("SetCommState"
       ,"UInt", RS232_FileHandle ;File Handle
       ,"UInt", &DCB)          ;Pointer to DCB structure
  If (SCS_Result <> 1)
  {
    MsgBox, There is a problem with Serial Port communication. `nFailed Dll SetCommState, SCS_Result=%SCS_Result% `nThe Script Will Now Exit.
    RS232_Close(RS232_FileHandle)
    Exit
  }

  ;###### Create the SetCommTimeouts Structure ######
  ReadIntervalTimeout        = 0x00000001
  ReadTotalTimeoutMultiplier = 0x00000000
  ReadTotalTimeoutConstant   = 0x00000000
  WriteTotalTimeoutMultiplier= 0x00000000
  WriteTotalTimeoutConstant  = 0x00000000

  VarSetCapacity(Data, 20, 0) ; 5 * sizeof(DWORD)
  NumPut(ReadIntervalTimeout,         Data,  0, "UInt")
  NumPut(ReadTotalTimeoutMultiplier,  Data,  4, "UInt")
  NumPut(ReadTotalTimeoutConstant,    Data,  8, "UInt")
  NumPut(WriteTotalTimeoutMultiplier, Data, 12, "UInt")
  NumPut(WriteTotalTimeoutConstant,   Data, 16, "UInt")

  ;###### Set the RS232 COM Timeouts ######
  SCT_result := DllCall("SetCommTimeouts"
     ,"UInt", RS232_FileHandle ;File Handle
     ,"UInt", &Data)         ;Pointer to the data structure
  If (SCT_result <> 1)
  {
    MsgBox, There is a problem with Serial Port communication. `nFailed Dll SetCommState, SCT_result=%SCT_result% `nThe Script Will Now Exit.
    RS232_Close(RS232_FileHandle)
    Exit
  }
  
  Return %RS232_FileHandle%
}

;########################################################################
;#                         Close RS232 Port                             #
;########################################################################
RS232_Close(RS232_FileHandle)
{
  ;###### Close the COM File ######
  CH_result := DllCall("CloseHandle", "UInt", RS232_FileHandle)
  If (CH_result <> 1)
    MsgBox, Failed Dll CloseHandle CH_result=%CH_result%

  Return
}

;########################################################################
;#                         Write to RS232 Port                          #
;########################################################################
RS232_Write(RS232_FileHandle,Message)
{

  ;###### Write the data to the RS232 COM Port ######
  WF_Result := DllCall("WriteFile"
       ,"UInt" , RS232_FileHandle ;File Handle
       ,"UInt" , &Message          ;Pointer to string to send
       ,"UInt" , Strlen(Message)            ;Data Length
       ,"UInt*", Bytes_Sent     ;Returns pointer to num bytes sent
       ,"Int"  , "NULL")
  If (WF_Result <> 1 or Bytes_Sent <> Strlen(Message))
    MsgBox, Failed Dll WriteFile to RS232 COM, result=%WF_Result% `nData Length=%Data_Length% `nBytes_Sent=%Bytes_Sent%
}

;########################################################################
;#                         Read from RS232 port                         #
;########################################################################
RS232_Read(RS232_FileHandle,Num_Bytes,ByRef RS232_Bytes_Received)
{
  SetFormat, Integer, HEX

  ;Set the Data buffer size, prefill with 0x55 = ASCII character "U"
  ;VarSetCapacity won't assign anything less than 3 bytes. Meaning: If you
  ;  tell it you want 1 or 2 byte size variable it will give you 3.
  Data_Length  := VarSetCapacity(Data, Num_Bytes, 0x55)
  ;MsgBox, Data_Length=%Data_Length%

  ;###### Read the data from the RS232 COM Port ######
  ;MsgBox, RS232_FileHandle=%RS232_FileHandle% `nNum_Bytes=%Num_Bytes%
  Read_Result := DllCall("ReadFile"
       ,"UInt" , RS232_FileHandle   ; hFile
       ,"Str"  , Data             ; lpBuffer
       ,"Int"  , Num_Bytes        ; nNumberOfBytesToRead
       ,"UInt*", RS232_Bytes_Received   ; lpNumberOfBytesReceived
       ,"Int"  , 0)               ; lpOverlapped

  ;MsgBox, RS232_FileHandle=%RS232_FileHandle% `nRead_Result=%Read_Result% `nBR=%RS232_Bytes_Received% ,`nData=%Data%
  If (Read_Result <> 1)
  {
    MsgBox, There is a problem with Serial Port communication. `nFailed Dll ReadFile on RS232 COM, result=%Read_Result% - The Script Will Now Exit.
    RS232_Close(RS232_FileHandle)
    Exit
  }

  Return Data
}
