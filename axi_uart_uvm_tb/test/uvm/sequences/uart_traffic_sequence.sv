`include "dependencies.svh"

class uart_traffic_sequence extends uvm_sequence;

    `uvm_object_utils(uart_traffic_sequence)

    function new(string name="uart_traffic_sequence");
        super.new(name);
    endfunction

    virtual task body();
        dut_seq_item item;

        empty_item(item);
        read_modify_write(item, 8'h14, 16'h9b, 4'hf);
    endtask
 
    task read_modify_write (dut_seq_item item, int addr, logic [31:0] wdata, logic [3:0] strb);
        read_at(item, addr);

        item = dut_seq_item::type_id::create("uart_config_item");
        start_item(item);
        item.axi_req = '0;
        item.axi_req.aw.id      = $urandom;
        item.axi_req.aw_valid   = '1;
        item.axi_req.aw.addr    = addr;
        item.axi_req.aw.len     = xactn_len;
        item.axi_req.aw.size    = 2;
        item.axi_req.aw.burst   = 1;
        
        item.axi_req.w_valid    = '0;

        item.axi_req.ar_valid   = '0;
        
        item.axi_req.b_ready    = '0;

        item.axi_req.r_ready    = '0;

        finish_item(item);

        for (int i = 0; i < xactn_len + 1; i++) begin
            item = dut_seq_item::type_id::create("uart_config_item");
            start_item(item);
            item.axi_req = '0;
            item.axi_req.aw_valid   = '0;

            item.axi_req.w_valid    = '1;
            item.axi_req.w.data     = wdata;
            item.axi_req.w.strb     = strb;
            if (i == xactn_len) item.axi_req.w.last = '1;
            else                item.axi_req.w.last = '0;

            item.axi_req.ar_valid   = '0;

            item.axi_req.b_ready    = '0;

            item.axi_req.r_ready    = '0;

            finish_item(item);
        end

        empty_item(item);

        item = dut_seq_item::type_id::create("uart_config_item");
        start_item(item);
        item.axi_req = '0;
        item.axi_req.aw_valid   = '0;

        item.axi_req.w_valid    = '0;

        item.axi_req.ar_valid   = '0;

        item.axi_req.b_ready    = '1;

        item.axi_req.r_ready    = '0;

        finish_item(item);

        empty_item(item);
        
    endtask

    task read_at (dut_seq_item item, int addr);
        item = dut_seq_item::type_id::create("uart_config_item");
        start_item(item);
        item.axi_req = '0;
        item.axi_req.aw_valid   = '0;
        
        item.axi_req.w_valid    = '0;

        item.axi_req.ar.id      = $urandom;
        item.axi_req.ar_valid   = '1;
        item.axi_req.ar.addr    = addr;
        item.axi_req.ar.len     = xactn_len;
        item.axi_req.ar.size    = 2;
        item.axi_req.ar.burst   = 1;

        item.axi_req.b_ready    = '0;

        item.axi_req.r_ready    = '0;

        finish_item(item);

        empty_item(item);
        
        repeat (xactn_len + 1) begin
            item = dut_seq_item::type_id::create("uart_config_item");
            start_item(item);
            item.axi_req = '0;
            item.axi_req.aw_valid   = '0;

            item.axi_req.w_valid    = '0;

            item.axi_req.ar_valid   = '0;

            item.axi_req.b_ready    = '0;

            item.axi_req.r_ready    = '1;

            finish_item(item);
        end

        empty_item(item);
    endtask
    
    task empty_item (dut_seq_item item);
        item = dut_seq_item::type_id::create("uart_config_item");
        start_item(item);
        item.axi_req = '0;
        item.axi_req.aw_valid   = '0;

        item.axi_req.w_valid    = '0;

        item.axi_req.ar_valid   = '0;

        item.axi_req.b_ready    = '0;

        item.axi_req.r_ready    = '0;

        finish_item(item);
    endtask

endclass

