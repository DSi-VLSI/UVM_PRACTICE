`include "dependencies.svh"

class axi_env extends uvm_env;

    `uvm_component_utils(axi_env)

    function new(string name="axi_env", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    axi_agent       u_axi_agent;
    axi_scoreboard  u_axi_scoreboard;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        u_axi_agent         = axi_agent::type_id::create("u_axi_agent", this);
        u_axi_scoreboard    = axi_scoreboard::type_id::create("u_axi_scoreboard", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        u_axi_agent.u_axi_monitor.mon_analysis_port.connect(u_axi_scoreboard.m_analysis_imp);
    endfunction

endclass

    