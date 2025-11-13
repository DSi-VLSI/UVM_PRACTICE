
package seq_pkg;

    `include "uvm_macros.svh"
    import uvm_pkg::*;


    `include "reg_transaction.sv"
    `include "apb_seq_item.sv"
    `include "uart_seq_item.sv"
    `include "apb_base_seq.sv"
    `include "uart_base_seq.sv"
    `include "uart_rx_seq.sv"
    `include "apb_write_seq.sv"
    `include "apb_read_seq.sv"
    `include "apb_reset_seq.sv"
    
endpackage