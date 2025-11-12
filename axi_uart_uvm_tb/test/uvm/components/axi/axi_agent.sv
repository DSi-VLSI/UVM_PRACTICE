`include "dependencies.svh"

class axi_agent extends uvm_agent;

    `uvm_component_utils(axi_agent)

    function new(string name="axi_agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    axi_driver      u_axi_driver;
    axi_monitor     u_axi_monitor;
    axi_sequencer   u_axi_sequencer;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        u_axi_driver        = axi_driver::type_id::create("u_axi_driver", this);
        u_axi_monitor       = axi_monitor::type_id::create("u_axi_monitor", this);
        u_axi_sequencer     = axi_sequencer::type_id::create("u_axi_sequencer", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        u_axi_driver.seq_item_port.connect(u_axi_sequencer.seq_item_export);
    endfunction

endclass

    