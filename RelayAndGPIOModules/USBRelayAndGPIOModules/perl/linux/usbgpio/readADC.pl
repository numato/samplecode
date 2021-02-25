#!/usr/bin/perl -w
use strict;

use Device::SerialPort;
use Time::HiRes;

my $serPort = new Device::SerialPort("/dev/ttyACM0") || die "Could not open the port specified";

# Configure the port	   
$serPort->baudrate(19200);
$serPort->parity("none");
$serPort->databits(8);
$serPort->stopbits(1);
$serPort->handshake("none"); #Most important
$serPort->buffers(4096, 4096); 
$serPort->lookclear();
$serPort->are_match("\n"); # set up 'lookfor' to find EOL
$serPort->purge_all;
$serPort->write("\r"); # Initialize the prompt
$serPort->write_drain;

###########################################################################################
# Read and write subroutines
###########################################################################################	

sub readSerialLine() {
  my $gotit = "";
  until("" ne $gotit) { $gotit = $serPort->lookfor; Time::HiRes::usleep(50); }
  return $gotit;
}

sub sendCmd($) {
  $serPort->write("$_[0]\r");
  $serPort->write_drain;
  my $line = &readSerialLine();
  while(! ($line =~ m/>$_[0]/)) { $line = &readSerialLine(); }
}

sub readCmd($) { # Command that expects a response
  &sendCmd($_[0]);
  return &readSerialLine();
}

###########################################################################################
# Read all 7 ADC channels
###########################################################################################

&sendCmd("gpio iodir ffff");
my @avg = (0,0,0,0,0,0,0);
my $numSamp = 105;
for(my $i = 0; $i < $numSamp; $i++) {
  for(my $j = 0; $j < 7; $j++) { $avg[$j] += &readCmd("adc read $j"); }
}
print "Average:";
for(my $j = 0; $j < 7; $j++) { print " " . ($avg[$j] / $numSamp); }
print "\n";

