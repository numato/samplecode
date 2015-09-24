License
-------
This code is published and shared by Numato Systems Pvt Ltd under GNU GPL 
license with the hope that it may be useful. Read complete license at 
http://www.gnu.org/licenses/gpl.html or write to Free Software Foundation,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA

Simplicity and understandability is the primary philosophy followed while
writing this code. Sometimes at the expence of standard coding practices and
best practices. It is your responsibility to independantly assess and implement
coding practices that will satisfy safety and security necessary for your final
application.

This Python script will download a binary file to the SPI flash available on 
Elbert V2 Spartan 3A FPGA developemnt board.

Prerequisites:
 python 3.x
 pySerial (pySerial 2.7 or newer works with Python 3.x)
 Write access to tty device corresponds to Elbert V2 (or do sudo / login as root)

This program is made available to the public AS IS with no warranites. This 
program is tested on the platforms listed below. But it may or may not work 
on your specific platform. 

This program is tested on the following platforms 
 1. Windows 8, Python 3.3, pySerial 2.7
 2. Ubuntu 14.04, Python 3.4, pySerial 2.7

Usage : python elbertconfig.py <PORT> <Binary File>
Example (Windows) : python elbertconfig.py /dev/ttyACM0 elbertv2.bin
Example (Ubuntun 14.04) : python3 elbertconfig.py COM3 elbertv2.bin