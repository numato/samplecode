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

public class Analog {

    NumatoUSBDevice device;


    int number;

    public Analog(NumatoUSBDevice device, int number){
        this.device = device;
        this.number = number;
    }

    public int getAnalog(){
        String cmdRelayRead = "adc read " + Integer.toString(this.number) + "\r";
        byte[] responseBuffer = new byte[64];
        int tmp = 0;

        tmp = device.sendAndReceive(cmdRelayRead.getBytes(), cmdRelayRead.length(), responseBuffer, 32);

        if(tmp < 14){
            return 0;
        }else{
            String response = new String(responseBuffer).substring(12,16);
            response = response.replaceAll("[^\\d]", "");
            return Integer.parseInt(response);
        }
    }

    public int getNumber() {
        return number;
    }
}
