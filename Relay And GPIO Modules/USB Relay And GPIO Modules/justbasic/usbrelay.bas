' JustBASIC USB Relay Test Program. For more info on using serial port with JustBASIC, please visit http://lbpe.wikispaces.com/AccessingSerialPort
' This short program will turn a relay on or off
' Modify the lines below to change the port, command and relay number appropriately

port$ = "com4"
command$ = "on" ' on or off
relaynum$ = "0" ' Number of the relay you would like to control


OPEN port$ + ":9600,N,8,1,CD0,CS0,DS0,OP0,RS" FOR RANDOM AS #comm
PRINT #comm, "relay " + command$ + " " + relaynum$ + CHR$(13);
CLOSE #comm
END
























