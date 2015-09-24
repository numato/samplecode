# Numato Lab - http://numato.com
# This Perl sample script opens the port and sends two commands to the device. These commands 
# will turn on GPIO0, wait for 2 seconds and then turn off.
# Please follow the steps below to test the script.
#
# 1. Install Perl and then install Device::SerialPort perl modules from the following link
#    Device::SerialPort (For Linux) - http://search.cpan.org/dist/Device-SerialPort/SerialPort.pm
# 2. Attach the Relay Module to the PC and note the port identifier corresponding to the device
# 3. Update the line below that starts with "$portName =" with the port number for your device
# 4. Comment/uncomment lines below as necessary (see associated comments)
# 5. Run the script by entering the command "perl usbgpio.pl" at command line

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
                  
#                              GPIO commands set/clear/read
				   				   
###########################################################################################

$serPort->purge_all;

#Send "gpio set" command to the device
$serPort->write("gpio set 0\r");
print "\ngpio set 0";

print "\nWaiting for 2 seconds";
sleep(2);

$serPort->purge_all;

#Send "gpio clear" command to the device
$serPort->write("gpio clear 0\r");
print "\ngpio clear 0";	
sleep(1);
	
$serPort->purge_all;

#Send "gpio read" command to the device
$serPort->write("gpio read 0\r");
sleep(1);

#Read response from device
($count, $data) = $serPort->read(25);

#Parse and print
$substring = substr $data,0,$count - 2; 
print "\nValue received $substring"; 
