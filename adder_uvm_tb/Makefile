# Set the default goal to 'help' if no target is specified
.DEFAULT_GOAL := help

# Define the root directory of the project
ROOT_DIR := $(shell realpath .)

# Define the source directory
SRC := $(ROOT_DIR)/source

# Default test name, can be overridden from the command line
test_name ?= base_test

# Find all directories under simulation and add them as include paths (-i)
FLIST += $(shell find $(SRC)/simulation -type d -name "*" | sed "s/^/-i /g")
# Find all SystemVerilog files in the design directory
FLIST += $(shell find $(SRC)/design -type f -name "*.sv")
# Add the top-level testbench file
FLIST += $(SRC)/simulation/tb_adder_top.sv

# Target to create the build directory
build:
	@echo "Creating build directory"
	@mkdir -p build
	@echo "*" > build/.gitignore

# Target to create the log directory
log:
	@echo "Creating log directory"
	@mkdir -p log
	@echo "*" > log/.gitignore

# Target to compile and elaborate the design using Xilinx tools
build/xsim.dir/tb_adder_top/xsimk.exe:
	@echo "Building tb_adder_top"
	# Compile SystemVerilog files using xvlog, including UVM library and logging compile output
	@cd build; xvlog -sv $(FLIST) -L uvm -log ../log/compile.log
	# Elaborate the top-level module and create a snapshot, logging elaboration output
	@cd build; xelab tb_adder_top -s tb_adder_top -log ../log/elaborate.log

# Target to simulate the design
.PHONY: simulate
simulate: build log build/xsim.dir/tb_adder_top/xsimk.exe
	# Write the test_name as a plusarg to a file for xsim to read
	@echo "--testplusarg test_name=$(test_name)" > build/test_name.txt
	# Run the simulation using xsim, logging simulation output and passing the test_name file
	@cd build; xsim tb_adder_top -log ../log/simulate_$(test_name).log -runall -f test_name.txt

# Target to clean the build directory
.PHONY: clean
clean:
	@echo "Cleaning build directory"
	@rm -rf build
	@echo "Removed build directory"

# Target to clean both build and log directories
.PHONY: clean_full
clean_full:
	@make -s clean
	@echo "Cleaning log directory"
	@rm -rf log
	@echo "Removed log directory"

# Target to clean and then simulate the default test
.PHONY: fresh
fresh: clean simulate

# Target to display help message
.PHONY: help
help:
	@echo "Makefile commands:"
	@echo "  make help                        - Print this help message (default)."
	@echo "  make simulate [test_name=<test>] - Simulate the design. Default test is 'base_test'."
	@echo "  make all                         - Clean and run all tests ('base_test', 'simple_test')."
	@echo "  make fresh                       - Clean and simulate the default test."
	@echo "  make clean                       - Clean the build directory."
	@echo "  make clean_full                  - Clean both build and log directories."

# Target to run all specified tests after a full clean
.PHONY: all
all:
	@make -s clean_full
	@make -s simulate test_name=simple_test
	@make -s simulate test_name=v_simple_test
