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

package com.numato.usbgenie.drivers.UsbSerial;

import android.hardware.usb.UsbDevice;
import android.hardware.usb.UsbDeviceConnection;
import android.hardware.usb.UsbEndpoint;
import android.hardware.usb.UsbInterface;
import android.hardware.usb.UsbManager;
import android.util.Log;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;

/**
 * Created by numato on 10/29/2015.
 * A very minimal bare bones CDC driver implementation
 * !!Important!! This driver uses blocking USB calls. Although blocking call are much easier to
 * implement, they are not recommended for production quality software due to potential performance
 * problems. Also these call are currently executed from UI thread which is yet another thing to
 * avoid. For a demo application, the current implementation should suffice but it is strongly
 * recommended that you use asynchronous IO and separate thread for USB operations for your
 * production app.
 */

public class CdcAcmDriver {

    public static final int USB_CLASS_CDC = 0x02;
    public static final int USB_SUBCLASS_RESERVED = 0x00;
    public static final int USB_SUBCLASS_ACM = 0x02;

    private UsbManager usbManager;
    private UsbDevice Device;
    private UsbDeviceConnection connection;

    private UsbInterface controlIf;
    private UsbInterface dataIf;

    private UsbEndpoint controlEp;
    private UsbEndpoint dataReadEp;
    private UsbEndpoint dataWriteEp;

    private boolean isPortOpen;
    private int timeOut;

    /*
     * This static method build a list of currently available CDC USB devices.
     */
    public static ArrayList<UsbDevice> ListDevices(UsbManager manager){
        ArrayList<UsbDevice> drivers = new ArrayList<UsbDevice>();

        HashMap<String, UsbDevice> map = manager.getDeviceList();
        Iterator<UsbDevice> iterator = map.values().iterator();

        while(iterator.hasNext()){
            UsbDevice device = iterator.next();
            if(device.getDeviceClass() == USB_SUBCLASS_RESERVED || device.getDeviceClass() == USB_SUBCLASS_ACM) {
                drivers.add(device);
            }
            iterator.remove();
        }

        return drivers;
    }

    /*
     * Constructor.
     */
    public CdcAcmDriver(UsbDevice device, UsbManager manager){
        usbManager = manager;
        Device = device;
        timeOut = 500;
    }

    /*
     * Returns UsbDevice associated with the current instance of the driver.
     */
    public UsbDevice getDevice(){
        return Device;
    }

    /*
     * Opens a USB device for communication.
     */
    public boolean open() throws IOException {

        if (!isPortOpen) {
            connection = usbManager.openDevice(Device);
            if (connection == null) {
                isPortOpen = false;
                return false;
            }

            try {
                /*Claim Interfaces*/
                controlIf = Device.getInterface(0);
                if (!connection.claimInterface(controlIf, true)) {
                    throw new IOException("Unable to claim Control Interface");
                }

                dataIf = Device.getInterface(1);
                if (!connection.claimInterface(dataIf, true)) {
                    throw new IOException("Unable to claim Data Interface");
                }

                /*get Endpoints*/
                controlEp = controlIf.getEndpoint(0);
                dataWriteEp = dataIf.getEndpoint(0);
                dataReadEp = dataIf.getEndpoint(1);

                isPortOpen = true;
            } catch (IOException ex) {
                isPortOpen = false;
            } finally {
                if (isPortOpen == false) {
                    connection.close();
                    connection = null;
                }
            }
        }

        return isPortOpen;
    }

    /*
     * Closes a USb device.
     */
    public void close() {

        if(connection != null){
            connection.close();
            connection = null;
        }

        isPortOpen = false;
    }

    /*
     * Writes contents of buffer to the device.
     */
    public int write(byte[] buffer) throws IOException{
        int remaining = buffer.length;

        if(isPortOpen == false){
            open();
            isPortOpen = true;
        }

        while(remaining > 0){
            int bytesWritten = connection.bulkTransfer(dataWriteEp, Arrays.copyOfRange(buffer, buffer.length - remaining, remaining), remaining, timeOut);

            if(bytesWritten <= 0){
                throw(new IOException("Zero bytes written to the endpoint"));
            }

            remaining = bytesWritten < remaining ? remaining - bytesWritten : 0;
        }

        //not really useful, need to find a better way
        return buffer.length;
    }

    /*
     * Reads available data from the device.
     */
    public int read(byte[] buffer, int length) throws IOException{
        int remaining = length;

        if(isPortOpen == false){
            open();
            isPortOpen = true;
        }

        int bytesRead = connection.bulkTransfer(dataReadEp, buffer, length, timeOut);

        if(bytesRead > 0) {
            //Log.d("Numato", "Read " + new String(buffer));
        }

        return bytesRead;
    }

    /*
     * Get current timeout value in milliSeconds.
     */
    public int getTimeOut() {
        return timeOut;
    }

    /*
     * Set timeout value in milliSeconds.
     */
    public void setTimeOut(int timeOut) {
        this.timeOut = timeOut;
    }
}
