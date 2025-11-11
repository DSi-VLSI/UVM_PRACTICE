
package uart_agent_pkg;

    
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import seq_pkg::*;


    `include "uart_sequencer.sv"
    `include "uart_driver.sv"
    `include "uart_monitor.sv"
    `include "uart_agent.sv"
    
    
endpackage