EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:special
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:saturn-cache
EELAYER 27 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 4 6
Title "SATURN SPARTAN6 FPGA MODULE"
Date "15 apr 2014"
Rev ""
Comp "Numato Lab"
Comment1 "http://www.numato.com"
Comment2 "License: CC BY-SA"
Comment3 ""
Comment4 ""
$EndDescr
Text Label 3700 4150 0    60   ~ 0
DDR1V8
Text Label 3850 3200 0    60   ~ 0
DDR-D0
Text Label 3850 3100 0    60   ~ 0
DDR-D1
Text Label 3850 3000 0    60   ~ 0
DDR-D2
Text Label 3850 2900 0    60   ~ 0
DDR-D3
Text Label 3850 2800 0    60   ~ 0
DDR-D4
Text Label 3850 2700 0    60   ~ 0
DDR-D5
Text Label 3850 2600 0    60   ~ 0
DDR-D6
Text Label 3850 2500 0    60   ~ 0
DDR-D7
Text Label 3850 2300 0    60   ~ 0
DDR-D9
Text Label 3850 2200 0    60   ~ 0
DDR-D10
Text Label 3850 2100 0    60   ~ 0
DDR-D11
Text Label 3850 2000 0    60   ~ 0
DDR-D12
Text Label 3850 1900 0    60   ~ 0
DDR-D13
Text Label 3850 1800 0    60   ~ 0
DDR-D14
Text Label 3850 1700 0    60   ~ 0
DDR-D15
Text Label 3850 2400 0    60   ~ 0
DDR-D8
Text Label 7150 1900 2    60   ~ 0
DDR-A12
Text Label 7150 2000 2    60   ~ 0
DDR-A11
Text Label 7150 2100 2    60   ~ 0
DDR-A10
Text Label 7150 2200 2    60   ~ 0
DDR-A9
Text Label 7150 2300 2    60   ~ 0
DDR-A8
Text Label 7150 2400 2    60   ~ 0
DDR-A7
Text Label 7150 2500 2    60   ~ 0
DDR-A6
Text Label 7150 2600 2    60   ~ 0
DDR-A5
Text Label 7150 2700 2    60   ~ 0
DDR-A4
Text Label 7150 2800 2    60   ~ 0
DDR-A3
Text Label 7150 2900 2    60   ~ 0
DDR-A2
Text Label 7150 3000 2    60   ~ 0
DDR-A1
Text Label 7150 3100 2    60   ~ 0
DDR-A0
$Comp
L R R27
U 1 1 51C1D7BC
P 7450 4350
F 0 "R27" V 7530 4350 40  0000 C CNN
F 1 "100R" V 7457 4351 40  0000 C CNN
F 2 "~" V 7380 4350 30  0000 C CNN
F 3 "~" H 7450 4350 30  0000 C CNN
	1    7450 4350
	0    -1   -1   0   
$EndComp
Text HLabel 3350 1500 0    60   BiDi ~ 0
DDR-D[0..15]
Text HLabel 7700 1850 2    60   Input ~ 0
DDR-A[0..12]
Text HLabel 6550 3650 2    60   BiDi ~ 0
DDR-UDQS
Text HLabel 6550 3750 2    60   BiDi ~ 0
DDR-LDQS
Text HLabel 6550 4700 2    60   Input ~ 0
DDR-UDM
Text HLabel 6550 4800 2    60   Input ~ 0
DDR-LDM
Text HLabel 8100 3850 2    60   Input ~ 0
DDR-CK_P
Text HLabel 8100 3950 2    60   Input ~ 0
DDR-CK_N
Text HLabel 8100 4050 2    60   Input ~ 0
DDR-CKE
Text HLabel 6550 4150 2    60   Input ~ 0
DDR-WE
Text HLabel 6550 4250 2    60   Input ~ 0
DDR-CAS
Text HLabel 6550 4350 2    60   Input ~ 0
DDR-RAS
Text HLabel 6550 4600 2    60   Input ~ 0
DDR-BA0
$Comp
L C C76
U 1 1 51C1EADB
P 3550 6700
F 0 "C76" H 3550 6800 40  0000 L CNN
F 1 "0.1uF" H 3556 6615 40  0000 L CNN
F 2 "~" H 3588 6550 30  0000 C CNN
F 3 "~" H 3550 6700 60  0000 C CNN
	1    3550 6700
	1    0    0    -1  
