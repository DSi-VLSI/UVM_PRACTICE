
//  Class: uart_rx_seq
//
class uart_rx_seq extends uart_base_seq;
    `uvm_object_utils(uart_rx_seq);

    uart_seq_item item;

    function new(string name = "uart_rx_seq");
        super.new(name);
    endfunction


    task body();
        `uvm_info("UART_RX_Sequence", $sformatf("Handshaking start"), UVM_DEBUG);
        
        wait_for_grant();
        
        item = uart_seq_item::type_id::create("item");   

        if(isRandom) begin
            // assert(item.randomize());
        end else begin
            item.rx_data  =  rx_data;
        end
        
        send_request(item); 

        `uvm_info("UART_RX_Sequence", $sformatf("Handshaking done"), UVM_DEBUG);

        wait_for_item_done();

        


    endtask


    
endclass