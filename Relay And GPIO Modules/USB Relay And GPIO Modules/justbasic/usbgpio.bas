' JustBASIC USB GPIO Test Program. For more info on using serial port with JustBASIC, please visit http://lbpe.wikispaces.com/AccessingSerialPort
' This short program will set or clear a GPIO
' Modify the lines below to change the port, command and GPIO number appropriately

port$ = "com4"
command$ = "set" ' set or clear
gpionum$ = "0" ' Number of the GPIO you would like to control


OPEN port$ + ":9600,N,8,1,CD0,CS0,DS0,OP0,RS" FOR RANDOM AS #comm
PRINT #comm, "gpio " + command$ + " " + gpionum$ + CHR$(13);
CLOSE #comm
END
























