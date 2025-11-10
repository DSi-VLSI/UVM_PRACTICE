
//  Class: apb_base_seq
//
class apb_base_seq extends uvm_sequence;
    `uvm_object_utils(apb_base_seq);

    bit           isRandom;
    bit           isReset;
    addr_width_t  paddr;
    data_width_t  pwdata;
    strb_width_t  pstrb;
    logic         pwrite; 

    function new(string name = "apb_base_seq");
        super.new(name);
        `uvm_info(get_full_name(), $sformatf("[Base Sequence] :: Base Sequence Constructed"), UVM_LOW);
    endfunction

    task body();
        `uvm_info(get_full_name, $sformatf("[Base Sequence] :: Base Sequence Body Inside"), UVM_HIGH);
    endtask


    


    
endclass