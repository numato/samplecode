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

import android.hardware.usb.UsbManager;

/**
 * Helper class to mock the @see {@link NumatoUSBDevice} <br>
 * Created by becze on 10/12/2015.
 */
public class NumatoDevicesHelper {

    // ------------------------------------------------------------------------
    // TYPES
    // ------------------------------------------------------------------------


    private static class Holder {
        static final NumatoDevicesHelper INSTANCE = new NumatoDevicesHelper();
    }


    // ------------------------------------------------------------------------
    // STATIC FIELDS
    // ------------------------------------------------------------------------

    public static final int DEFAULT_NUMBER_OF_MOCKED_DEVICES = 5;
    public static final int DEFAULT_PORT = 5000;

    // ------------------------------------------------------------------------
    // STATIC METHODS
    // ------------------------------------------------------------------------
    public static NumatoDevicesHelper getInstance() {
        return Holder.INSTANCE;
    }


    // ------------------------------------------------------------------------
    // FIELDS
    // ------------------------------------------------------------------------


    // ------------------------------------------------------------------------
    // CONSTRUCTORS
    // ------------------------------------------------------------------------

    private NumatoDevicesHelper() {
    }

    // ------------------------------------------------------------------------
    // METHODS
    // ------------------------------------------------------------------------


    // ------------------------------------------------------------------------
    // GETTERS / SETTTERS
    // ------------------------------------------------------------------------
}
