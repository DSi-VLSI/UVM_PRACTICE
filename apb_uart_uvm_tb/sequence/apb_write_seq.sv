
//  Class: apb_write_seq
//
class apb_write_seq extends apb_base_seq;
    `uvm_object_utils(apb_write_seq);

    apb_seq_item item;

    function new(string name = "apb_write_seq");
        super.new(name);
    endfunction


    task body();
        `uvm_info("Write Sequence", $sformatf("Handshaking start"), UVM_DEBUG);
        
        wait_for_grant();
        
        item = apb_seq_item::type_id::create("item");   

        if(isRandom) begin
            // assert(item.randomize());
        end else begin
            item.paddr  =   paddr;
            item.pwdata =   pwdata;
            item.pstrb  =   pstrb;
            item.pwrite =   1'b1;
        end
        
        send_request(item); 

        `uvm_info("Write Sequence", $sformatf("Handshaking done"), UVM_DEBUG);

        wait_for_item_done();

        


    endtask


    
endclass