/*
License
-------
This code is published and shared by Numato Systems Pvt Ltd under GNU LGPL 
license with the hope that it may be useful. Read complete license at 
http://www.gnu.org/licenses/lgpl.html or write to Free Software Foundation,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA

Simplicity and understandability is the primary philosophy followed while
writing this code. Sometimes at the expence of standard coding practices and
best practices. It 
This demo code uses "java Simple Serial Connector" library from 
https://code.google.com/p/java-simple-serial-connector/. jSSC Documentation is 
available at https://code.google.com/p/java-simple-serial-connector/w/list
is your responsibility to independantly assess and implement
coding practices that will satisfy safety and security necessary for your final
application.

This demo code demonstrates how to turn a USB Relay Module's relay & IOs to on/off (logic high/low) state and 
demonstrates how to read an analog channel.

This demo code uses "java Simple Serial Connector" or "JSSC" library from 
https://code.google.com/p/java-simple-serial-connector/. jSSC Documentation is 
available at https://code.google.com/p/java-simple-serial-connector/w/list */

package usbrelay16demo;

import java.util.regex.Matcher; /* This instances are engines that interpret patterns and perform match operations against input strings. */
import java.util.regex.Pattern;    /* This instances are compiled representations of regular expressions. */
import jssc.SerialPort;  /* Calls the respective serial port */
import jssc.SerialPortException; /* initializes unmathced catagories as string */

public class UsbRelay16Demo {

