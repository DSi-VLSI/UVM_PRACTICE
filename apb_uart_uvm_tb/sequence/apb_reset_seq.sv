
//  Class: apb_reset_seq
//
class apb_reset_seq extends apb_base_seq;
    `uvm_object_utils(apb_reset_seq);

    seq_item item;

    function new(string name = "apb_reset_seq");
        super.new(name);
    endfunction


    task body();
        `uvm_info("", $sformatf("[Reset Sequence] :: Reset Sequence Body Inside"), UVM_HIGH);
        
        wait_for_grant();
        
        item = seq_item::type_id::create("item");   

        item.isReset = 1'b1;
        
        send_request(item); 

        `uvm_info("", $sformatf("[Reset Sequence] :: Sending Reset Item Sent"), UVM_HIGH);

        
        wait_for_item_done();

        


    endtask


    
endclass