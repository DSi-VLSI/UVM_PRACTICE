

SHELL := /bin/bash

export REPO_ROOT := $(abspath $(CURDIR)/../../)


# CONFIGURATION

FILELIST   			?= filelist.f
RTL_FILELIST_PATH 	:= $(abspath $(CURDIR)/../../flist/dut.f)
TOP        			?= tb_top
SIM_NAME   			?= sim_snapshot        # Simulation snapshot name
WDB_FILE   			?= wave.wdb            # Waveform database
TESTNAME   			?=                      
VERBOSITY  			?= UVM_LOW              


XVLOG = xvlog --sv
XELAB = xelab
XSIM  = xsim


# Targets

all: clean compile elaborate simulate clean


compile:
	$(XVLOG) -f "$(RTL_FILELIST_PATH)" -f "$(FILELIST)" -L uvm


elaborate:
	$(XELAB) $(TOP) -L uvm -s $(SIM_NAME)


simulate:
ifeq ($(strip $(TESTNAME)),)
	# Run simulation without test plusargs
	$(XSIM) $(SIM_NAME) -R -wdb $(WDB_FILE)
else
	# Run simulation with test and verbosity using --testplusarg
	$(XSIM) $(SIM_NAME) -R -wdb $(WDB_FILE) --testplusarg "UVM_TESTNAME=$(TESTNAME)" --testplusarg "UVM_VERBOSITY=$(VERBOSITY)"
endif


clean:
	rm -rf .Xil *.log *.jou *.wdb $(SIM_NAME) *.vcd *.dir *.pb *.covdb

.PHONY: all compile elaborate simulate clean
