ROOT_D   := ${shell realpath .}
SRC      := ${ROOT_D}/src
INC      := ${ROOT_D}/include
INF      := ${ROOT_D}/interface
SCT      := ${ROOT_D}/scripts
TBD      := ${ROOT_D}/test/tb
UVM      := ${ROOT_D}/test/uvm

FST      := ${ROOT_D}/flist.f
LOG      := ${ROOT_D}/log.debug

TESTTYPE    := TB
TOP         := tb_top

DEFINITION  := -d USE_AXI

TESTPLUSARG := --testplusarg UVM_VERBOSITY=UVM_HIGH
TESTPLUSARG += --testplusarg TESTNAME=${TESTNAME}

ifeq (${TESTTYPE}, UVM)
	TOP := axi_tb_top
endif

####
# DIRECTORY BUILDER
####

init:
	@echo "\033[7;32m//// INITIALIZING WORKSPACE... ///\033[0m"
	@mkdir -p src
	@mkdir -p include
	@touch include/dependencies.svh
	@python3 scripts/gen_dependencies_header.py include/dependencies.svh
	@mkdir -p scripts
	@mkdir -p interface
	@mkdir -p test/uvm
	@touch test/uvm/axi_tb_top.sv
	@python3 scripts/gen_uvm_top.py test/uvm/axi_tb_top.sv
	@mkdir -p test/uvm/testcases
	@mkdir -p test/uvm/components
	@mkdir -p test/uvm/inheritors
	@mkdir -p test/uvm/sequences
	@mkdir -p test/uvm/seq_items
	@mkdir -p test/uvm/objects
	@mkdir -p test/tb
	@touch test/tb/tb_top.sv
	@touch flist.f
	@touch log.debug

uvm_test_init:
	@echo "\033[7;32m//// INITIALIZING UVM TEST: ${TESTNAME}... ///\033[0m"
	@touch test/uvm/testcases/${TESTNAME}.sv
	@python3 scripts/uvm_gen_component.py test/uvm/testcases/${TESTNAME}.sv ${TESTNAME} uvm_test

uvm_component_init:
	@mkdir -p test/uvm/components/${COMPONENT}

	@touch test/uvm/components/${COMPONENT}/${COMPONENT}_driver.sv
	@python3 scripts/uvm_gen_component.py test/uvm/components/${COMPONENT}/${COMPONENT}_driver.sv ${COMPONENT}_driver uvm_driver

	@touch test/uvm/components/${COMPONENT}/${COMPONENT}_monitor.sv
	@python3 scripts/uvm_gen_component.py test/uvm/components/${COMPONENT}/${COMPONENT}_monitor.sv ${COMPONENT}_monitor uvm_monitor

	@touch test/uvm/components/${COMPONENT}/${COMPONENT}_sequencer.sv
	@python3 scripts/uvm_gen_component.py test/uvm/components/${COMPONENT}/${COMPONENT}_sequencer.sv ${COMPONENT}_sequencer uvm_sequencer

	@touch test/uvm/components/${COMPONENT}/${COMPONENT}_scoreboard.sv
	@python3 scripts/uvm_gen_component.py test/uvm/components/${COMPONENT}/${COMPONENT}_scoreboard.sv ${COMPONENT}_scoreboard uvm_scoreboard

	@touch test/uvm/components/${COMPONENT}/${COMPONENT}_agent.sv
	@python3 scripts/uvm_gen_component.py test/uvm/components/${COMPONENT}/${COMPONENT}_agent.sv ${COMPONENT}_agent uvm_agent

	@touch test/uvm/components/${COMPONENT}/${COMPONENT}_env.sv
	@python3 scripts/uvm_gen_component.py test/uvm/components/${COMPONENT}/${COMPONENT}_env.sv ${COMPONENT}_env uvm_env

uvm_seq_init:
	@touch test/uvm/sequences/${SEQUENCE}.sv
	@python3 scripts/uvm_gen_sequence.py test/uvm/sequences/${SEQUENCE}.sv ${SEQUENCE}

uvm_seq_item_init:
	@touch test/uvm/seq_items/${SEQ_ITEM}.sv
	@python3 scripts/uvm_gen_seq_item.py test/uvm/seq_items/${SEQ_ITEM}.sv ${SEQ_ITEM}

