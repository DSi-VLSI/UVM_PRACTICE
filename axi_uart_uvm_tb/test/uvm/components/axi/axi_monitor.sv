`include "dependencies.svh"

class axi_monitor extends uvm_monitor;

    `uvm_component_utils(axi_monitor)

    function new(string name="axi_monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    uvm_analysis_port #(dut_seq_item) mon_analysis_port;
    virtual axi_intf #(
        .axi_req_t      (uvm_tb_axi_req_t),
        .axi_resp_t     (uvm_tb_axi_resp_t)
    )u_axi_intf;

    logic outstd_write_req;
    logic outstd_read_req;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_analysis_port = new("mon_analysis_port", this);
        if(uvm_config_db #(virtual axi_intf #(uvm_tb_axi_req_t, uvm_tb_axi_resp_t))::get(
            this, "", "axi_intf", u_axi_intf
        )) begin
            `uvm_info(get_name(), "AXI INTERFACE FOUND", UVM_HIGH)
        end else begin
            `uvm_error(get_name(), "AXI INTERFACE NOT FOUND")    
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            begin
                sample_port("write");
            end
            begin
                sample_port("read");
            end
        join
    endtask

    task sample_port(string tag="");
        dut_seq_item item;
        item = dut_seq_item::type_id::create("axi_mon_item");
        forever begin
            @(posedge u_axi_intf.clk);

            // AW, W, B
            if(tag == "write") begin
                if (u_axi_intf.axi_req.aw_valid && u_axi_intf.axi_resp.aw_ready) begin
                    outstd_write_req = '1;
                    item.axi_req.aw = u_axi_intf.axi_req.aw;
                end
                else if(u_axi_intf.axi_req.w_valid && u_axi_intf.axi_resp.w_ready && outstd_write_req) begin
                    for (int i = 0; i < xactn_len + 1; i++) begin
                        item.axi_req.w.data = u_axi_intf.axi_req.w.data;
                    end
                end
                else if(u_axi_intf.axi_req.b_ready && u_axi_intf.axi_resp.b_valid && outstd_write_req) begin
                    item.axi_resp.b = u_axi_intf.axi_resp.b;
                    outstd_write_req = '0;
                    `uvm_info(get_name(), "AXI WRITE ITEM SENT TO SCBD", UVM_HIGH)
                    mon_analysis_port.write(item);
                end
            end
            
            // AR, R
            else if (tag == "read") begin
                if (u_axi_intf.axi_req.ar_valid && u_axi_intf.axi_resp.ar_ready) begin
                    outstd_read_req = '1;
                    item.axi_req.ar = u_axi_intf.axi_req.ar;
                end
                else if(u_axi_intf.axi_req.r_ready && u_axi_intf.axi_resp.r_valid && outstd_read_req) begin
                    item.axi_resp.r = u_axi_intf.axi_resp.r;
                    outstd_write_req = '0;
                    `uvm_info(get_name(), "AXI READ ITEM SENT TO SCBD", UVM_HIGH)
                    mon_analysis_port.write(item);
                end
            end

        end
    endtask

endclass

    