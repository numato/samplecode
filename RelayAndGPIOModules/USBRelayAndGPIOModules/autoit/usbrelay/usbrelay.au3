; Numato Lab - http://numato.com
; This AutoIt sample script opens the port and sends two commands to the device. These commands 
; will turn on Relay0, wait for 2 seconds and then turn off.
; Please follow the steps below to test the script.
;
; 1. Download and install AutoIt from https://www.autoitscript.com/site/autoit/
; 2. Download AutoIt CommAPI scripts from https://www.autoitscript.com/wiki/CommAPI and place with this script
; 3. Attach the Relay Module to the PC and note the port identifier corresponding to the device
; 4. Update the line below that starts with "$port = " with the port number for your device
; 5. Run the script by double clicking on the script or running from command line

#include "CommInterface.au3"

$port = 5

$hPort = _CommAPI_OpenCOMPort($port, 19200, 0, 8, 1)
If @error Then MsgBox($MB_ICONERROR, "Failed to open port", _WinAPI_GetLastErrorMessage())

_CommAPI_TransmitString($hPort, "relay on 0" & @CR)
If @error Then MsgBox($MB_ICONERROR, "Unable to write to device", _WinAPI_GetLastErrorMessage())

Sleep(2000);

_CommAPI_TransmitString($hPort, "relay off 0" & @CR)
If @error Then MsgBox($MB_ICONERROR, "Unable to write to device", _WinAPI_GetLastErrorMessage())

MsgBox($MB_OK, "Done!", "Commands sent successfully!")

_CommAPI_ClosePort($hPort)