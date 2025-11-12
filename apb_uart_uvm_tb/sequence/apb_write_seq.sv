
//  Class: apb_write_seq
//
class apb_write_seq extends apb_base_seq;
    `uvm_object_utils(apb_write_seq);

    seq_item item;

    function new(string name = "apb_write_seq");
        super.new(name);
    endfunction


    task body();
        `uvm_info("", $sformatf("[Write Sequence] :: Write Sequence Body Inside"), UVM_HIGH);
        
        wait_for_grant();
        
        item = seq_item::type_id::create("item");   

        if(isRandom) begin
            // assert(item.randomize());
        end else begin
            item.paddr  =   paddr;
            item.pwdata =   pwdata;
            item.pstrb  =   pstrb;
            item.pwrite =   1'b1;
        end
        
        send_request(item); 

        `uvm_info("", $sformatf("[Write Sequence] :: Sending Write Item Sent - Addr: 0x%0h, Data: 0x%0h", item.paddr, item.pwdata), UVM_HIGH);

        wait_for_item_done();

        


    endtask


    
endclass