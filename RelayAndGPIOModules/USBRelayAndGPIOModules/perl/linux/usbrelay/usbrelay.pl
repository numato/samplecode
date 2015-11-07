# Numato Lab - http://numato.com
# This Perl sample script opens the port and sends two commands to the device. These commands 
# will turn on Relay0, wait for 2 seconds and then turn off.
# Please follow the steps below to test the script.
#
# 1. Install Perl and then install Device::SerialPort perl modules from the following link
#    Device::SerialPort (For Linux) - http://search.cpan.org/dist/Device-SerialPort/SerialPort.pm
# 2. Attach the Relay Module to the PC and note the port identifier corresponding to the device
# 3. Update the line below that starts with "$portName =" with the port number for your device
# 4. Comment/uncomment lines below as necessary (see associated comments)
# 5. Run the script by entering the command "perl usbrelay.pl" at command line

use Device::SerialPort;

$portName = "/dev/ttyACM0";
 				 
$serPort = new Device::SerialPort($portName, quiet) || die "Could not open the port specified";

# Configure the port	   
$serPort->baudrate(9600);
$serPort->parity("none");
$serPort->databits(8);
$serPort->stopbits(1);
$serPort->handshake("none"); #Most important
$serPort->buffers(4096, 4096); 
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
