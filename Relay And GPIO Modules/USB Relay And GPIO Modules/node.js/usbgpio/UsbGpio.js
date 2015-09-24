// Numato Lab - http://numato.com
// This node.js sample script opens the port and sends two commands to the device. These commands 
// will turn on GPIO0, wait for 2 seconds and then turn off. The response received from the device
// is printed to the console unparsed.
// Please follow the steps below to test the script.
//
// 1. Download and install Node.js from https://nodejs.org/download/
// 2. Run command "npm install serialport" at the command prompt to install serial port library
// 3. Attach the gpio device to the PC and note the port identifier corresponding to the device
// 4. Update the line below that starts with "var port =" with the port name for your device
// 5. Run the script by entering the command "node UsbGpio" at the command prompt

var SerialPort = require("serialport").SerialPort
var port = "com4";

var portObj = new SerialPort(port,{
  baudrate: 19200
}, false);

portObj.on('data', function(data){
	console.log('Data Returned by the device');
	console.log('--------------------');
    console.log(String(data));
	console.log('--------------------');
});

portObj.open(function (error){
  if ( error ) {
		console.log('Failed to open port: ' + error);
  } else {
		console.log('Writing command gpio set 0 to port');
		portObj.write("gpio set 0\r", function(err, results){
			if(error){
				console.log('Failed to write to port: '+ error);
			}
		});
		
		console.log('Waiting for two seconds');
		setTimeout(
			function(){
				console.log('Writing command gpio clear 0 to port');
				portObj.write("gpio clear 0\r", function(err, results){
					if(error){
						console.log('Failed to write to port: '+ error);
					}
				});
				
				setTimeout( function(){process.exit(code=0);}, 1000);
			}
		,2000);
  }
});