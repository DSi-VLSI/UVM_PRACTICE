
class apb_seq_item extends uvm_sequence_item;

    import base_pkg::addr_t;
    import base_pkg::data_t;
    import base_pkg::strb_t;

    rand addr_t         addr;
    rand data_t         data;
    rand logic          write; 

         logic          isReset;


    `uvm_object_utils_begin(apb_seq_item)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(write, UVM_ALL_ON)
    `uvm_object_utils_end 



    function new(string name = "apb_seq_item");
        super.new(name);
        `uvm_info("Sequence Item", $sformatf("Item Constructed"), UVM_DEBUG);
    endfunction

    

endclass

