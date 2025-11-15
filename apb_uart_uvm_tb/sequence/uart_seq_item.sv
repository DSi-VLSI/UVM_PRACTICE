
class uart_seq_item extends uvm_sequence_item;


    rand logic  [7:0]   data;
         bit            isTx;


    `uvm_object_utils_begin(uart_seq_item)
        `uvm_field_int(data, UVM_ALL_ON)
         `uvm_field_int(isTx, UVM_ALL_ON)
    `uvm_object_utils_end 


    function new(string name = "uart_seq_item");
        super.new(name);
        `uvm_info("Sequence Item", $sformatf("Item Constructed"), UVM_DEBUG);
    endfunction

    
endclass

