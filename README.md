# glitchGenerator
Really a fancy pulse generator specialized to generating glitch pulses
## Purpose
Generate glitch pulses of at specific time after a trigger and for a specific duration. By pulling Vcpp (sometimes called Vcap) low (typically using a MOSFET) at the right time for the right duration (a bit of a black art) one can cause instructions to be seemingly skipped (in practice the wrong operation is performed). This is most useful for SOCs with onboard flash where the goal to to dump said flash.
## Background
Yosys is fast, consequently one can just alter the Verilog and re-synthesize. My goal is to get this to the point where one can set values via UART and skip the re-synthesis. Some day I hope the obviate the need for an external UART (integrate the USB/UART into the FPGA); for now let's see if I can work out a UI, but that gives rise to a dependancy on **hwterminal** which builds on **usb_annunciator(a module in usbTim)**.
## Usage
Connect your UART dongle to the FPGA. Use the following to access the (albeit text based) UI.   
`$screen /dev/ttyUSBn 115200`  
TRIG: starts the timer, when the timer elapses a pulse of the specified duration is generated.
TX: UART transmit
RX: UART receive
GLITCH: pulse out
GLITCHn: inverted pulse out
## Caveat
I want the timers (glitch one-shot and the delay) to be precise (that's why I'm using an FPGA); therefore, I'm using the FPGA's PLL. Unfortunately this means I have to use a primitive that ties me to a specific FPGA. I'll start with an Icestick (Lattice ICE40HX1K), then maybe an Altera (Intel) Cyclone4, and expand from there. 
