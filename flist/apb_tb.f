-d USE_APB
-i ${REPO_ROOT}/include
-i ${REPO_ROOT}/apb_uart_uvm_tb/package
-i ${REPO_ROOT}/apb_uart_uvm_tb/test
-i ${REPO_ROOT}/apb_uart_uvm_tb/environment
-i ${REPO_ROOT}/apb_uart_uvm_tb/environment/agent/apb_agent
-i ${REPO_ROOT}/apb_uart_uvm_tb/environment/agent/uart_agent
-i ${REPO_ROOT}/apb_uart_uvm_tb/sequence

${REPO_ROOT}/apb_uart_uvm_tb/interface/uart_interface.sv
${REPO_ROOT}/apb_uart_uvm_tb/interface/apb_interface.sv
${REPO_ROOT}/apb_uart_uvm_tb/package/seq_pkg.sv
${REPO_ROOT}/apb_uart_uvm_tb/package/uart_agent_pkg.sv
${REPO_ROOT}/apb_uart_uvm_tb/package/apb_agent_pkg.sv
${REPO_ROOT}/apb_uart_uvm_tb/package/environment_pkg.sv
${REPO_ROOT}/apb_uart_uvm_tb/package/test_pkg.sv
${REPO_ROOT}/apb_uart_uvm_tb/tb_top/apb_tb_top.sv
-L uvm
