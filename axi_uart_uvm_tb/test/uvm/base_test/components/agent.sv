`include "dependencies.svh"

class agent extends uvm_agent;
    `uvm_component_utils(agent);

    driver    u_driver;
    monitor   u_monitor;
    sequencer u_sequencer;

    function new(string name = "agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        u_driver = driver::type_id::create("u_driver", this);
        u_monitor = monitor::type_id::create("u_monitor", this);
        u_sequencer = sequencer::type_id::create("u_sequencer", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        u_driver.seq_item_port.connect(u_sequencer.seq_item_export);
    endfunction: connect_phase
    
    

endclass
