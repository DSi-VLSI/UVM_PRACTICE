
//  Class: apb_read_seq
//
class apb_read_seq extends apb_base_seq;
    `uvm_object_utils(apb_read_seq);

    apb_seq_item item;

    function new(string name = "apb_read_seq");
        super.new(name);
    endfunction


    task body();
        `uvm_info("Read Sequence", $sformatf("Handshaking start"), UVM_DEBUG);
        
        wait_for_grant();
        
        item = apb_seq_item::type_id::create("item");   

        if(isRandom) begin
            // assert(item.randomize());
        end else begin
            item.addr   =   addr;
            item.write =    0;
        end
        
        send_request(item); 

        `uvm_info("Read Sequence", $sformatf("Handshaking done"), UVM_DEBUG);

        wait_for_item_done();

        


    endtask


    
endclass