$EndComp
$Comp
L C C77
U 1 1 51C1EAE1
P 3850 6700
F 0 "C77" H 3850 6800 40  0000 L CNN
F 1 "0.1uF" H 3856 6615 40  0000 L CNN
F 2 "~" H 3888 6550 30  0000 C CNN
F 3 "~" H 3850 6700 60  0000 C CNN
	1    3850 6700
	1    0    0    -1  
$EndComp
$Comp
L C C78
U 1 1 51C1EAE7
P 4150 6700
F 0 "C78" H 4150 6800 40  0000 L CNN
F 1 "0.1uF" H 4156 6615 40  0000 L CNN
F 2 "~" H 4188 6550 30  0000 C CNN
F 3 "~" H 4150 6700 60  0000 C CNN
	1    4150 6700
	1    0    0    -1  
$EndComp
$Comp
L C C79
U 1 1 51C1EAED
P 4400 6700
F 0 "C79" H 4400 6800 40  0000 L CNN
F 1 "0.1uF" H 4406 6615 40  0000 L CNN
F 2 "~" H 4438 6550 30  0000 C CNN
F 3 "~" H 4400 6700 60  0000 C CNN
	1    4400 6700
	1    0    0    -1  
$EndComp
$Comp
L C C80
U 1 1 51C1EAF3
P 4650 6700
F 0 "C80" H 4650 6800 40  0000 L CNN
F 1 "0.1uF" H 4656 6615 40  0000 L CNN
F 2 "~" H 4688 6550 30  0000 C CNN
F 3 "~" H 4650 6700 60  0000 C CNN
	1    4650 6700
	1    0    0    -1  
$EndComp
$Comp
L C C81
U 1 1 51C1EAF9
P 4900 6700
F 0 "C81" H 4900 6800 40  0000 L CNN
F 1 "0.1uF" H 4906 6615 40  0000 L CNN
F 2 "~" H 4938 6550 30  0000 C CNN
F 3 "~" H 4900 6700 60  0000 C CNN
	1    4900 6700
	1    0    0    -1  
$EndComp
$Comp
L C C82
U 1 1 51C1EAFF
P 5150 6700
F 0 "C82" H 5150 6800 40  0000 L CNN
F 1 "0.1uF" H 5156 6615 40  0000 L CNN
F 2 "~" H 5188 6550 30  0000 C CNN
F 3 "~" H 5150 6700 60  0000 C CNN
	1    5150 6700
	1    0    0    -1  
$EndComp
Text Label 3050 6900 0    60   ~ 0
GND
Entry Wire Line
	3750 3100 3850 3200
Entry Wire Line
	3750 1600 3850 1700
Entry Wire Line
	3750 1700 3850 1800
Entry Wire Line
	3750 1800 3850 1900
Entry Wire Line
	3750 1900 3850 2000
Entry Wire Line
	3750 2000 3850 2100
Entry Wire Line
	3750 2100 3850 2200
Entry Wire Line
	3750 2200 3850 2300
Entry Wire Line
	3750 2300 3850 2400
Entry Wire Line
	3750 2400 3850 2500
Entry Wire Line
	3750 2500 3850 2600
Entry Wire Line
	3750 2600 3850 2700
Entry Wire Line
	3750 2700 3850 2800
Entry Wire Line
	3750 2800 3850 2900
Entry Wire Line
	3750 2900 3850 3000
Entry Wire Line
	3750 3000 3850 3100
Text Label 3400 1500 0    60   ~ 0
DDR-D[0..15]
Entry Wire Line
	7150 3100 7250 3200
Entry Wire Line
	7150 3000 7250 3100
Entry Wire Line
	7150 2900 7250 3000
