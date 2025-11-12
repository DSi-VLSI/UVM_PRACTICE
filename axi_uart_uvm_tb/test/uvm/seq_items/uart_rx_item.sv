`include "dependencies.svh"

class uart_rx_item extends uvm_sequence_item;

    `uvm_object_utils(uart_rx_item)

    typedef logic [16:0] serial_to_parallel_t;
    serial_to_parallel_t rx_array;

    function new(string name="uart_rx_item");
        super.new(name);
    endfunction
    
endclass

