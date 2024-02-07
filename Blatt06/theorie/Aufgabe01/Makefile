#RUN := -all
#LIB := work
#VSIM := vsim -novopt
#VCOM := vcom
VMAP := RorgPrSimLib:../../../tools/ROrgPrSimLib
REMOTE_DIR := ~/.RorgPrRemote/

export PATH := ../../../tools/:$(PATH)

COMPILE  := fulladd.vhd adder.vhd
SIMULATE := adder

all: ghdl

GHDLWORKDIR := ghdl-work
GHDLPARAM := --std=08 -fsynopsys -frelaxed --workdir=$(GHDLWORKDIR)
GHDLDEPS := $(foreach FILE,$(COMPILE),$(GHDLWORKDIR)/$(basename $(FILE)).o)

ghdl: | $(GHDLWORKDIR)/e~$(SIMULATE).o
	@echo
	@echo ALLES ERFOLGREICH KOMPILIERT
	@echo

modelsim: $(foreach FILE,$(COMPILE),vcom/$(FILE))
	@echo
	@echo ALLES ERFOLGREICH KOMPILIERT
	@echo

vcom/%.vhd: $(wildcard %.vhd)
	
-include ../../../tools/modelsim.mk
-include ../../../tools/remote.mk
-include ../../../tools/ghdl.mk
