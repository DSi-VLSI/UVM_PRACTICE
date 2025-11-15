
//  Class: apb_base_seq
//
class apb_base_seq extends uvm_sequence;

    import base_pkg::addr_t;
    import base_pkg::data_t;

    `uvm_object_utils(apb_base_seq);

    bit    isRandom;
    bit    isReset;

    addr_t addr;
    data_t data;
    logic  write; 

    function new(string name = "apb_base_seq");
        super.new(name);
        `uvm_info("APB_Base_Sequence", $sformatf("Constructed"), UVM_DEBUG);
    endfunction

    task body();
        `uvm_info("APB_Base_Sequence", $sformatf("Body Inside"), UVM_DEBUG);
    endtask


    


    
endclass