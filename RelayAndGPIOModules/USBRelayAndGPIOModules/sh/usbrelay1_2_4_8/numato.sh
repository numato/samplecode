#!/bin/sh
#
# This code is published and shared under GNU LGPL
# license with the hope that it may be useful. Read complete license at
# http://www.gnu.org/licenses/lgpl.html or write to Free Software Foundation,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA
#
# Simplicity and understandability is the primary philosophy followed while
# writing this code. Sometimes at the expense of standard coding practices and
# best practices. It is your responsibility to independantly assess and implement
# coding practices that will satisfy safety and security necessary for your final
# application.
#
# This demo code demonstrates how to turn on/off a relay
#

VID=2a19
PID=0c05

help() {
	echo "Usage: numato.sh <relay number> <on|off>"
	echo example: ./numato.sh 0 on
	exit 1
}

# find tty relating to given pid and vid
# return after first tty device found
findtty() {
	local TTY=
	local idVendor=$1
	local idProduct=$2
	local usb_devs="$(grep -l $idVendor /sys/bus/usb/devices/*/idVendor)"

	for usbdev in $usb_devs
	do
		usbdev=$(dirname $usbdev)
		if [ "$(cat $usbdev/idProduct)" = "$idProduct" ]
		then
			TTY=/dev/$(basename $usbdev/*1.0/tty/*)
			[ -n $TTY ] && echo $TTY && return
		fi
	done
}

ret=1
response='\n'
file="/tmp/numato.$$"

[ "$1" = "" ] && help
num=$1

[ "$2" = "" ] && help
cmd=$2

case "$cmd" in
on) cmd=on ;;
off) cmd=off ;;
*) help ;; 
esac

TTY=$(findtty $VID $PID)
[ -z "$TTY" ] && echo "Could not find TTY" && exit 1

stty -F $TTY 19200 -echo -echoe -echok -opost -icanon -inlcr
chat -V -t 1 "" "relay ${cmd} ${num}\r\n" "$response" < "$TTY" > "$TTY" 2> $file

[ -s $file ] && ret=0
rm -rf $file

if [ $ret = 0 ]; then
	echo "Powered relay ${num} ${cmd}"
else
	echo "Failed to set relay ${num} ${cmd}"
fi

exit $ret

