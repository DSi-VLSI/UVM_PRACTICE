`include "dependencies.svh"

class uart_tx_item extends uvm_sequence_item;

    `uvm_object_utils(uart_tx_item)

    typedef logic [16:0] serial_to_parallel_t;
    serial_to_parallel_t tx_array;

    function new(string name="uart_tx_item");
        super.new(name);
    endfunction
    
endclass

