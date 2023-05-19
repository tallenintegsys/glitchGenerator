
PROJ = glitchGen
PCF = icestick.pcf
DEVICE = 1k

all: ${PROJ}.bin

%.bin: %.asc
	icepack $< $@

%.asc: %.json
	nextpnr-ice40 --hx1k --package tq144 --json $< --pcf $(PCF) --asc $@

%.json: verilog/glitchGen_top.v
	yosys -p "read_verilog $<; synth_ice40 -flatten -json $@"

.PHONY: prog

prog:
	iceprog ${PROJ}.bin