Entry Wire Line
	7150 2800 7250 2900
Entry Wire Line
	7150 2700 7250 2800
Entry Wire Line
	7150 2600 7250 2700
Entry Wire Line
	7150 2500 7250 2600
Entry Wire Line
	7150 2400 7250 2500
Entry Wire Line
	7150 2300 7250 2400
Entry Wire Line
	7150 2200 7250 2300
Entry Wire Line
	7150 2100 7250 2200
Entry Wire Line
	7150 2000 7250 2100
Entry Wire Line
	7150 1900 7250 2000
Text HLabel 6550 4500 2    60   Input ~ 0
DDR-BA1
Text GLabel 2800 6500 0    60   Input ~ 0
DDR1V8
NoConn ~ 6550 1800
$Comp
L MT47H32M16LF U9
U 1 1 51F1160D
P 5400 3100
F 0 "U9" H 5450 3700 60  0000 C CNN
F 1 "MT46H32M16LF" H 5400 4700 60  0000 C CNN
F 2 "~" H 5400 3100 60  0000 C CNN
F 3 "~" H 5400 3100 60  0000 C CNN
	1    5400 3100
	1    0    0    -1  
$EndComp
Text GLabel 3900 5000 0    39   Input ~ 0
GND
Text Label 3900 5000 0    39   ~ 0
GND
Text Label 6750 5000 2    39   ~ 0
GND
$Comp
L R R26
U 1 1 51F11EA4
P 6900 5150
F 0 "R26" V 6980 5150 40  0000 C CNN
F 1 "100R" V 6907 5151 40  0000 C CNN
F 2 "~" V 6830 5150 30  0000 C CNN
F 3 "~" H 6900 5150 30  0000 C CNN
	1    6900 5150
	-1   0    0    1   
$EndComp
Text Label 6750 5450 0    39   ~ 0
GND
$Comp
L R R28
U 1 1 51F12971
P 7900 3450
F 0 "R28" V 7980 3450 40  0000 C CNN
F 1 "4.7K" V 7907 3451 40  0000 C CNN
F 2 "~" V 7830 3450 30  0000 C CNN
F 3 "~" H 7900 3450 30  0000 C CNN
	1    7900 3450
	-1   0    0    1   
$EndComp
Text Label 8100 3150 2    39   ~ 0
GND
Text Label 2800 6500 0    60   ~ 0
DDR1V8
$Comp
L R R29
U 1 1 51F7B076
P 2900 5950
F 0 "R29" V 2980 5950 40  0000 C CNN
F 1 "100R" V 2907 5951 40  0000 C CNN
F 2 "~" V 2830 5950 30  0000 C CNN
F 3 "~" H 2900 5950 30  0000 C CNN
	1    2900 5950
	0    1    1    0   
$EndComp
Text HLabel 2550 5950 0    39   BiDi ~ 0
RZQ
Text Label 3350 5950 2    39   ~ 0
GND
Wire Wire Line
	3850 3200 4250 3200
Wire Wire Line
	3850 3100 4250 3100
Wire Wire Line
	3850 3000 4250 3000
Wire Wire Line
	3850 2900 4250 2900
Wire Wire Line
	3850 2800 4250 2800
Wire Wire Line
	3850 2700 4250 2700
Wire Wire Line
	3850 2600 4250 2600
Wire Wire Line
	3850 2500 4250 2500
Wire Wire Line
	3850 2400 4250 2400
Wire Wire Line
	3850 2300 4250 2300
Wire Wire Line
	3850 2200 4250 2200
Wire Wire Line
	3850 2100 4250 2100
Wire Wire Line
	3850 2000 4250 2000
Wire Wire Line
	3850 1900 4250 1900
Wire Wire Line
	3850 1800 4250 1800
Wire Wire Line
	3850 1700 4250 1700
Wire Wire Line
	2800 6500 5150 6500
