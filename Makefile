.SHELL := /bin/bash

export REPO_ROOT := $(shell pwd)

BUILD_DIR := ${REPO_ROOT}/build

build:
	@mkdir -p ${BUILD_DIR}

.PHONY: compile
compile: clean build
	@cd ${BUILD_DIR}; xvlog -sv -i ${REPO_ROOT}/include -f ${REPO_ROOT}/flist/dut -d USE_AXI
	@cd ${BUILD_DIR}; xelab uart_top -s uart_top -debug all

.PHONY: clean
clean:
	@rm -rf ${BUILD_DIR}
