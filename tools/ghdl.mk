export LD_LIBRARY_PATH := $(LD_LIBRARY_PATH):/usr/lib/x86_64-linux-gnu:/afs/tu-berlin.de/units/Fak_IV/aes/tools/ghdl/gnat/lib64:/afs/tu-berlin.de/units/Fak_IV/aes/tools/ghdl/gnat/lib:/afs/tu-berlin.de/units/Fak_IV/aes/tools/ghdl/ghdl/lib
export PATH := $(PATH):/afs/tu-berlin.de/units/Fak_IV/aes/tools/ghdl/gnat/bin:/afs/tu-berlin.de/units/Fak_IV/aes/tools/ghdl/ghdl/bin

SIMLIBPATH := ../../../tools/ROrgPrSimLib++/
SIMLIBPARAM := -P$(SIMLIBPATH)
SIMLIBARCH = $(shell uname -m)
SIMLIBNAME := libROrgPrSimLib-$(SIMLIBARCH).so
SIMLIBLINKPARAM := -Wl,$(SIMLIBPATH)/$(SIMLIBNAME)

.PHONY:
clean: clean_ghdl
	rm -f waveform.vcd.gz
	rm -f waveform.ghw
	rm -f transcript

ghdlcheck: precompile

precompile:
	@echo ===============================
	@echo Building ROrgPrSimLib.
	@echo Errors here are most likely never your fault.
	@echo Please report them in the ISIS forum or directly to rorgpr@aes.tu-berlin.de.
	cd $(SIMLIBPATH) && ./prepare.sh
	@echo Finished building ROrgPrSimLib.
	@echo ===============================

$(GHDLWORKDIR):
	mkdir -p $(GHDLWORKDIR)

$(GHDLWORKDIR)/%.o: %.vhd | $(GHDLWORKDIR)
	ghdl -a $(GHDLPARAM) $(SIMLIBPARAM) $< 2>&1

$(GHDLWORKDIR)/e~%.o: | $(GHDLDEPS)
	ghdl -e $(GHDLPARAM) $(SIMLIBPARAM) $(SIMLIBLINKPARAM) -o $(GHDLWORKDIR)/$* $* 2>&1

$(GHDLWORKDIR)/%: | ghdlcheck $(GHDLWORKDIR)/e~%.o
	@echo ===============================
	@echo Start of test.
	LD_LIBRARY_PATH="$(LD_LIBRARY_PATH):$(SIMLIBPATH)" ./$@ --wave=$(GHDLWORKDIR)/$*.ghw 2>&1 | tee $(GHDLWORKDIR)/$*.out
	@echo End of test.
	@echo ===============================

.PHONY:
clean_ghdl:
	-rm -rf $(GHDLWORKDIR)/
