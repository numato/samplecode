package usbgpio16demo;

import java.util.regex.Matcher; /* This instances are engines that interpret patterns and perform match operations against input strings. */
import java.util.regex.Pattern;    /* This instances are compiled representations of regular expressions. */
import jssc.SerialPort;  /* Calls the respective serial port */
import jssc.SerialPortException; /* initializes unmathced catagories as string */

public class UsbGpio16Demo {

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
                
              
                 /* GPIO16 module firmware version - device ID get & set                 */
                /************************************************************************** 
                    Send a command to output a logic high/low/read status at GPIO 0 to 7. The command that is 
                    used to accomplish this action is "gpio set/clear/read 0-7". It is important to send 
                    a Carriage Return character (ASCII value 0x0D) to emulate the ENTER 
                    key. The command will be executed only when the GPIO module detects 
                    Carriage Return character.
                **************************************************************************/

                /* Write a Carriage Return to make sure that any partial commands or junk
                   data left in the command buffer is cleared. This step is optional.
                */                   
              
                /* Write the command to port. Notice the Carriage Return (\r) at the end of the command */
                
                
                /* firmware "version" */
                port.writeString("\r");
                port.writeString("ver\r");
                System.out.println("Info: <ver> Command sent...");
                /* Display Response string */
                System.out.println(port.readString());
                Thread.sleep(100);
                /* Flush the Serial port's RX & TX buffer. */
                port.purgePort(SerialPort.PURGE_RXCLEAR & SerialPort.PURGE_TXCLEAR);                
                
                
               
                /*ID Get & ID Set */
                port.writeString("\r");               
                port.writeString("id set 00000001\r");
                System.out.println("Info: <id set XXXXXXXX> Command sent...");
                Thread.sleep(100);
                /* Flush the Serial port's RX & TX buffer. */
                port.purgePort(SerialPort.PURGE_RXCLEAR & SerialPort.PURGE_TXCLEAR);
                                                               
                port.writeString("\r");             
                port.writeString("id get\r");
                System.out.println("Info: <id get> Command sent...");
                /* Display Response string */
                System.out.println(port.readString());
                Thread.sleep(100);
                /* Flush the Serial port's RX & TX buffer. */
                port.purgePort(SerialPort.PURGE_RXCLEAR & SerialPort.PURGE_TXCLEAR);
                
               
                /* GPIO16 General Commands                   */
                /************************************************************************** 
                    Send a command to output a logic high/low/read status at GPIO 0 to 7. The command that is 
                    used to accomplish this action is "gpio set/clear/read 0-7". It is important to send 
                    a Carriage Return character (ASCII value 0x0D) to emulate the ENTER 
                    key. The command will be executed only when the GPIO module detects 
                    Carriage Return character.
                **************************************************************************/

                /* Write a Carriage Return to make sure that any partial commands or junk
                   data left in the command buffer is cleared. This step is optional.
                */                   
              
                /* Write the command to port. Notice the Carriage Return (\r) at the end of the command */          
                
                /*IO Set - Clear - Read */
                port.writeString("\r");                
                port.writeString("gpio set 1\r");
                System.out.println("Info: <gpio set XX> Command sent...");
                Thread.sleep(100);
                /* Flush the Serial port's RX & TX buffer. */
                port.purgePort(SerialPort.PURGE_RXCLEAR & SerialPort.PURGE_TXCLEAR);
                
                port.writeString("\r");               
                port.writeString("gpio clear 0\r");
                System.out.println("Info: <gpio clear XX> Command sent...");
                Thread.sleep(100);
                /* Flush the Serial port's RX & TX buffer. */
                port.purgePort(SerialPort.PURGE_RXCLEAR & SerialPort.PURGE_TXCLEAR);
                
                port.writeString("\r");              
                port.writeString("gpio read 0\r");
                System.out.println("Info: <gpio read XX> Command sent...");
                /* Display Response string */
                System.out.println(port.readString());
                Thread.sleep(100);
                /* Flush the Serial port's RX & TX buffer. */
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
                
                /* Flush the Serial port's RX or TX buffer. */
                Thread.sleep(100);
                port.purgePort(SerialPort.PURGE_RXCLEAR | SerialPort.PURGE_TXCLEAR);
                
                /* Write the command to port. Notice the Carriage Return (\r) at the end of the command */
             
                port.writeString("adc read 2\r");
                System.out.println("Info: <adc read XX> Command sent...");
            
                
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
                
                 /* GPIO16 group Commands                   */
                /*********************************************************************************************************** 
                    Send a command to output a logic iodir - iomask - writeall - readall at GPIO 0 to f. The command that is 
                    used to accomplish this action is "gpio iodir/iomask/readall/writeall". It is important to send 
                    a Carriage Return character (ASCII value 0x0D) to emulate the ENTER 
                    key. The command will be executed only when the GPIO module detects 
                    Carriage Return character.
                *************************************************************************************************************/

                /* Write a Carriage Return to make sure that any partial commands or junk
                   data left in the command buffer is cleared. This step is optional.
                */                   
              
                /* Write the command to port. Notice the Carriage Return (\r) at the end of the command */
                
                /* GPIO16 IOdir - IOmask - Writeall - Readall */
                port.writeString("\r");               
                port.writeString("gpio iodir 0000\r");
                System.out.println("Info: <gpio iodir XXXX> Command sent...");
                Thread.sleep(100);
                /*Flush the Serial port's RX & TX buffer. */
                port.purgePort(SerialPort.PURGE_RXCLEAR & SerialPort.PURGE_TXCLEAR);
                                
                port.writeString("\r");                
                port.writeString("gpio imask ffff\r");
                System.out.println("Info: <gpio iomask XXXX> Command sent...");
                Thread.sleep(100);
                /*Flush the Serial port's RX & TX buffer. */
                port.purgePort(SerialPort.PURGE_RXCLEAR & SerialPort.PURGE_TXCLEAR);
                
                 port.writeString("\r");                
                port.writeString("gpio writeall ffff\r");
                System.out.println("Info: <gpio writeall XXXX> Command sent...");
                Thread.sleep(100);
                /*Flush the Serial port's RX & TX buffer. */
                port.purgePort(SerialPort.PURGE_RXCLEAR & SerialPort.PURGE_TXCLEAR);
                                
                port.writeString("\r");              
                port.writeString("gpio readall\r");
                System.out.println("Info: <gpio readall> Command sent...");
                /*Display Response string */
                System.out.println(port.readString());
                Thread.sleep(1000);
                
                /*Flush the Serial port's RX & TX buffer. */
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