    /**
     * @param args the command line arguments
    */
    public static void main(String[] args) {
        // TODO code application logic here
    if(args.length > 0){
            SerialPort port = new SerialPort(args[0]);            
            try {               
                /*Try to open port*/
                if(port.openPort() == true){
                    System.out.println("Port " + args[0] + " opened successfully...");
                }
                else{
                    System.exit(0);
                }
                /*Set flow control to None*/
                port.setFlowControlMode(SerialPort.FLOWCONTROL_NONE);
                
                /* USB Relay 16 Module firmware "version" - device ID get & set                        */
                /************************************************************************** 
                    Send a command to output a logic high at IOs0. The command that is 
                    used to accomplish this action is "ver, id get, id set, gpio set/clear/read 0-". It is important to send 
                    a Carriage Return character (ASCII value 0x0D) to emulate the ENTER 
                    key. The command will be executed only when the GPIO module detects 
                    Carriage Return character.
                **************************************************************************/

                /* Write a Carriage Return to make sure that any partial commands or junk
                   data left in the command buffer is cleared. This step is optional.
                */                   
              
                /* Write the command to port. Notice the Carriage Return (\r) at the end of the command */
                
                                               
                /* firmware version */
                port.writeString("\r");
                port.writeString("ver\r");
                System.out.println("Info: <ver> Command sent...");
                /* Display Response string */
                System.out.println(port.readString());
                Thread.sleep(100);
                /* Flush the Serial port's RX & TX buffer */
                port.purgePort(SerialPort.PURGE_RXCLEAR & SerialPort.PURGE_TXCLEAR);                
                
                
               
                /* ID Get & ID Set */
                port.writeString("\r");               
                port.writeString("id set 00000005\r");
                System.out.println("Info: <id set XXXXXXXX> Command sent...");
                Thread.sleep(100);
                /* Flush the Serial port's RX & TX buffer */
                port.purgePort(SerialPort.PURGE_RXCLEAR & SerialPort.PURGE_TXCLEAR);
                                                               
                port.writeString("\r");             
                port.writeString("id get\r");
                System.out.println("Info: <id get> Command sent...");
                /* Display Response string */
                System.out.println(port.readString());
                Thread.sleep(100);
                /* Flush the Serial port's RX & TX buffer */
                port.purgePort(SerialPort.PURGE_RXCLEAR & SerialPort.PURGE_TXCLEAR);
                
                         
                
                /* IO Set - Clear - Read */
                port.writeString("\r");                
                port.writeString("gpio set 1\r");
                System.out.println("Info: <gpio set X> Command sent...");
                Thread.sleep(100);
                /* Flush the Serial port's RX & TX buffer */
                port.purgePort(SerialPort.PURGE_RXCLEAR & SerialPort.PURGE_TXCLEAR);
                
                port.writeString("\r");               
                port.writeString("gpio clear 0\r");
                System.out.println("Info: <gpio clear X> Command sent...");
                Thread.sleep(100);
                /* Flush the Serial port's RX & TX buffer */
                port.purgePort(SerialPort.PURGE_RXCLEAR & SerialPort.PURGE_TXCLEAR);
                
                port.writeString("\r");              
                port.writeString("gpio read 0\r");
                System.out.println("Info: <gpio read X> Command sent...");
                /* Display Response string */
                System.out.println(port.readString());
                Thread.sleep(100);
                /* Flush the Serial port's RX & TX buffer */
                port.purgePort(SerialPort.PURGE_RXCLEAR & SerialPort.PURGE_TXCLEAR);
                               
                
                
                /***************************************************************************
                This section describes the way how to control the relay/relays on the board using 
                * on / off / read or reset statement. The execution process and usage of these code
                * in JavaScript is described below.
                * ***************************************************************************/
                
                /* Relay - on - off - read - reset  */
                port.writeString("\r");                
                port.writeString("relay on 1\r");
                System.out.println("Info: <relay on X> Command sent...");
                Thread.sleep(100);
                /* Flush the Serial port's RX & TX buffer*/
                port.purgePort(SerialPort.PURGE_RXCLEAR & SerialPort.PURGE_TXCLEAR);
                
                
                port.writeString("\r");               
                port.writeString("relay off 0\r");
                System.out.println("Info: <relay off X> Command sent...");
                Thread.sleep(100);
                /* Flush the Serial port's RX & TX buffer*/
                port.purgePort(SerialPort.PURGE_RXCLEAR & SerialPort.PURGE_TXCLEAR);
                
                port.writeString("\r");              
                port.writeString("relay read 3\r");
                System.out.println("Info: <relay read X> Command sent...");
                /* Display Response string */
                System.out.println(port.readString());
                Thread.sleep(100);
                /* Flush the Serial port's RX & TX buffer*/
                port.purgePort(SerialPort.PURGE_RXCLEAR & SerialPort.PURGE_TXCLEAR);
                
                port.writeString("\r");               
                port.writeString("reset\r");
                System.out.println("Info: <reset> Command sent...");
                Thread.sleep(100);
                /* Flush the Serial port's RX & TX buffer*/
                port.purgePort(SerialPort.PURGE_RXCLEAR & SerialPort.PURGE_TXCLEAR);
                
                
                port.writeString("\r");               
                port.writeString("relay writeall 0000\r");
                System.out.println("Info: <relay writeall XXXX> Command sent...");
                Thread.sleep(100);
                /* Flush the Serial port's RX & TX buffer*/
                port.purgePort(SerialPort.PURGE_RXCLEAR & SerialPort.PURGE_TXCLEAR);
                
                port.writeString("\r");              
                port.writeString("relay readall\r");
                System.out.println("Info: <relay readall> Command sent...");
                /* Display Response string */
                System.out.println(port.readString());
                Thread.sleep(100);
                /* Flush the Serial port's RX & TX buffer*/
                port.purgePort(SerialPort.PURGE_RXCLEAR & SerialPort.PURGE_TXCLEAR);
              
               
                /* ADC */
                /************************************************************************** 
                    Write "adc read X" command to the device and read back response. It is 
                    important to note that the device echoes every single character sent to
                    it and so when you read the response, the data that is read will 
                    include the command itself, a carriage return, the response which you 
                    are interested in, a '>' character and another carriage return. You 
                    will need to extract the response from this bunch of data. 
                /*************************************************************************/

                /* Write a Carriage Return to make sure that any partial commands or junk
                   data left in the command buffer is cleared. This step is optional.
                */
                port.writeString("\r");
                
                /* Flush the Serial port's RX or TX buffer*/
                Thread.sleep(100);
                port.purgePort(SerialPort.PURGE_RXCLEAR | SerialPort.PURGE_TXCLEAR);
                
                /* Write the command to port. Notice the Carriage Return (\r) at the end of the command */
             
                port.writeString("adc read 2\r");
                System.out.println("Info: <adc read X> Command sent...");
            
                
                /*Read back the response*/
                Thread.sleep(100);
                String response = port.readString();

                /*Extract the adc value from the response using regular expression. This can be done by using
                  various string operations as well.
                */
                Pattern rx = Pattern.compile("\r([0-9]*)");
                Matcher m = rx.matcher(response);
                
                if(m.find())
                {
                    System.out.println("Analog value read from ADC Channel 2 is ");
                    System.out.println(m.group(0).trim());
                }
                                            
                /* Flush the Serial port's RX & TX buffer*/
                port.purgePort(SerialPort.PURGE_RXCLEAR & SerialPort.PURGE_TXCLEAR);       
            }
            catch (SerialPortException|InterruptedException ex){
                System.out.println(ex);
            }
        }else{
            System.out.println("Usage: java UsbGpio8Demo <Com Port>\nEg: java UsbGpio8Demo COM1");
        }  
    }    
}
