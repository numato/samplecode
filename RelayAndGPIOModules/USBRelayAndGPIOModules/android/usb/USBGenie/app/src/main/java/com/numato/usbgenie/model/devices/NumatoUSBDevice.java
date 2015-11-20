/*
Copyright [2015] [Numato Systems Private Limited]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package com.numato.usbgenie.model.devices;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;

import android.hardware.usb.UsbDevice;
import android.hardware.usb.UsbDeviceConnection;
import android.hardware.usb.UsbEndpoint;
import android.hardware.usb.UsbInterface;
import android.hardware.usb.UsbManager;
import android.support.annotation.NonNull;
import android.util.Log;

import com.numato.usbgenie.drivers.UsbSerial.CdcAcmDriver;

public class NumatoUSBDevice {

    public static final int VID_NUMATOLAB = 0x2A19;

    /*Populate new devices here. Search for ADD_NEW_DEVICE to find other places where changes needed*/
    /* USB GPIO Devices */
    public static final int PID_USBGPIO8 = 0x0800;
    public static final int PID_USBGPIO16 = 0x0801;
    public static final int PID_USBGPIO32 = 0x0802;

    /* USB Relay Devices */
    public static final int PID_USBRELAY2 = 0x0C00;
    public static final int PID_USBRELAY4 = 0x0C01;
    public static final int PID_USBRELAY8 = 0x0C02;
    public static final int PID_USBRELAY16 = 0x0C03;
    public static final int PID_USBRELAY32 = 0x0C04;
    public static final int PID_USBPOWEREDRELAY1 = 0x0C05;
    public static final int PID_USBPOWEREDRELAY2 = 0x0C06;
    public static final int PID_USBPOWEREDRELAY4 = 0x0C07;
    public static final int PID_USBSSR1 = 0x0C0A;
    public static final int PID_USBSSR2 = 0x0C0B;
    public static final int PID_USBSSR4 = 0x0C0C;
    public static final int PID_USBSSR8 = 0x0C0D;

    private String name;
    private int index;
    private int numberOfGpios;
    private int numberOfRelays;
    private int numberOfAnalogInputs;
    private boolean isPortOpen;

    private CdcAcmDriver driver;

    public ArrayList<Relay> mRelays = new ArrayList<Relay>();
    public ArrayList<Gpio> mGpios = new ArrayList<Gpio>();
    public ArrayList<Analog> mAnalogs = new ArrayList<Analog>();

    public NumatoUSBDevice() {
    }

    public NumatoUSBDevice(int index, UsbDevice device, UsbManager usbManager) {
        this.index = index;
        this.isPortOpen = false;

        driver = new CdcAcmDriver(device, usbManager);

        /*Populate new devices here. Search for ADD_NEW_DEVICE to find other places where changes needed*/
        switch (driver.getDevice().getProductId()) {

            case PID_USBGPIO8:
                this.name = "8 Channel USB GPIO With Analog Inputs";
                this.numberOfRelays = 0;
                this.numberOfGpios = 8;
                this.numberOfAnalogInputs = 6;
                break;

            case PID_USBGPIO16:
                this.name = "16 Channel USB GPIO With Analog Inputs";
                this.numberOfRelays = 0;
                this.numberOfGpios = 16;
                this.numberOfAnalogInputs = 7;
                break;

            case NumatoUSBDevice.PID_USBPOWEREDRELAY1:
                this.name = "1 Channel USB Powered Relay Module";
                this.numberOfRelays = 1;
                this.numberOfGpios = 4;
                this.numberOfAnalogInputs = 4;
                break;

            default:
                this.name = "Unknown Device";
                this.numberOfGpios = 0;
                this.numberOfRelays = 0;
                this.numberOfAnalogInputs = 0;
        }

        //Populate Relay objects for this device
        for (int i = 0; i < this.numberOfRelays; i++) {
            mRelays.add(i, new Relay(this, i));
        }

        //Populate Gpio objects for this device
        for (int i = 0; i < this.numberOfGpios; i++) {
            mGpios.add(i, new Gpio(this, i));
        }

        //Populate Analog objects for this device
        for (int i = 0; i < this.numberOfAnalogInputs; i++) {
            mAnalogs.add(i, new Analog(this, i));
        }
    }

    public static final ArrayList<Integer> GetSupportedProductIds(){
        ArrayList<Integer> supportedDevices = new ArrayList<Integer>();

        /*Populate new devices here. Search for ADD_NEW_DEVICE to find other places where changes needed*/
        supportedDevices.add(NumatoUSBDevice.PID_USBGPIO8);
        supportedDevices.add(NumatoUSBDevice.PID_USBGPIO16);
        supportedDevices.add(NumatoUSBDevice.PID_USBPOWEREDRELAY1);


        return supportedDevices;
    }

    public String getName() {
        return name;
    }

    public int getIndex() {
        return index;
    }

    public int getProductId() {
        return driver.getDevice().getProductId();
    }

    public int getNumberOfGpios() {
        return numberOfGpios;
    }

    public int getNumberOfRelays() {
        return numberOfRelays;
    }

    public int getNumberOfAnalogInputs() {
        return numberOfAnalogInputs;
    }

    public UsbDevice getDevice() {
        return driver.getDevice();
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setIndex(int index) {
        this.index = index;
    }

    public void setNumberOfGpios(int numberOfGpios) {
        this.numberOfGpios = numberOfGpios;
    }

    public void setNumberOfRelays(int numberOfRelays) {
        this.numberOfRelays = numberOfRelays;
    }

    public void setNumberOfAnalogInputs(int numberOfAnalogInputs) {
        this.numberOfAnalogInputs = numberOfAnalogInputs;
    }

    //This function return a number that either denotes the number of bytes received or the status
    //of operation. The exact situation depends on the value of receiveLen passed to the function.
    // receiveLen == 0
    //      Return value 0 indicates failure
    //      Return value !=0 indicates success
    // receiveLen > 0
    //      Return value 0 indicates number of bytes received

    public int sendAndReceive(byte sendBuffer[], int sendLen, byte ReceiveBuffer[], int receiveLen) {

        boolean operationSucceeded = true;
        int numBytesReceived = 0;

        try {
            driver.write(sendBuffer);
        }catch(IOException ex){
            Log.d("Numato", "Exception while trying to write to port");
            return 0;
        }

        try {
            numBytesReceived = driver.read(ReceiveBuffer, receiveLen);
        }catch(IOException ex){
            Log.d("Numato", ex.getMessage());
            return 0;
        }

        return numBytesReceived;
    }

    public String getFirmwareVersion() {
        String cmdVer = "ver\r";
        byte[] responseBuffer = new byte[64];
        int tmp = 0;

        tmp = sendAndReceive(cmdVer.getBytes(), cmdVer.length(), responseBuffer, 32);
        if (tmp < 12) {
            return null;
        } else {
            return new String(responseBuffer).substring(5, 13);
        }
    }

    public String getDeviceSpecificId() {
        String cmdIdGet = "id get\r";
        byte[] responseBuffer = new byte[64];
        int tmp = 0;

        tmp = sendAndReceive(cmdIdGet.getBytes(), cmdIdGet.length(), responseBuffer, 32);
        if (tmp < 15) {
            return null;
        } else {
            return new String(responseBuffer).substring(8, 16);
        }
    }

    public void setDeviceSpecificId(String id) {
        String cmdSetId = "id set " + id + "\r";
        sendAndReceive(cmdSetId.getBytes(), cmdSetId.length(), null, 0);
    }

    public void close(){
        driver.close();
    }

}
