# Numato Lab - http://numato.com
# This Perl sample script opens the port and sends two commands to the device. These commands 
# will turn on Relay0, wait for 2 seconds and then turn off.
# Please follow the steps below to test the script.
#
# 1. Install Perl and then install Win32::SerialPort perl modules from the following link
#    Win32::SerialPort (For Windows)- http://search.cpan.org/~bbirth/Win32-SerialPort-0.22/lib/Win32/SerialPort.pm
# 2. Attach the Relay Module to the PC and note the port identifier corresponding to the device
# 3. Update the line below that starts with "$portName =" with the port number for your device
# 4. Comment/uncomment lines below as necessary (see associated comments)
# 5. Run the script by entering the command "perl usbrelay.pl" at command line

use Win32::SerialPort;

$portName = "COM5";

$serPort = new Win32::SerialPort($portName, quiet) || die "Could not open the port specified";

# Configure the port	   
$serPort->baudrate(9600);
$serPort->parity("none");
$serPort->databits(8);
$serPort->stopbits(1);
$serPort->handshake("none"); #Most important
$serPort->buffers(4096, 4096); 
$serPort->read_interval(100);   
$serPort->read_char_time(5);  
$serPort->read_const_time(100); 
$serPort->write_char_time(5);
$serPort->write_const_time(100);
$serPort->lookclear();

$serPort->purge_all;

###########################################################################################
                
#                      Get version and id
				
###########################################################################################	

#Send "ver" command to the device
$serPort->write("ver\r"); 
sleep(1);

#Read response from device
($count,$data) = $serPort->read(25); 

#Parse and print
$substring = substr $data,0,$count - 2;
print "\n$substring";

#Send "id get" command to the device
$serPort->write("id get\r"); #Sending "id get" command to the device
sleep(1);

#Read response from device
($count, $data) = $serPort->read(25); #read data from the device

#Parse and print
$substring = substr $data,0,$count - 2;
print "\n$substring";

###########################################################################################
                  
#                              Relay commands on/off/read
				   				   
###########################################################################################

$serPort->purge_all;

#Send "relay on" command to the device
$serPort->write("relay on 0\r");
print "\nrelay on 0";

print "\nWaiting for 2 seconds";
sleep(2);

$serPort->purge_all;

#Send "relay off" command to the device
$serPort->write("relay off 0\r");
print "\nrelay off 0";	
sleep(1);
	
$serPort->purge_all;

#Send "relay read" command to the device
$serPort->write("relay read 0\r");
sleep(1);

#Read response from device
($count, $data) = $serPort->read(25);

#Parse and print
$substring = substr $data,0,$count - 2; 
print "\nValue received $substring"; 