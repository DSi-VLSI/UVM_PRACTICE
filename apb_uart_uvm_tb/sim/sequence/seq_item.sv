
class seq_item extends uvm_sequence_item;

    rand addr_width_t   paddr;
    rand data_width_t   pwdata;
    rand strb_width_t   pstrb;
    rand logic          pwrite; 
         logic          isReset;





    `uvm_object_utils_begin(seq_item)
        `uvm_field_int(paddr, UVM_ALL_ON)
        `uvm_field_int(pwdata, UVM_ALL_ON)
        `uvm_field_int(pstrb, UVM_ALL_ON)
        `uvm_field_int(pwrite, UVM_ALL_ON)
        `uvm_field_int(isReset, UVM_ALL_ON)
    `uvm_object_utils_end 



    function new(string name = "seq_item");
        super.new(name);
    endfunction

    

endclass

