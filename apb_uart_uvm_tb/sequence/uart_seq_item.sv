
class uart_seq_item extends uvm_sequence_item;


    rand logic  [7:0]   rx_data;
    rand logic [10:0]   tx_data;
         bit            isTx;
         bit            isRx;



    `uvm_object_utils_begin(uart_seq_item)
        `uvm_field_int(rx_data, UVM_ALL_ON)
        `uvm_field_int(tx_data, UVM_ALL_ON)
    `uvm_object_utils_end 



    function new(string name = "uart_seq_item");
        super.new(name);
        `uvm_info("Sequence Item", $sformatf("Item Constructed"), UVM_DEBUG);
    endfunction

    

endclass

