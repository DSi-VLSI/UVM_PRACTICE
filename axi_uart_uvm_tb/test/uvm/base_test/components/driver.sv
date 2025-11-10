`include "dependencies.svh"

class driver extends uvm_driver #(dut_seq_item);
    `uvm_component_utils(driver)

    virtual axi_intf #(uvm_tb_axi_req_t, uvm_tb_axi_resp_t) u_axi_intf;

    function new(string name="driver", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(uvm_config_db #(virtual axi_intf #(uvm_tb_axi_req_t, uvm_tb_axi_resp_t))::get(
            this,
            "",
            "axi_intf_1",
            u_axi_intf
        )) begin
            `uvm_info("DRIVER", "AXI INTERFACE FOUND", UVM_LOW)
        end else begin
            `uvm_error("DRIVER", "AXI INTERFACE NOT FOUND")            
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        dut_seq_item item;
        super.run_phase(phase);
        
        forever begin
            item = dut_seq_item::type_id::create("dvr_item");
            @(posedge u_axi_intf.clk);
            seq_item_port.get_next_item(item);
            drive_item(item);
            seq_item_port.item_done(item);
        end
    endtask

    task drive_item(dut_seq_item item);
        `uvm_info("DRIVER::DRIVE_ITEM", "Item was driven to interface", UVM_LOW)
        u_axi_intf.rst_n <= item.rst_n;
    endtask
endclass