`include "dependencies.svh"

class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)

    virtual axi_intf #(uvm_tb_axi_req_t, uvm_tb_axi_resp_t) u_axi_intf;
    uvm_analysis_port #(dut_seq_item) mon_analysis_port;
    semaphore req_sem;
    semaphore resp_sem;

    function new(string name="monitor", uvm_component parent=null);
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
        mon_analysis_port = new("mon_analysis_port", this);
        req_sem = new(1);
        resp_sem = new(1);
    endfunction


endclass