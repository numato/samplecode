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

import java.util.ArrayList;
import java.util.List;

/**
 * Created by becze on 10/26/2015.
 */
public class DevicesManager {




    // ------------------------------------------------------------------------
    // TYPES
    // ------------------------------------------------------------------------\

    private static class Holder {
        static final DevicesManager INSTANCE = new DevicesManager();
    }


    // ------------------------------------------------------------------------
    // STATIC FIELDS
    // ------------------------------------------------------------------------

    // ------------------------------------------------------------------------
    // STATIC METHODS
    // ------------------------------------------------------------------------
    public static DevicesManager getInstance() {
        return Holder.INSTANCE;
    }

    // ------------------------------------------------------------------------
    // FIELDS
    // ------------------------------------------------------------------------

    /**
     * Devices list
     */
    private List<NumatoUSBDevice> mDeviceArray;

    // ------------------------------------------------------------------------
    // CONSTRUCTORS
    // ------------------------------------------------------------------------

    private DevicesManager() {
        mDeviceArray = new ArrayList<NumatoUSBDevice>();
    }

    // ------------------------------------------------------------------------
    // METHODS
    // ------------------------------------------------------------------------


    // ------------------------------------------------------------------------
    // GETTERS / SETTTERS
    // ------------------------------------------------------------------------


    /**
     * @return the list of devices which are present.
     */
    public List<NumatoUSBDevice> getDevices() {
        return mDeviceArray;
    }

    public void setDevices(List<NumatoUSBDevice> deviceArray) {
        mDeviceArray = deviceArray;
    }

    public void clearDevices() {
        mDeviceArray.clear();
    }

    public void addDevice(NumatoUSBDevice numatoUSBDevice) {
        mDeviceArray.add(numatoUSBDevice);
    }

    public void addDevices(List<NumatoUSBDevice> devices) {
        mDeviceArray.addAll(devices);
    }


    /**
     * Returns the device with the given index
     * @param currentDeviceIndex
     * @return
     */
    public NumatoUSBDevice get(int currentDeviceIndex) {
        return mDeviceArray.get(currentDeviceIndex);
    }
}
