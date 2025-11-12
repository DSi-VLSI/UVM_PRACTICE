`include "dependencies.svh"

class base_test extends uvm_test;

    `uvm_component_utils(base_test)

    function new(string name="base_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    axi_env u_axi_env;
    virtual reset_intf u_reset_intf;
    uart_config_sequence u_uart_config_sequence;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(uvm_config_db #(virtual reset_intf)::get(
            this, "", "reset_intf", u_reset_intf
        )) begin
            `uvm_info(get_name(), "RESET INTERFACE FOUND", UVM_LOW)
        end else begin
            `uvm_error(get_name(), "RESET INTERFACE NOT FOUND")    
        end
        u_axi_env               = axi_env::type_id::create("u_axi_env", this);
        u_uart_config_sequence  = uart_config_sequence::type_id::create("u_uart_config_seq");
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        `uvm_info(get_name(), "INSIDE BASE_TEST", UVM_LOW)
        
        apply_reset();
        u_uart_config_sequence.start(u_axi_env.u_axi_agent.u_axi_sequencer);

        #100ns;
        `uvm_info(get_name(), "CLOSING BASE_TEST", UVM_LOW)
        phase.drop_objection(this);
    endtask

    task apply_reset();
        u_reset_intf.rst_n <= '1;
        repeat (2) @(posedge u_reset_intf.clk);
        u_reset_intf.rst_n <= '0;
        repeat (2) @(posedge u_reset_intf.clk);
        u_reset_intf.rst_n <= '1;
        repeat (2) @(posedge u_reset_intf.clk);
    endtask

endclass

    