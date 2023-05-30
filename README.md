# glitchGenerator
<img align="right" src="/doc/SDS00001.png">
Really a fancy pulse generator specialized to generating glitch pulses with 
a theoretical resolution down to 5_ns but in practice I'm seeing 14_ns (see
below), it's wrong but it's consistently wrong. I got tired of knocking up
variations of the same thing in the SCIF so I'm trying to work up a generic.

## Purpose
Generate glitch pulses of at specific time after a trigger and for a specific 
duration. By pulling Vcpp (sometimes called Vcpu) low (typically using a 
MOSFET) at the right time for the right duration (a bit of a black art) one 
can cause instructions to be seemingly skipped (in practice the wrong 
operation is performed). This is most useful for SOCs with onboard flash where 
the goal to to dump said flash.
## Background
Yosys is fast, consequently one can just alter the Verilog and re-synthesize. 
This is the incept in a series of glitch generators:
#### glitchGenerator (this repo)
This version requires re-synthesis every time you want to changing timing 
parameters. It is a one-shot; that is, it generates one glitch pulse a 
specified time after trigger.
#### UARTconfiguredGlitchGenerator (another repo)
My goal is to get this to the point where one can set values via UART and skip 
the re-synthesis. The goal here is to send a series of delays, and gwidths; 
thus, after trigger it waits out the first delay, delay<sub>1</sub>, and then 
sends a glitch pulse of duration gwidth<sub>1</sub>, then it waits out the 
(optional) second delay, delay<sub>2</sub> and then sends a glitch pulse of 
duiration gwidth<sub>2</sub> and so on.   
delay<sub>1</sub> gwidth<sub>1</sub> delay<sub>2</sub> gwidth<sub>2</sub> ... 
delay<sub>n</sub> gwidth<sub>n</sub>   
eg:```1000000000 65 1000000 60 10000 60``` means wait 1_s, generate a 65_ns 
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
#### MOSFETs
Things like chipwhisperer use these, and refer to them as a crowbar.   
<div>
 
<figure style="width: 40%">
  <img alt="Datasheet" src="/doc/IRF7807.png" style="width: 30%">
  <figcaption>
   <a href="https://www.infineon.com/dgdl/irf7807zpbf.pdf?fileId=5546d462533600a401535608622e1ce8" target="_blank"/>IRF7807ZTR</a>
 </figcaption>
</figure>


 <figure style="width: 40%">
  <img alt="Datasheet" src="/doc/IRLML2502.png" style="width: 30%">
  <figcaption>
   <a href="https://www.infineon.com/dgdl/Infineon-IRLML2502-DataSheet-v01_01-EN.pdf?fileId=5546d462533600a401535668048e2606" target="_blank"/>IRLML2502</a>
 </figcaption>
</figure>
</div>
 
IRF7807ZTR   [https://www.infineon.com/dgdl/irf7807zpbf.pdf?fileId=5546d462533600a401535608622e1ce8]   
IRLML2502    [https://www.infineon.com/dgdl/Infineon-IRLML2502-DataSheet-v01_01-EN.pdf?fileId=5546d462533600a401535668048e2606]  
## Caveat
I want the timers (glitch one-shot and the delay) to be precise (that's why
I'm using an FPGA); therefore, I'm using the FPGA's PLL. Unfortunately this 
means I have to use a primitive that ties me to a specific FPGA. I'll start 
with an IceStick (Lattice ICE40HX1K), then maybe an Altera (Intel) Cyclone4,
and expand from there.
## Problems
I'm still trying to sort out some timing issues, it's off by about 14_ns, 
not really sure why. I had the PLL running at 300_MHz but that proved 
unreliable. This is good enough for the MCUs I'm borking with (150_MHz or so).
![1_us off by 14_us](/doc/1usOutBy14ns.png)
![5_us off by 14_ns](/doc/5usOutBy14ns.png)
 
 
