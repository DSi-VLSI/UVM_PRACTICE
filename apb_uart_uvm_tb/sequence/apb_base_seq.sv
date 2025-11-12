
//  Class: apb_base_seq
//
class apb_base_seq extends uvm_sequence;

    import base_pkg::addr_t;
    import base_pkg::data_t;
    import base_pkg::strb_t;

    `uvm_object_utils(apb_base_seq);

    bit    isRandom;
    bit    isReset;
    addr_t paddr;
    data_t pwdata;
    strb_t pstrb;
    logic  pwrite; 

    function new(string name = "apb_base_seq");
        super.new(name);
        `uvm_info("", $sformatf("[Base Sequence] :: Base Sequence Constructed"), UVM_LOW);
    endfunction

    task body();
        `uvm_info("", $sformatf("[Base Sequence] :: Base Sequence Body Inside"), UVM_HIGH);
    endtask


    


    
endclass