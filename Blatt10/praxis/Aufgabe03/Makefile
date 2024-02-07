#RUN := -all
#LIB := work
#VSIM := vsim -novopt
#VCOM := vcom
VMAP := RorgPrSimLib:../../../tools/ROrgPrSimLib
REMOTE_DIR := ~/.RorgPrRemote/

export PATH := ../../../tools/:$(PATH)

COMPILE  := proc_config.vhd flashRAM.vhd mipsISA.vhd leftShifter.vhd signExtend.vhd adder_1bit.vhd alu_1bit.vhd aluCtrlExt.vhd mipsAlu.vhd mipsCtrlFsm.vhd addrDecoder.vhd reg.vhd regFile.vhd bin2Char.vhd mipsCpu_mc.vhd mipsCpu_mc_ref.vhd mipsCpu_mc_tb.vhd
SIMULATE := mipsCpu_mc_tb
PROGRAM  := program.c

OBJDUMP  := ../../../tools/ROrgPrLLVM/llvm-objdump
OBJCOPY  := ../../../tools/ROrgPrLLVM/llvm-objcopy
CC       := ../../../tools/ROrgPrLLVM/clang-16
LD       := ../../../tools/ROrgPrLLVM/ld.lld

all: ghdl

GHDLWORKDIR := ghdl-work
GHDLPARAM := --std=08 -fsynopsys -frelaxed --workdir=$(GHDLWORKDIR)
GHDLDEPS := $(foreach FILE,$(COMPILE),$(GHDLWORKDIR)/$(basename $(FILE)).o)

ghdl: $(GHDLWORKDIR)/$(SIMULATE)
	ln -fs $(GHDLWORKDIR)/$(SIMULATE).ghw    waveform.ghw
	ln -fs $(GHDLWORKDIR)/$(SIMULATE).out    transcript

%.mif: $(GHDLWORKDIR)/%.pad.bin %.objdump
	od $< -t x4 -w4 -v -An --endian=little | sed 's/^ //' > $@

.PRECIOUS: %.objdump
.PHONY: %.objdump
%.objdump: $(GHDLWORKDIR)/%.out
	$(OBJDUMP) -S -x $< > $@

$(GHDLWORKDIR)/%.pad.bin: $(GHDLWORKDIR)/%.bin proc_config.vhd
	$(eval TMP := $(shell grep -E "constant NUM_RAM_ELEMENTS : integer := [[:digit:]]+;" proc_config.vhd | sed 's/\tconstant NUM_RAM_ELEMENTS : integer := \([[:digit:]]*\);/\1/'))
	$(eval TMP := $(shell echo $$(( $(TMP) * 4 )) ))
	dd if=/dev/zero of=$@ bs=1 count=$(TMP)
	dd if=$< of=$@ conv=notrunc

$(GHDLWORKDIR)/%.bin: $(GHDLWORKDIR)/%.out
	$(OBJCOPY) $< -O binary $@

$(GHDLWORKDIR)/%.out: $(GHDLWORKDIR)/%.o linker.ld
	$(LD) $< -Tlinker.ld -o $@

$(GHDLWORKDIR)/%.o: %
	mkdir -p $(GHDLWORKDIR)
	$(CC) -c -ffreestanding -nostdlib --target=mipsel-none-eabi -O0 -fno-stack-protector $< -o $@

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

