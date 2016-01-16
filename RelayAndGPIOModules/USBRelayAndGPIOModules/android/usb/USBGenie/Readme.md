
###Numato Lab USBGenie

USBGenie is an Android app designed to demonstrate features and functionality of Numato Lab's USG GPIO and Relay Modules. Numato Lab has various USB products that implements USB CDC ACM protocol and shows up as a serial port on host devices. This allows for easier control of the device using easy to use Serial Port APIs on various platforms. Android provides a bunch of relatively easy to use APIs under android.hardware.usb package which can be used for discovering and communicating with SUB devices. USB CDC class is relatively easy to implement using the Android USB APIs.

More information about Numato Lab's USB GPIO and Relay modules can be found at http://numato.com . The table below shows some product images.

|  ![1 Channel USB Powered Relay Module](images/products/1ChannelUsbPoweredRelayModule.jpg?raw=true "1 Channel USB Powered Relay Module") |  ![2 Channel USB Solid State Relay Module](images/products/2ChannelUsbSolidStateRelayModule.jpg?raw=true "2 Channel USB Solid State Relay Module")  |  ![32 Channel USB GPIO Module With Analog Inputs](images/products/32ChannelUsbGpioModuleWithAnalogInputs.jpg?raw=true "32 Channel USB GPIO Module With Analog Inputs")  | ![32 Channel USB Relay Module](images/products/32ChannelUsbRelayModule.jpg?raw=true "32 Channel USB Relay Module")   | ![8 Channel USB GPIO Module With Analog Inputs](images/products/8ChannelUsbGpioModuleWithAnalogInputs.jpg?raw=true "8 Channel USB GPIO Module With Analog Inputs")  |
|---|---|---|---|---|

###How To Use USBGenie
USBGenie can be installed on a compatible Android device by
* Installing directly from Google Play [TBD]
* Or checking out the source code from this repository and use AndroidStudio to transfer the image to the device.

You will need a USB host cable (OTG cable) compatible with your Android device in order to connect a USB GPIO or Relay Device.

###Screenshots
|  ![USBGenie Home Screen](images/screenshots/home.png?raw=true "USBGenie Home Screen") |  ![Device Info Screen](images/screenshots/deviceinfo.png?raw=true "Device Info Screen")  |  ![GPIO Control and Ststus Screen](images/screenshots/gpio.png?raw=true "GPIO Control and Ststus Screen")  | ![Relay Control and Ststus Screen](images/screenshots/relay.png?raw=true "Relay Control and Ststus Screen")   | ![Analog Inputs Screen](images/screenshots/analog.png?raw=true "Analog Inputs Screen")  |
|---|---|---|---|---|

###The USB CDC Driver
This app uses a simple and minimal CDC driver to access the devices. The driver uses android.hardware.usb package to discover and access attached USB CDC devices. The driver provides six important methods.

* ListDevices() - Returns a list of currently attached CDC devices (static method)
* CdcAcmDriver() - Constructor to instantiate a driver instance
* GetDevice() - Returns a UsbDevice object associated with the current instance of the driver
* Write() - Writes to default write endpoint
* Read() - Reads from default read endpoint

###Readily supported devices
* [8 Channel USB GPIO Module With Analog Inputs](http://numato.com/8-channel-usb-gpio-module-with-analog-inputs/ "8 Channel USB GPIO Module With Analog Inputs")
* [16 Channel USB GPIO Module With Analog Inputs](http://numato.com/16-channel-usb-gpio-module-with-analog-inputs/ "16 Channel USB GPIO Module With Analog Inputs")
* [1 Channel USB Powered Relay Module](http://numato.com/1-channel-usb-powered-relay-module.html "1 Channel USB Powered Relay Module")

###Future improvements
* Implement asynchronous IO calls
* Move all IO calls to separate thread
* Add support for more devices

###License
Copyright 2015 Numato Systems Private Limited

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