Connection ~ 3550 6500
Connection ~ 3850 6500
Connection ~ 4150 6500
Connection ~ 4400 6500
Connection ~ 4650 6500
Connection ~ 4900 6500
Connection ~ 4900 6900
Connection ~ 4650 6900
Connection ~ 4400 6900
Connection ~ 4150 6900
Connection ~ 3850 6900
Connection ~ 3550 6900
Wire Bus Line
	3750 1500 3750 3200
Wire Bus Line
	3750 1500 3350 1500
Wire Bus Line
	7250 1850 7250 3250
Wire Bus Line
	7250 1850 7700 1850
Wire Wire Line
	4250 3450 4150 3450
Wire Wire Line
	4150 3450 4150 4150
Wire Wire Line
	3700 4150 4250 4150
Connection ~ 4150 4150
Wire Wire Line
	4250 4050 4150 4050
Connection ~ 4150 4050
Wire Wire Line
	4250 3950 4150 3950
Connection ~ 4150 3950
Wire Wire Line
	4250 3550 4150 3550
Connection ~ 4150 3550
Wire Wire Line
	4250 3750 4150 3750
Connection ~ 4150 3750
Wire Wire Line
	4250 3850 4150 3850
Connection ~ 4150 3850
Wire Wire Line
	4250 4350 4150 4350
Wire Wire Line
	4150 4350 4150 5000
Wire Wire Line
	3900 5000 4250 5000
Wire Wire Line
	4250 4900 4150 4900
Connection ~ 4150 4900
Wire Wire Line
	4250 4800 4150 4800
Connection ~ 4150 4800
Wire Wire Line
	4250 4650 4150 4650
Connection ~ 4150 4650
Wire Wire Line
	4250 4550 4150 4550
Connection ~ 4150 4550
Wire Wire Line
	4250 4450 4150 4450
Connection ~ 4150 4450
Connection ~ 4150 5000
Wire Wire Line
	6550 5000 6750 5000
Wire Wire Line
	6550 4900 6900 4900
Wire Wire Line
	6900 5400 6900 5450
Wire Wire Line
	6900 5450 6750 5450
Wire Wire Line
	6550 1900 7150 1900
Wire Wire Line
	6550 2000 7150 2000
Wire Wire Line
	6550 2100 7150 2100
Wire Wire Line
	6550 2200 7150 2200
Wire Wire Line
	6550 2300 7150 2300
Wire Wire Line
	6550 2400 7150 2400
Wire Wire Line
	6550 2500 7150 2500
Wire Wire Line
	6550 2600 7150 2600
Wire Wire Line
	6550 2700 7150 2700
Wire Wire Line
	6550 2800 7150 2800
Wire Wire Line
	6550 2900 7150 2900
Wire Wire Line
	6550 3000 7150 3000
Wire Wire Line
	6550 3100 7150 3100
Wire Wire Line
	6550 4050 8100 4050
Wire Wire Line
	6550 3950 8100 3950
Wire Wire Line
	6550 3850 8100 3850
Wire Wire Line
	7200 4350 7150 4350
Wire Wire Line
	7150 4350 7150 3850
Connection ~ 7150 3850
Wire Wire Line
	7750 3950 7750 4350
Wire Wire Line
	7750 4350 7700 4350
Connection ~ 7750 3950
Wire Wire Line
	7900 4050 7900 3700
Connection ~ 7900 4050
Wire Wire Line
	7900 3200 7900 3150
Wire Wire Line
	7900 3150 8100 3150
Wire Wire Line
	2650 5950 2550 5950
Wire Wire Line
	3150 5950 3350 5950
Wire Wire Line
	3050 6900 5150 6900
Connection ~ 3250 6900
Connection ~ 3250 6500
$Comp
L C C75
U 1 1 51C1EAD5
P 3250 6700
F 0 "C75" H 3250 6800 40  0000 L CNN
F 1 "0.1uF" H 3256 6615 40  0000 L CNN
F 2 "~" H 3288 6550 30  0000 C CNN
F 3 "~" H 3250 6700 60  0000 C CNN
	1    3250 6700
	1    0    0    -1  
$EndComp
Wire Wire Line
	4250 3650 4150 3650
Connection ~ 4150 3650
$EndSCHEMATC
