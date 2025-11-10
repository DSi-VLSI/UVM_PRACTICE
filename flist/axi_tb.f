-d USE_AXI
-i ${REPO_ROOT}/include
-i ${REPO_ROOT}/axi_uart_uvm_tb/include
${REPO_ROOT}/package/axi_pkg.sv
${REPO_ROOT}/package/base_pkg.sv
${REPO_ROOT}/package/cf_math_pkg.sv
${REPO_ROOT}/axi_uart_uvm_tb/interface/axi_intf.sv
${REPO_ROOT}/axi_uart_uvm_tb/interface/uart_intf.sv
${REPO_ROOT}/axi_uart_uvm_tb/test/uvm/base_test/seq_items/dut_seq_item/dut_seq_item.sv
${REPO_ROOT}/axi_uart_uvm_tb/test/uvm/base_test/sequences/reset_sequence/reset_sequence.sv
${REPO_ROOT}/axi_uart_uvm_tb/test/uvm/base_test/components/driver.sv
${REPO_ROOT}/axi_uart_uvm_tb/test/uvm/base_test/components/monitor.sv
${REPO_ROOT}/axi_uart_uvm_tb/test/uvm/base_test/components/sequencer.sv
${REPO_ROOT}/axi_uart_uvm_tb/test/uvm/base_test/components/agent.sv
${REPO_ROOT}/axi_uart_uvm_tb/test/uvm/base_test/components/scoreboard.sv
${REPO_ROOT}/axi_uart_uvm_tb/test/uvm/base_test/components/env.sv
${REPO_ROOT}/axi_uart_uvm_tb/test/uvm/base_test/base_test.sv
${REPO_ROOT}/axi_uart_uvm_tb/test/uvm/base_test/inheritors/axi_xactn_test/axi_xactn_test.sv
${REPO_ROOT}/axi_uart_uvm_tb/test/uvm/axi_tb_top.sv
-L uvm
