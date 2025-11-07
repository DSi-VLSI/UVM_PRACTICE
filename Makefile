.SHELL := /bin/bash

export REPO_ROOT := $(CURDIR)
export BUILD_DIR := ${REPO_ROOT}/build
export LOG_DIR := ${REPO_ROOT}/logs

intf = $(shell echo ${INTF} | tr '[:upper:]' '[:lower:]' | sed 's/ //g')

build:
	@mkdir -p ${BUILD_DIR}
	@echo "*" > ${BUILD_DIR}/.gitignore

logs:
	@mkdir -p ${LOG_DIR}
	@echo "*" > ${LOG_DIR}/.gitignore

.PHONY: compile
compile: clean build logs
	@if [ "${INTF}" != "APB" ] && [ "${INTF}" != "AXI" ]; then \
		echo "Error: Please specify interface type by setting INTF variable to APB or AXI"; \
		exit 1; \
	fi
	@cd ${BUILD_DIR}; xvlog -sv -f ${REPO_ROOT}/flist/dut.f -d USE_${INTF}
#	@cd ${BUILD_DIR}; xvlog -sv -f ${REPO_ROOT}/flist/${intf}.f
	@cd ${BUILD_DIR}; xelab uart_top -s uart_top -debug all

.PHONY: clean
clean:
	@rm -rf ${BUILD_DIR}

.PHONY: clean_full
clean_full: clean
	@rm -rf ${LOG_DIR}
