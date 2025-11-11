##########################################################
# Makefile for APB UART UVM Simulation (Vivado XSIM)
##########################################################

SHELL := /bin/bash
export REPO_ROOT := $(abspath $(CURDIR)/../../)

# ------------------- CONFIGURATION ---------------------
FILELIST      ?= $(abspath $(CURDIR)/../../flist/apb_tb.f)
RTL_FILELIST  := $(abspath $(CURDIR)/../../flist/dut.f)
TOP           ?= apb_tb_top
SIM_NAME      ?= sim_snapshot
WDB_FILE      ?= wave.wdb
TESTNAME      ?=
VERBOSITY     ?= UVM_LOW
MODE          ?= cli            # Options: cli (runall) or gui

# ------------------- TOOLS -----------------------------
XVLOG = xvlog --sv
XELAB = xelab
XSIM  = xsim

# ------------------- TARGETS ---------------------------
.PHONY: all compile elaborate simulate gui clean

all: clean compile elaborate simulate

# Compile design + testbench
compile:
	$(XVLOG) -f "$(RTL_FILELIST)" -f "$(FILELIST)" -L uvm -d USE_APB

# Elaborate top-level module
elaborate:
	$(XELAB) $(TOP) -L uvm -s $(SIM_NAME)

# Run simulation in CLI or GUI mode
simulate:
ifeq ($(MODE),gui)
	$(XSIM) $(SIM_NAME) -gui -wdb $(WDB_FILE) \
		$(if $(TESTNAME),--testplusarg "UVM_TESTNAME=$(TESTNAME)") \
		$(if $(TESTNAME),--testplusarg "UVM_VERBOSITY=$(VERBOSITY)")
else
	$(XSIM) $(SIM_NAME) -R -wdb $(WDB_FILE) \
		$(if $(TESTNAME),--testplusarg "UVM_TESTNAME=$(TESTNAME)") \
		$(if $(TESTNAME),--testplusarg "UVM_VERBOSITY=$(VERBOSITY)")
endif

# Shortcut target for GUI only
gui:
	make MODE=gui all

# Clean all build artifacts
clean:
	rm -rf .Xil *.log *.jou *.wdb $(SIM_NAME) *.vcd *.dir *.pb *.covdb
