`include "dependencies.svh"

class env extends uvm_env;
    `uvm_component_utils(env)

    agent u_agent;

    function new(string name="env", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        u_agent = agent::type_id::create("u_agent", this);
    endfunction

endclass