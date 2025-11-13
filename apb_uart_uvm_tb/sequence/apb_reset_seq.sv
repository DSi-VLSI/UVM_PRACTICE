
//  Class: apb_reset_seq
//
class apb_reset_seq extends apb_base_seq;
    `uvm_object_utils(apb_reset_seq);

    apb_seq_item item;

    function new(string name = "apb_reset_seq");
        super.new(name);
    endfunction


    task body();
        `uvm_info("Reset Sequence", $sformatf("handshaking start"), UVM_DEBUG);
        
        wait_for_grant();
        
        item = apb_seq_item::type_id::create("item");

        item.isReset = 1'b1;
        
        send_request(item); 

        `uvm_info("Reset Sequence", $sformatf("handshaking done"), UVM_DEBUG);

        
        wait_for_item_done();

        


    endtask


    
endclass