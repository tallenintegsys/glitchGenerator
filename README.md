# glitchGenerator
Really a fancy pulse generator specialized to generating glitch pulses
## Purpose
Generate glitch pulses of at specific time after a trigger and for a specific 
duration. By pulling Vcpp (sometimes called Vcap) low (typically using a 
MOSFET) at the right time for the right duration (a bit of a black art) one 
can cause instructions to be seemingly skipped (in practice the wrong 
operation is performed). This is most useful for SOCs with onboard flash where 
the goal to to dump said flash.
## Background
Yosys is fast, consequently one can just alter the Verilog and re-synthesize. 
This is the incept in a series of glitch generators:
#### parameterizedGlitchGenerator (this repo)
This version requires re-synthesys everytime you want to changing timing 
parameters. It is a one-shot; that is, it generates one glitch pulse a 
specified time after trigger.
#### UARTconfiguredGlitchGenerator
My goal is to get this to the point where one can set values via UART and skip 
the re-synthesis. The goal here is to send a series of delays, and gwidths; 
thus, after trigger it waits out the first delay, delay<sub>1</sub>, and then 
sends a glitch pulse of duration gwidth<sub>1</sub>, then it waits out the 
(optional) second delay, delay<sub>2</sub> and then sends a glitch pulse of 
duiration gwidth<sub>2</sub> and so on.   
delay<sub>1</sub> gwidth<sub>1</sub> delay<sub>2</sub> gwidth<sub>2</sub> ... 
delay<sub>n</sub> gwidth<sub>n</sub>   
eg:```1000000000 65 1000000 60 10000 60``` means wait 1_s, generaate a 65_ns 
glitch pulse, wait 100_&mu;s, generate a glitch pulse of 60_ns and finally 
wait 10_&mu;s, generate a glitch pulse of 60_ns. Currently the resolution 
is about 5_ns. (204_MHz clock I'm still borking with the PLL)    

Some day I hope the obviate the need for an external UART (integrate the 
USB/UART into the FPGA); for now let's see if I can work out a UI.
## Usage
Connect your UART dongle to the FPGA. Use the following to access the (albeit 
text based) UI.   
`$screen /dev/ttyUSBn 115200`  
TRIG: starts the timer, when the timer elapses a pulse of the specified 
duration is generated.
TX: UART transmit
RX: UART receive
GLITCH: pulse out
GLITCHn: inverted pulse out
## Caveat
I want the timers (glitch one-shot and the delay) to be precise (that's why I'm using an FPGA); therefore, I'm using the FPGA's PLL. Unfortunately this means I have to use a primitive that ties me to a specific FPGA. I'll start with an Icestick (Lattice ICE40HX1K), then maybe an Altera (Intel) Cyclone4, and expand from there. 
