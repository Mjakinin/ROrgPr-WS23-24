#RUN := -all
#LIB := work
#VSIM := vsim -novopt
#VCOM := vcom
VMAP := RorgPrSimLib:../../../tools/ROrgPrSimLib
REMOTE_DIR := ~/.RorgPrRemote/

export PATH := ../../../tools/:$(PATH)

COMPILE  := proc_config.vhd flashROM.vhd flashRAM.vhd mipsISA.vhd leftShifter.vhd signExtend.vhd adder_1bit.vhd alu_1bit.vhd aluCtrl.vhd mipsAlu.vhd mipsCtrl.vhd addrDecoder.vhd reg.vhd regFile.vhd bin2Char.vhd mipsCpu.vhd mipsCpu_ref.vhd mipsCpu_tb.vhd
SIMULATE := mipsCpu_tb

all: ghdl

GHDLWORKDIR := ghdl-work
GHDLPARAM := --std=08 -fsynopsys -frelaxed --workdir=$(GHDLWORKDIR)
GHDLDEPS := $(foreach FILE,$(COMPILE),$(GHDLWORKDIR)/$(basename $(FILE)).o)

ghdl: $(GHDLWORKDIR)/$(SIMULATE)
	ln -fs $(GHDLWORKDIR)/$(SIMULATE).ghw    waveform.ghw
	ln -fs $(GHDLWORKDIR)/$(SIMULATE).out    transcript

$(GHDLWORKDIR)/$(SIMULATE): | $(GHDLWORKDIR)/e~$(SIMULATE).o

modelsim: vsim/$(SIMULATE)
	ln -fs vsim/$(SIMULATE).vcd.gz waveform.vcd.gz
	ln -fs vsim/$(SIMULATE)        transcript

vsim/$(SIMULATE): | $(foreach FILE,$(COMPILE),vcom/$(FILE))
vcom/%.vhd: $(wildcard %.vhd)

.PHONY:
view_wave:
	@if [ "${DISPLAY}" = "" ]; then \
		echo "Keine grafische Oberfläche gefunden"; \
		exit 1; \
	fi
	@if [ -f "waveform.ghw" ]; then \
		gtkwave -mtranscript waveform.ghw >/dev/null 2>&1 & \
	elif [ -f "waveform.vcd.gz" ]; then \
		gtkwave -mtranscript waveform.vcd.gz >/dev/null 2>&1 & \
	else \
		echo "Keine Waveform gefunden"; \
		exit 1; \
	fi
	
-include ../../../tools/modelsim.mk
-include ../../../tools/remote.mk
-include ../../../tools/ghdl.mk

