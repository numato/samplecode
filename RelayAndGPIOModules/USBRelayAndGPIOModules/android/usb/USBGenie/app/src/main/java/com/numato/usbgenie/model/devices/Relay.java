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


public class Relay {

    private NumatoUSBDevice device;

    private int number;

    public Relay(NumatoUSBDevice device, int number){
        this.device = device;
        this.number = number;
    }

    public boolean getState(){
        String cmdRelayRead = "relay read " + Integer.toString(this.number) + "\r";
        byte[] responseBuffer = new byte[64];
        int tmp = 0;

        tmp = device.sendAndReceive(cmdRelayRead.getBytes(), cmdRelayRead.length(), responseBuffer, 32);

        if(tmp < 15){
            return false;
        }else{
            String response = new String(responseBuffer);
            if(response.contains("on")){
                return true;
            }else
            {
                return false;
            }
        }
    }

    public void setState(boolean state) {
        String cmdRelayState;

        if(state == true){
            cmdRelayState = "relay on " + this.number + "\r";
        }else{
            cmdRelayState = "relay off " + this.number + "\r";
        }

        device.sendAndReceive(cmdRelayState.getBytes(), cmdRelayState.length(), null, 0);
    }

    public int getNumber() {
        return number;
    }
}
