`include "dependencies.svh"

class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    virtual axi_intf #(uvm_tb_axi_req_t, uvm_tb_axi_resp_t) u_axi_intf;

    env u_env;
    reset_sequence u_reset_sequence;

    function new(string name="base_test", uvm_component parent=null);
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
            `uvm_info("BASE_TEST", "AXI INTERFACE FOUND", UVM_LOW)
        end else begin
            `uvm_error("BASE_TEST", "AXI INTERFACE NOT FOUND")            
        end
        u_env = env::type_id::create("u_env", this);
        u_reset_sequence = reset_sequence::type_id::create("u_reset_sequence");
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        `uvm_info("BASE_TEST", "INSIDE BASE TEST", UVM_LOW)
        repeat (2) begin
           @(posedge u_axi_intf.clk);
           `uvm_info("BASE_TEST", "CLOCK IS TICKING", UVM_LOW)
           `uvm_info("BASE_TEST", $sformatf("AW_VALID = %p", u_axi_intf.axi_req.aw_valid), UVM_LOW) 
        end
        u_reset_sequence.start(u_env.u_agent.u_sequencer);
        repeat (10) @(posedge u_axi_intf.clk); 
        phase.drop_objection(this);
    endtask

endclass