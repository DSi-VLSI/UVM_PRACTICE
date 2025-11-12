`include "dependencies.svh"

class axi_driver extends uvm_driver #(dut_seq_item);

    `uvm_component_utils(axi_driver)

    virtual axi_intf #(
        uvm_tb_axi_req_t,
        uvm_tb_axi_resp_t
    ) u_axi_intf;

    function new(string name="axi_driver", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(uvm_config_db #(virtual axi_intf #(uvm_tb_axi_req_t, uvm_tb_axi_resp_t))::get(
            this, "", "axi_intf", u_axi_intf
        )) begin
            `uvm_info(get_name(), "AXI INTERFACE FOUND", UVM_LOW)
        end else begin
            `uvm_error(get_name(), "AXI INTERFACE NOT FOUND")    
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            dut_seq_item item;
            item = dut_seq_item::type_id::create("axi_driver_item");
            @(posedge u_axi_intf.clk);
            seq_item_port.get_next_item(item);
            drive_item(item);
            seq_item_port.item_done(item);
        end
    endtask

    task drive_item(dut_seq_item item);
        
        u_axi_intf.axi_req <= item.axi_req;
        item.axi_resp <= u_axi_intf.axi_resp;

    endtask

endclass

    