uvm_inheritor_init:
	@touch test/uvm/inheritors/${INHERITOR}.sv
	@python3 scripts/uvm_gen_inheritor.py test/uvm/inheritors/${INHERITOR}.sv ${INHERITOR} ${TESTNAME}

uvm_object_init:
	@touch test/uvm/objects/${OBJECT}.sv
	@python3 scripts/uvm_gen_object.py test/uvm/objects/${OBJECT}.sv ${OBJECT}

clean_uvm_test:
	@echo "\033[7;31m//// REMOVING UVM TEST: ${TESTNAME}... ///\033[0m"
	@rm -rf test/uvm/${TESTNAME}

deinit: clean
	@echo "\033[7;31m//// NUKING WORKSPACE... ///\033[0m"
	@rm -rf src
	@rm -rf include
	@rm -rf interface
	@rm -rf test
	@rm -rf scripts
	@rm -rf flist.f
	@rm -rf log.debug
	@rm -rf *.sh

####
# FLIST BUILDER
####

flist:
	@rm -rf ${FST}
	@touch ${FST}
	@echo "-i ${INC}"                                                                         >> ${FST}
	@find ${INF} -type f \( -name "*pkg.sv" -o -name "*pkg.v" \)                              >> ${FST}
	@find ${SRC} -type f \( -name "*pkg.sv" -o -name "*pkg.v" \)                              >> ${FST}
	@find ${TBD} -type f \( -name "*pkg.sv" -o -name "*pkg.v" \)                              >> ${FST}
	@find ${UVM} -type f \( -name "*pkg.sv" -o -name "*pkg.v" \)                              >> ${FST}

	@find ${INF} -type f \( -name "*.sv" -o -name "*.v" \) ! -name "*pkg.sv" ! -name "*pkg.v" >> ${FST}
	@find ${SRC} -type f \( -name "*.sv" -o -name "*.v" \) ! -name "*pkg.sv" ! -name "*pkg.v" >> ${FST}
	@find ${TBD} -type f \( -name "*.sv" -o -name "*.v" \) ! -name "*pkg.sv" ! -name "*pkg.v" >> ${FST}

	@find ${UVM} -type f -name "*seq_item.sv"   >> ${FST}
	@find ${UVM} -type f -name "*sequence.sv"   >> ${FST}
	@find ${UVM} -type f -name "*driver.sv"     >> ${FST}
	@find ${UVM} -type f -name "*monitor.sv"    >> ${FST}
	@find ${UVM} -type f -name "*sequencer.sv"  >> ${FST}
	@find ${UVM} -type f -name "*scoreboard.sv" >> ${FST}
	@find ${UVM} -type f -name "*agent.sv"      >> ${FST}
	@find ${UVM} -type f -name "*env.sv"        >> ${FST}
	@find ${UVM} -type f -name "*test.sv"       >> ${FST}
	@find ${UVM} -type f -name "axi_tb_top.sv"  >> ${FST}

####
# OPERATION THEATRE
####

clean:
	@echo "\033[7;31m//// PERFORMING CLEAN-UP... ///\033[0m"
	@rm -rf build
	@rm -rf log.debug

build: 
	@mkdir -p build

xvlog:
	@echo ""                                              | tee -a log.debug
	@echo "//// COMPILATION STAGE ////"                   | tee -a log.debug
	@echo ""                                              | tee -a log.debug
	@cd build; xvlog --sv -f ${FST} -L uvm  ${DEFINITION} | tee -a ../log.debug

xelab:
	@echo ""                                                            | tee -a log.debug
	@echo "//// ELABORATION STAGE ////"                                 | tee -a log.debug
	@echo ""                                                            | tee -a log.debug
	@cd build; xelab ${TOP} -s ${TOP} -timescale 1ns/1ps -debug typical | tee -a ../log.debug

xsim:
	@echo ""                                       | tee -a log.debug
	@echo "//// SIMULATION STAGE ////"             | tee -a log.debug
	@echo ""                                       | tee -a log.debug
	@cd build; xsim ${TOP} ${TESTPLUSARG} --runall | tee -a ../log.debug

gsim:
	@echo ""                                    | tee -a log.debug
	@echo "//// SIMULATION STAGE ////"          | tee -a log.debug
	@echo ""                                    | tee -a log.debug
	@cd build; xsim ${TOP} ${TESTPLUSARG} --gui | tee -a ../log.debug

run_sim: clean build xvlog xelab xsim
run_gui: clean build xvlog xelab gsim