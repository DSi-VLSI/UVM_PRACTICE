
//  Class: uart_base_seq
//
class uart_base_seq extends uvm_sequence;


    `uvm_object_utils(uart_base_seq);

    logic [7:0] data;
    bit         isRandom;


    function new(string name = "uart_base_seq");
        super.new(name);
        `uvm_info("UART_Base_Sequence", $sformatf("Constructed"), UVM_DEBUG);
    endfunction

    task body();
        `uvm_info("UART_Base_Sequence", $sformatf("Body Inside"), UVM_DEBUG);
    endtask


    
endclass