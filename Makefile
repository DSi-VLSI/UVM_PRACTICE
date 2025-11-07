# Set the shell to bash for all commands
.SHELL := /bin/bash

# Export environment variables for use in build scripts
export REPO_ROOT := ${CURDIR}
export BUILD_DIR := ${REPO_ROOT}/build
export LOG_DIR := ${REPO_ROOT}/logs

# Convert INTF variable to lowercase and remove spaces for file paths
intf = $(shell echo ${INTF} | tr '[:upper:]' '[:lower:]' | sed 's/ //g')

# Create build directory and add gitignore to exclude build artifacts
build:
	@mkdir -p ${BUILD_DIR}
	@echo "*" > ${BUILD_DIR}/.gitignore

# Create logs directory and add gitignore to exclude log files
logs:
	@mkdir -p ${LOG_DIR}
	@echo "*" > ${LOG_DIR}/.gitignore

# Build the design and testbench
${BUILD_DIR}/xsim.dir/${intf}_tb_top:
	@make -s clean
	@make -s build
	@make -s logs
	@if [ "${INTF}" != "APB" ] && [ "${INTF}" != "AXI" ]; then \
		echo "Error: Please specify interface type by setting INTF variable to APB or AXI"; exit 1; \
	fi
	@cd ${BUILD_DIR}; xvlog -sv -f ${REPO_ROOT}/flist/dut.f -d USE_${INTF}
	@cd ${BUILD_DIR}; xvlog -sv -f ${REPO_ROOT}/flist/${intf}.f
	@cd ${BUILD_DIR}; xelab ${intf}_tb_top -s ${intf}_tb_top -debug all

# Run the simulation with specified testbench
.PHONY: simulate
simulate: ${BUILD_DIR}/xsim.dir/${intf}_tb_top
	@make -s logs
	@cd ${BUILD_DIR}; xsim ${intf}_tb_top --runall

# Remove build directory and all build artifacts
.PHONY: clean
clean:
	@rm -rf ${BUILD_DIR}

# Remove both build and log directories
.PHONY: clean_full
clean_full: clean
	@rm -rf ${LOG_DIR}
